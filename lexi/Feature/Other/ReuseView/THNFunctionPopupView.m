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

/// title
static NSString *const kTitleSort           = @"排序";
static NSString *const kTitleScreen         = @"筛选";
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
/// 记录推荐的参数
@property (nonatomic, strong) NSMutableDictionary *recommandDict;
/// 记录选中的分类
@property (nonatomic, strong) NSMutableArray *categoryIdArr;
/// 最小价格
@property (nonatomic, assign) NSInteger minPrice;
/// 最大价格
@property (nonatomic, assign) NSInteger maxPrice;
/// 来源
@property (nonatomic, assign) THNLocalControllerType localType;

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
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) functionType:type];
}

#pragma mark - public methods
- (void)thn_showFunctionViewWithType:(THNFunctionPopupViewType)type {
    _viewType = type;
    self.titleText = type == THNFunctionPopupViewTypeSort ? kTitleSort : kTitleScreen;
    [self thn_screenViewHidden:type == THNFunctionPopupViewTypeSort];
    [self thn_showView:YES];
    
    [self layoutIfNeeded];
}

- (void)thn_setCategoryId:(NSInteger)cid {
    self.categoryId = cid;
    
    [THNGoodsManager getCategoryDataWithPid:cid completion:^(NSArray *categoryData, NSError *error) {
        if (error) return;
        
        [self.categoryView thn_setCollecitonViewCellData:categoryData];
    }];
}

- (void)thn_setCategoryData:(NSArray *)data {
    [self.categoryView thn_setCollecitonViewCellData:data];
}

- (void)thn_setLocalControllerType:(THNLocalControllerType)type {
    self.localType = type;
    
    NSArray *tags = nil;
    
    if (type == THNLocalControllerTypeDefault) {
        tags = @[kRecommandExpress, kRecommandSale, kRecommandCustomize];
        self.categoryView.hidden = NO;
        
    } else if (type == THNLocalControllerTypeUserGoods) {
        tags = @[kRecommandExpress, kRecommandSale];
        self.categoryView.hidden = YES;
    }
    
    [self.recommendView thn_setRecommandTag:tags];
}

#pragma mark - custom delegate
- (void)thn_selectedPriceSliderMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice {
    self.minPrice = minPrice;
    self.maxPrice = maxPrice;
    NSLog(@"最小价格 -- %zi , 最大价格 == %zi", minPrice, maxPrice);
    
    [self thn_requestScreenGoodsData];
}

- (void)thn_getCategoryId:(NSInteger)cid selected:(BOOL)selected {
    if (selected) {
        [self.categoryIdArr addObject:@(cid)];
        
    } else {
        [self.categoryIdArr removeObject:@(cid)];
    }
    
    NSLog(@"选中的分类 ======== %@", self.categoryIdArr);
    [self thn_requestScreenGoodsData];
}

- (void)thn_getRecommandTags:(NSString *)selectTag selected:(BOOL)selected {
    NSNumber *selectStatus = selected ? @(1) : @(0);
    
    if ([selectTag isEqualToString:kRecommandExpress]) {
        [self.recommandDict setObject:selectStatus forKey:kKeyExpress];
        
    } else if ([selectTag isEqualToString:kRecommandSale]) {
        [self.recommandDict setObject:selectStatus forKey:kKeySale];
        
    } else if ([selectTag isEqualToString:kRecommandCustomize]) {
        [self.recommandDict setObject:selectStatus forKey:kKeyCustomize];
    }
    
    NSLog(@"选中的推荐 ======== %@", self.recommandDict);
    [self thn_requestScreenGoodsData];
}

#pragma mark - private methods
/**
 根据筛选条件获取商品
 */
- (void)thn_requestScreenGoodsData {
    NSDictionary *params = nil;
    
    if (self.localType == THNLocalControllerTypeUserGoods) {
        params = @{
                   kKeyMinPrice: @(self.minPrice),
                   kKeyMaxPrice: @(self.maxPrice)};
    } else {
        params = @{kKeyId: @(self.categoryId),
                   kKeyCids: [self.categoryIdArr componentsJoinedByString:@","],
                   kKeyMinPrice: @(self.minPrice),
                   kKeyMaxPrice: @(self.maxPrice)};
    }
    
    [self.recommandDict setValuesForKeysWithDictionary:params];
    
    NSLog(@"请求参数 === %@", self.recommandDict);
    [self thn_setDoneButtonTitleWithGoodsCount:0 show:NO];
    [self.doneLoadingView startAnimating];
    
    if (self.localType == THNLocalControllerTypeUserGoods) {
        [THNGoodsManager getUserCenterProductsWithType:self.productsType
                                                params:self.recommandDict
                                            completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                                [self.doneLoadingView stopAnimating];
                                                if (error) return;
                                                
                                                [self thn_setDoneButtonTitleWithGoodsCount:count show:YES];
                                            }];
    } else {
        [THNGoodsManager getScreenProductsWithParams:self.recommandDict completion:^(NSDictionary *data, NSError *error) {
            [self.doneLoadingView stopAnimating];
            if (error) return;
            
            [self thn_setDoneButtonTitleWithGoodsCount:[data[kObjectCount] integerValue] show:YES];
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
}

/**
 显示隐藏筛选视图
 */
- (void)thn_screenViewHidden:(BOOL)hidden {
    self.screenView.hidden = hidden;
    self.sortTableView.hidden = !hidden;
    self.resetButton.hidden = hidden;
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self thn_showView:NO];
}

- (void)closeView:(UITapGestureRecognizer *)tap {
    [self thn_showView:NO];
}

/**
 重置筛选条件
 */
- (void)resetButtonAction:(UIButton *)button {
    [self.categoryIdArr removeAllObjects];
    [self.recommandDict removeAllObjects];
    [self.categoryView thn_resetLoad];
    [self.recommendView thn_resetLoad];
    [self.priceView thn_resetSliderValue];
    
    [self thn_requestScreenGoodsData];
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFunctionSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTHNFunctionSortTableViewCellId];
    if (!cell) {
        cell = [[THNFunctionSortTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                   reuseIdentifier:kTHNFunctionSortTableViewCellId];
    }
    
    if (indexPath.section == 0) {
        [cell thn_setCellTitleWithType:self.localType == THNLocalControllerTypeDefault ? THNFunctionSortTypeSynthesize \
                                      : THNFunctionSortTypeDefault];
    
    } else {
        [cell thn_setCellTitleWithType:indexPath.row == 0 ? THNFunctionSortTypePriceUp : THNFunctionSortTypePriceDown];
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFunctionSortTableViewCell *cell = (THNFunctionSortTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell thn_setCellSelected:NO];
    [self thn_showView:NO];
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.backgroudMaskView];
    
    //  筛选视图
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
    
    CGFloat screenViewH = self.localType == THNLocalControllerTypeUserGoods ? 370 : 460;
    CGFloat containerViewH = _viewType == THNFunctionPopupViewTypeSort ? 250 : screenViewH;
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
        if (self.localType == THNLocalControllerTypeUserGoods) {
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
    }
    return _resetButton;
}

- (NSMutableArray *)categoryIdArr {
    if (!_categoryIdArr) {
        _categoryIdArr = [NSMutableArray array];
    }
    return _categoryIdArr;
}

- (NSMutableDictionary *)recommandDict {
    if (!_recommandDict) {
        _recommandDict = [NSMutableDictionary dictionary];
    }
    return _recommandDict;
}

@end
