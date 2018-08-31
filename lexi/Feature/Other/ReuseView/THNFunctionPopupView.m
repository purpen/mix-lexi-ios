//
//  THNFunctionPopupView.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionPopupView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"
#import "THNConst.h"
#import "THNFunctionCollectionView.h"
#import "THNPriceSliderView.h"
#import "THNFunctionSortTableViewCell.h"
#import "THNGoodsManager.h"

/// title
static NSString *const kTitleSort           = @"排序";
static NSString *const kTitleScreen         = @"筛选";
static NSString *const kTitleProfit         = @"利润";
static NSString *const kTitleDone           = @"查看商品";
static NSString *const kTitleReset          = @"重置";
static NSString *const kTitlePrice          = @"价格";
/// 推荐标签
static NSString *const kRecommandExpress    = @"包邮";
static NSString *const kRecommandSale       = @"特惠";
static NSString *const kRecommandCustomize  = @"可定制";
/// 请求参数字段
static NSString *const kKeyExpress          = @"is_free_postage";
static NSString *const kKeySale             = @"is_preferential";
static NSString *const kKeyCustomize        = @"is_custom_made";
static NSString *const kKeyId               = @"id";
static NSString *const kKeyCids             = @"cids";
static NSString *const kKeyMinPrice         = @"min_price";
static NSString *const kKeyMaxPrice         = @"max_price";
/// 获取数据参数
static NSString *const kObjectCount         = @"count";
/// CELL ID
static NSString *const kTHNFunctionSortTableViewCellId = @"kTHNFunctionSortTableViewCellId";

@interface THNFunctionPopupView () <
    THNPriceSliderViewDelegate,
    THNFunctionCollectionViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource
> {
    THNFunctionPopupViewType _viewType;
}

/// 背景遮罩
@property (nonatomic, strong) UIView *backgroudMaskView;
/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 排序容器
@property (nonatomic, strong) UITableView *sortTableView;
/// 筛选容器
@property (nonatomic, strong) UIView *screenView;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 标题文字内容
@property (nonatomic, strong) NSArray *titleArr;
/// 价格滑块
@property (nonatomic, strong) THNPriceSliderView *priceView;
/// 分类列表
@property (nonatomic, strong) THNFunctionCollectionView *categoryView;
/// 推荐列表
@property (nonatomic, strong) THNFunctionCollectionView *recommendView;
/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 加载动画
@property (nonatomic, strong) UIActivityIndicatorView *doneLoadingView;
/// 重置按钮
@property (nonatomic, strong) UIButton *resetButton;
/// 记录筛选后的参数
@property (nonatomic, strong) NSMutableDictionary *paramsDict;
/// 记录选中的分类
@property (nonatomic, strong) NSMutableArray *categoryIdArr;
/// 最小价格
@property (nonatomic, assign) NSInteger minPrice;
/// 最大价格
@property (nonatomic, assign) NSInteger maxPrice;
/// 来源
@property (nonatomic, assign) THNGoodsListViewType goodsListType;
/// 选中条件数量
@property (nonatomic, assign) NSInteger selectedCount;
/// 选中的排序单元格
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
/// 选中的利润排序单元格
@property (nonatomic, strong) NSIndexPath *selectedProfitIndexPath;

@end

@implementation THNFunctionPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame functionType:(THNFunctionPopupViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _viewType = type;
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFunctionType:(THNFunctionPopupViewType)type {
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
                  functionType:type];
}

#pragma mark - public methods
/**
 显示筛选或者排序
 
 @param type 显示类型
 */
- (void)thn_showFunctionViewWithType:(THNFunctionPopupViewType)type {
    _viewType = type;
    
    self.titleText = self.titleArr[(NSUInteger)type];
    [self thn_showResetButton];
    [self thn_showScreenView:type == THNFunctionPopupViewTypeScreen];
    [self thn_showView:YES];
    [self thn_reloadSortTable];
    
    [self layoutIfNeeded];
}

/**
 请求子分类

 @param cid 父类 id
 */
- (void)thn_setCategoryId:(NSInteger)cid {
    self.categoryId = cid;
    
    [THNGoodsManager getCategoryDataWithPid:cid completion:^(NSArray *categoryData, NSError *error) {
        if (error) return;
        
        [self.categoryView thn_setCollecitonViewCellData:categoryData];
    }];
}

/**
 设置子分类

 @param data 分类数据
 */
- (void)thn_setCategoryData:(NSArray *)data {
    [self.categoryView thn_setCollecitonViewCellData:data];
}

/**
 页面进入类型
 */
- (void)thn_setViewStyleWithGoodsListType:(THNGoodsListViewType)type {
    self.goodsListType = type;
    
    NSArray *tags = nil;
    
    switch (type) {
        case THNGoodsListViewTypeUser: {
            tags = @[kRecommandExpress, kRecommandSale];
            self.categoryView.hidden = YES;
        }
            break;
        case THNGoodsListViewTypeProductCenter:{
            self.recommendView.hidden = YES;
        }
            break;
        default: {
            tags = @[kRecommandExpress, kRecommandSale, kRecommandCustomize];
            self.categoryView.hidden = NO;
        }
            break;
    }
    
    [self.recommendView thn_setRecommandTag:tags];
}

#pragma mark - custom delegate
- (void)thn_selectedPriceSliderMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice {
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    
    NSInteger minCount = minPrice == 0 ? -1 : 1;
    self.selectedCount += minCount;
    
    NSInteger maxCount = maxPrice == 0 ? -1 : 1;
    self.selectedCount += maxCount;
    
    [self thn_requestScreenGoodsData];
}

- (void)thn_getCategoryId:(NSInteger)cid selected:(BOOL)selected {
    if (selected) {
        [self.categoryIdArr addObject:@(cid)];
        self.selectedCount += 1;
        
    } else {
        [self.categoryIdArr removeObject:@(cid)];
        self.selectedCount -= 1;
    }
    
    [self thn_requestScreenGoodsData];
}

- (void)thn_getRecommandTags:(NSString *)selectTag selected:(BOOL)selected {
    NSNumber *selectStatus = selected ? @(1) : @(0);
    NSInteger count = selected ? 1 : -1;
    self.selectedCount += count;
    
    if ([selectTag isEqualToString:kRecommandExpress]) {
        [self.paramsDict setObject:selectStatus forKey:kKeyExpress];
        
    } else if ([selectTag isEqualToString:kRecommandSale]) {
        [self.paramsDict setObject:selectStatus forKey:kKeySale];
        
    } else if ([selectTag isEqualToString:kRecommandCustomize]) {
        [self.paramsDict setObject:selectStatus forKey:kKeyCustomize];
    }

    [self thn_requestScreenGoodsData];
}

#pragma mark - private methods
/**
 根据筛选条件获取商品
 */
- (void)thn_requestScreenGoodsData {
    [self thn_showResetButton];
    
    // 请求参数
    NSDictionary *params = nil;
    
    if (self.goodsListType == THNGoodsListViewTypeUser) {
        params = @{
                   kKeyMinPrice: @(self.minPrice),
                   kKeyMaxPrice: @(self.maxPrice)};
    } else {
        params = @{kKeyId: @(self.categoryId),
                   kKeyCids: [self.categoryIdArr componentsJoinedByString:@","],
                   kKeyMinPrice: @(self.minPrice),
                   kKeyMaxPrice: @(self.maxPrice)};
    }
    
    [self.paramsDict setValuesForKeysWithDictionary:params];
    
    [self thn_setDoneButtonTitleWithGoodsCount:0 show:NO];
    [self.doneLoadingView startAnimating];
    
    // 网络请求
    if (self.goodsListType == THNGoodsListViewTypeUser) {
        [THNGoodsManager getUserCenterProductsWithType:self.userGoodsType
                                                params:self.paramsDict
                                            completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                                [self.doneLoadingView stopAnimating];
                                                if (error) return;
                                                
                                                [self thn_setDoneButtonTitleWithGoodsCount:count show:YES];
                                            }];
    } else {
        [THNGoodsManager getProductCountWithType:self.goodsListType params:params completion:^(NSInteger count, NSError *error) {
            [self.doneLoadingView stopAnimating];
            if (error) return;
            
            [self thn_setDoneButtonTitleWithGoodsCount:count show:YES];
        }];
    }
}

- (void)thn_showView:(BOOL)show {
    CGFloat backgroudAlpha = show ? 1 : 0;
    CGRect selfRect = CGRectMake(0, show ? 0 : SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:(NSTimeInterval)0.3 animations:^{
        self.backgroudMaskView.hidden = YES;
        self.frame = selfRect;
        self.backgroudMaskView.alpha = backgroudAlpha;

    } completion:^(BOOL finished) {
        self.backgroudMaskView.hidden = !show;
    }];
}

- (void)thn_setDoneButtonTitleWithGoodsCount:(NSInteger)count show:(BOOL)show {
    NSString *title = show ? [NSString stringWithFormat:@"%@（%zi）", kTitleDone, count] : @"";
    [self.doneButton setTitle:title forState:(UIControlStateNormal)];
    self.doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:count == 0 ? 0.5 : 1];
    self.doneButton.userInteractionEnabled = count == 0 ? NO : YES;
}

/**
 显示隐藏筛选视图
 */
- (void)thn_showScreenView:(BOOL)show {
    self.screenView.hidden = !show;
    self.sortTableView.hidden = show;
}

/**
 显示“重置”按钮
 */
- (void)thn_showResetButton {
    if (_viewType == THNFunctionPopupViewTypeScreen) {
        if (self.categoryIdArr.count || self.paramsDict.count || self.minPrice > 0 || self.maxPrice > 0) {
            self.resetButton.hidden = NO;
            
        } else {
            self.resetButton.hidden = YES;
        }
        
    } else {
        self.resetButton.hidden = YES;
    }
}

/**
 刷新排序单元格
 */
- (void)thn_reloadSortTable {
    if (_viewType == THNFunctionPopupViewTypeScreen) return;
    
    [self.sortTableView reloadData];
}

#pragma mark - event response
/**
 查看商品
 */
- (void)doneButtonAction:(UIButton *)button {
    [self thn_showView:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_functionPopupViewScreenParams:count:)]) {
        [self.delegate thn_functionPopupViewScreenParams:[self.paramsDict copy] count:self.selectedCount];
    }
}

- (void)closeButtonAction:(UIButton *)button {
    [self thn_showView:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_functionPopupViewClose)]) {
        [self.delegate thn_functionPopupViewClose];
    }
}

- (void)closeView:(UITapGestureRecognizer *)tap {
    [self thn_showView:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_functionPopupViewClose)]) {
        [self.delegate thn_functionPopupViewClose];
    }
}

/**
 重置筛选条件
 */
- (void)resetButtonAction:(UIButton *)button {
    self.selectedCount = 0;
    [self.categoryView thn_resetLoad];
    [self.recommendView thn_resetLoad];
    [self.priceView thn_resetSliderValue];
    
    [self.categoryIdArr removeAllObjects];
    [self.paramsDict removeAllObjects];
    self.minPrice = 0;
    self.maxPrice = 0;
    
    [self thn_requestScreenGoodsData];
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewType == THNFunctionPopupViewTypeProfitSort ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsListType == THNGoodsListViewTypeStore) {
        return 2;
    }
    
    NSInteger rowCount = _viewType == THNFunctionPopupViewTypeProfitSort ? 3 : 1;
    return section == 0 ? rowCount : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFunctionSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTHNFunctionSortTableViewCellId];
    if (!cell) {
        cell = [[THNFunctionSortTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                   reuseIdentifier:kTHNFunctionSortTableViewCellId];
    }
    
    if (indexPath.section == 0) {
        if (_viewType == THNFunctionPopupViewTypeProfitSort) {
            NSInteger sortIndex = indexPath.row == 0 ? 0 : 1;
            [cell thn_setSortConditionWithType:(THNFunctionSortType)indexPath.row + sortIndex];
            
            if (indexPath == self.selectedProfitIndexPath) {
                [cell thn_setCellSelected:YES];
            }
            
        } else {
            if (self.goodsListType == THNGoodsListViewTypeUser) {
                [cell thn_setSortConditionWithType:(THNFunctionSortTypeDefault)];
                
            } else if (self.goodsListType == THNGoodsListViewTypeStore) {
                [cell thn_setSortConditionWithType:indexPath.row == 0 ? THNFunctionSortTypeSynthesize : THNFunctionSortTypeNewest];
                
            } else {
                [cell thn_setSortConditionWithType:(THNFunctionSortTypeSynthesize)];
            }
            
            if (indexPath == self.selectedIndexPath) {
                [cell thn_setCellSelected:YES];
            }
        }
    
    } else {
        [cell thn_setSortConditionWithType:indexPath.row == 0 ? THNFunctionSortTypePriceUp : THNFunctionSortTypePriceDown];
        
        if (indexPath == self.selectedIndexPath) {
            [cell thn_setCellSelected:YES];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    priceLable.text = kTitlePrice;
    priceLable.font = [UIFont systemFontOfSize:12];
    priceLable.textColor = [UIColor colorWithHexString:@"#555555"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [headerView addSubview:priceLable];
    
    return section == 0 ? [UIView new] : headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    THNFunctionSortTableViewCell *cell = (THNFunctionSortTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell thn_setCellSelected:YES];
    [self thn_showView:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_functionPopupViewType:sortType:title:)]) {
        [self.delegate thn_functionPopupViewType:_viewType sortType:(NSInteger)cell.sortType title:cell.titleLabel.text];
    }
    
    if (_viewType == THNFunctionPopupViewTypeSort) {
        self.selectedIndexPath = indexPath;
        self.selectedProfitIndexPath = nil;
        
    } else {
        self.selectedProfitIndexPath = indexPath;
        self.selectedIndexPath = nil;

    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_viewType == THNFunctionPopupViewTypeSort) {
        THNFunctionSortTableViewCell *cell = (THNFunctionSortTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell thn_setCellSelected:NO];
        [self thn_showView:NO];
    }

    THNFunctionSortTableViewCell *cell = (THNFunctionSortTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell thn_setCellSelected:NO];

}

#pragma mark - setup UI
- (void)setupViewUI {
    self.titleArr = @[kTitleSort, kTitleScreen, kTitleProfit];
    
    // 背景遮罩
    [self addSubview:self.backgroudMaskView];
    
    // 筛选视图
    [self.screenView addSubview:self.priceView];
    [self.screenView addSubview:self.categoryView];
    [self.screenView addSubview:self.recommendView];
    [self.doneButton addSubview:self.doneLoadingView];
    [self.screenView addSubview:self.doneButton];
    
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.resetButton];
    [self.containerView addSubview:self.screenView];
    [self.containerView addSubview:self.sortTableView];
    [self addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroudMaskView.frame = self.bounds;
    
    CGFloat screenViewH = self.goodsListType == THNGoodsListViewTypeUser || self.goodsListType == THNGoodsListViewTypeProductCenter ? 370 : 460;
    CGFloat containerViewH = _viewType == THNFunctionPopupViewTypeScreen ? screenViewH : 250;
    
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - containerViewH, CGRectGetWidth(self.bounds), containerViewH);
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(0);
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    [self.sortTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(55);
        make.bottom.mas_equalTo(-25);
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        make.top.equalTo(self.priceView.mas_bottom).with.offset(30);
    }];
    
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        if (self.goodsListType == THNGoodsListViewTypeUser) {
            make.top.equalTo(self.priceView.mas_bottom).with.offset(30);
        } else {
            make.top.equalTo(self.categoryView.mas_bottom).with.offset(30);
        }
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.doneLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.doneButton);
    }];
}

#pragma mark - getters and setters
- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (UIView *)backgroudMaskView {
    if (!_backgroudMaskView) {
        _backgroudMaskView = [[UIView alloc] init];
        _backgroudMaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
        [_backgroudMaskView addGestureRecognizer:tap];
    }
    return _backgroudMaskView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UITableView *)sortTableView {
    if (!_sortTableView) {
        _sortTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _sortTableView.delegate = self;
        _sortTableView.dataSource = self;
        _sortTableView.showsVerticalScrollIndicator = NO;
        _sortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sortTableView.tableFooterView = [UIView new];
        _sortTableView.bounces = NO;
        _sortTableView.backgroundColor = [UIColor colorWithHexString:kColorBackground];
    }
    return _sortTableView;
}

- (UIView *)screenView {
    if (!_screenView) {
        _screenView = [[UIView alloc] init];
        _screenView.backgroundColor = [UIColor whiteColor];
    }
    return _screenView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_gray"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (THNPriceSliderView *)priceView {
    if (!_priceView) {
        _priceView = [[THNPriceSliderView alloc] init];
        _priceView.delegate = self;
    }
    return _priceView;
}

- (THNFunctionCollectionView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[THNFunctionCollectionView alloc] initWithFrame:CGRectZero
                                                                viewType:(THNFunctionCollectionViewTypeCategory)];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (THNFunctionCollectionView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[THNFunctionCollectionView alloc] initWithFrame:CGRectZero
                                                                 viewType:(THNFunctionCollectionViewTypeRecommend)];
        _recommendView.delegate = self;
    }
    return _recommendView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _doneButton.layer.cornerRadius = 4;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (UIActivityIndicatorView *)doneLoadingView {
    if (!_doneLoadingView) {
        _doneLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    }
    return _doneLoadingView;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        [_resetButton setTitle:kTitleReset forState:(UIControlStateNormal)];
        [_resetButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateNormal)];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _resetButton.hidden = YES;
    }
    return _resetButton;
}

- (NSMutableArray *)categoryIdArr {
    if (!_categoryIdArr) {
        _categoryIdArr = [NSMutableArray array];
    }
    return _categoryIdArr;
}

- (NSMutableDictionary *)paramsDict {
    if (!_paramsDict) {
        _paramsDict = [NSMutableDictionary dictionary];
    }
    return _paramsDict;
}

#pragma mark -
- (void)dealloc {
    [self.doneLoadingView stopAnimating];
}

@end
