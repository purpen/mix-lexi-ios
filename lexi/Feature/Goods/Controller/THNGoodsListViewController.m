//
//  THNGoodsListViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsListViewController.h"
#import "THNLikedGoodsCollectionViewCell.h"
#import "THNFunctionButtonView.h"
#import "THNFunctionPopupView.h"
#import "THNGoodsManager.h"
#import "THNGoodsInfoViewController.h"
#import "THNGoodsListCollectionReusableView.h"
#import "UIScrollView+THNMJRefresh.h"

static NSString *const kCollectionViewCellId = @"THNLikedGoodsCollectionViewCellId";
static NSString *const kCollectionViewHeaderViewId = @"kCollectionViewHeaderViewId";
static NSString *const kDefualtCollectionViewHeaderViewId = @"kDefualtCollectionViewHeaderViewId";

@interface THNGoodsListViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    THNFunctionButtonViewDelegate,
    THNFunctionPopupViewDelegate,
    THNMJRefreshDelegate
>

/// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
/// 商品数据
@property (nonatomic, strong) NSMutableArray *modelArray;
/// 浏览的人数据
@property (nonatomic, strong) NSMutableArray *userArray;
/// 功能按钮
@property (nonatomic, strong) THNFunctionButtonView *functionView;
/// 功能视图
@property (nonatomic, strong) THNFunctionPopupView *popupView;
/// 获取商品的类型
@property (nonatomic, assign) THNUserCenterGoodsType userGoodsType;
/// 创建商品视图类型
@property (nonatomic, assign) THNGoodsListViewType goodsListType;
/// 分类的 id
@property (nonatomic, strong) NSString *categoryId;
/// 请求商品的数据
@property (nonatomic, strong) NSMutableDictionary *paramDict;
/// 页码
@property (nonatomic, assign) NSInteger currentPage;
/// 按最新排序  0=否, 1=是
@property (nonatomic, assign) NSInteger sortNewest;
/// 用户id
@property (nonatomic, strong) NSString *userId;
/// 栏目浏览人数
@property (nonatomic, assign) NSInteger userCount;
/// 返回顶部按钮
@property (nonatomic, strong) UIButton *backTopButton;

@end

@implementation THNGoodsListViewController

- (instancetype)initWithGoodsListType:(THNGoodsListViewType)type title:(NSString *)title {
    self = [super init];
    if (self) {
        self.navigationBarView.title = title;
        self.goodsListType = type;
        self.categoryId = 0;
    }
    return self;
}

- (instancetype)initWithCategoryId:(NSString *)categoryId categoryName:(NSString *)name {
    self = [super init];
    if (self) {
        self.navigationBarView.title = name;
        self.goodsListType = THNGoodsListViewTypeCategory;
        self.categoryId = categoryId;
    }
    return self;
}

- (instancetype)initWithUserCenterGoodsType:(THNUserCenterGoodsType)type title:(NSString *)title userId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.navigationBarView.title = title;
        self.goodsListType = THNGoodsListViewTypeUser;
        self.userGoodsType = type;
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestProductsDataWithType:self.goodsListType];
    [self.functionView thn_createFunctionButtonWithType:self.goodsListType];
    [self setupUI];
}

#pragma mark - network
- (void)requestProductsDataWithType:(THNGoodsListViewType)type {
    switch (type) {
        case THNGoodsListViewTypeUser: {
            [self thn_showFunctionView:YES];
            
            NSDictionary *params = [self thn_requestUserDefaultParams];
            [self.paramDict setDictionary:params];
            
            self.popupView.userGoodsType = self.userGoodsType;
            [self thn_getUserCenterProductsWithType:self.userGoodsType params:params loadMore:NO];
        }
            break;
            
        case THNGoodsListViewTypeCategory: {
            self.sortNewest = 0;
            [self thn_showFunctionView:YES];
            
            NSDictionary *params = [self thn_requestCategoryDefaultParams];
            [self.paramDict setDictionary:params];
            
            [self.popupView thn_setCategoryId:self.categoryId];
            [self thn_getCategoryProductsWithParams:params loadMore:NO];
        }
            break;
    
        case THNGoodsListViewTypeOptimal:
        case THNGoodsListViewTypeEditors:
        case THNGoodsListViewTypeNewProduct:
        case THNGoodsListViewTypeDesign:
        case THNGoodsListViewTypeGoodThing:
        case THNGoodsListViewTypeFreeShipping:
        case THNGoodsListViewTypeNewExpress: {
            [self thn_showFunctionView:type != THNGoodsListViewTypeGoodThing];
            
            NSDictionary *params = [self thn_requestColumnDefaultParams];
            [self.paramDict setDictionary:params];
            
            if ([self thn_showHeaderView]) {
                [self thn_getColumnRecordWithType:type params:@{@"per_page": @(12)}];
            }
            
            [self.popupView thn_setCategoryId:@"0"];
            [self thn_getColumnProductsWithType:type params:params loadMore:NO];
        }
            break;
            
        case THNGoodsListViewTypeCustomization: {
            [self thn_showFunctionView:NO];
            [self thn_getCustomizationProductsWithParams:[self thn_requestCustomizationParams] loadMore:NO];
        }
            
        default:
            break;
    }
}

// 获取个人中心商品数据
- (void)thn_getUserCenterProductsWithType:(THNUserCenterGoodsType)type params:(NSDictionary *)params loadMore:(BOOL)loadMore {
    if (!loadMore) {
        [SVProgressHUD thn_show];
    }
    
    WEAKSELF;
    
    [THNGoodsManager getUserCenterProductsWithType:type
                                            params:params
                                        completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                            if (error) {
                                                [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:NO];
                                                return;
                                            };
        
                                            [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:YES];
                                            [weakSelf.popupView thn_setDoneButtonTitleWithGoodsCount:count show:YES];
                                            [weakSelf thn_addModelFromGoodsDataArray:goodsData];
                                            [weakSelf.goodsCollectionView reloadData];
                                            [SVProgressHUD dismiss];
                                        }];
}

// 获取分类商品数据
- (void)thn_getCategoryProductsWithParams:(NSDictionary *)params loadMore:(BOOL)loadMore {
    if (!loadMore) {
        [SVProgressHUD thn_show];
    }
    
    WEAKSELF;
    
    [THNGoodsManager getCategoryProductsWithParams:params completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error) {
            [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:NO];
            return;
        };
        
        [weakSelf.popupView thn_setDoneButtonTitleWithGoodsCount:count show:YES];
        [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:YES];
        [weakSelf thn_addModelFromGoodsDataArray:[weakSelf thn_getRequestResultGoodsModel:goodsData]];
        [weakSelf.goodsCollectionView reloadData];
        [SVProgressHUD dismiss];
    }];
}

// 获取接单订制商品
- (void)thn_getCustomizationProductsWithParams:(NSDictionary *)params loadMore:(BOOL)loadMore {
    if (!loadMore) {
        [SVProgressHUD thn_show];
    }
    
    WEAKSELF;

    [THNGoodsManager getCustomizationProductsWithParams:params completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error) {
            [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:NO];
            return;
        };
        
        [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:YES];
        [weakSelf thn_addModelFromGoodsDataArray:[weakSelf thn_getRequestResultGoodsModel:goodsData]];
        [weakSelf.goodsCollectionView reloadData];
        [SVProgressHUD dismiss];
    }];
}

// 获取栏目商品
- (void)thn_getColumnProductsWithType:(THNGoodsListViewType)type params:(NSDictionary *)params loadMore:(BOOL)loadMore {
    if (!loadMore) {
        [SVProgressHUD thn_show];
    }
    
    WEAKSELF;
    
    [THNGoodsManager getColumnProductsWithListType:type
                                            params:params
                                        completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                            if (error) {
                                                [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:NO];
                                                return;
                                            };
        
                                            [weakSelf.popupView thn_setDoneButtonTitleWithGoodsCount:count show:YES];
                                            [weakSelf.goodsCollectionView endFooterRefreshAndCurrentPageChange:YES];
                                            [weakSelf thn_addModelFromGoodsDataArray:[weakSelf thn_getRequestResultGoodsModel:goodsData]];
                                            [weakSelf.goodsCollectionView reloadData];
                                            [SVProgressHUD dismiss];
                                        }];
}

// 获取栏目浏览记录
- (void)thn_getColumnRecordWithType:(THNGoodsListViewType)type params:(NSDictionary *)params {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNGoodsManager getColumnRecordWithListType:type
                                          params:params
                                      completion:^(NSArray *usersData, NSInteger count, NSError *error) {
                                          if (error) return;
                                          
                                          weakSelf.userCount = count;
                                          [weakSelf.userArray addObjectsFromArray:usersData];
                                          [weakSelf.goodsCollectionView reloadData];
                                          [SVProgressHUD dismiss];
                                      }];
}

#pragma mark - custom delegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    [self thn_reloadGoodsDataWithPage:currentPage.integerValue loadMore:YES];
}

- (void)thn_functionViewSelectedWithIndex:(NSInteger)index {
    if (index == 0) {
        [self.popupView thn_showFunctionViewWithType:(THNFunctionPopupViewTypeSort)];
        
    } else if (index == 1) {
        if (self.goodsListType == THNGoodsListViewTypeCategory) {
            [self thn_sortGoodsListOfNewest];

        } else {
            [self.popupView thn_showFunctionViewWithType:(THNFunctionPopupViewTypeScreen)];
        }
        
    } else if (index == 2) {
        [self.popupView thn_showFunctionViewWithType:(THNFunctionPopupViewTypeScreen)];
    }
}

// 最新
- (void)thn_sortGoodsListOfNewest {
    self.sortNewest = self.sortNewest == 0 ? 1 : 0;
    [self.paramDict setObject:@(self.sortNewest) forKey:@"sort_newest"];
    
    [self thn_reloadGoodsDataWithPage:1 loadMore:NO];
}

// 排序
- (void)thn_functionPopupViewType:(THNFunctionPopupViewType)viewType sortType:(NSInteger)type title:(NSString *)title {
    [self.functionView thn_setFunctionButtonSelected:NO];
    [self.functionView thn_setSelectedButtonTitle:title];
    
    [self.paramDict setObject:@(type) forKey:@"sort_type"];
    [self thn_reloadGoodsDataWithPage:1 loadMore:NO];
}

// 筛选
- (void)thn_functionPopupViewScreenParams:(NSDictionary *)screenParams count:(NSInteger)count {
    [self.functionView thn_setFunctionButtonSelected:NO];
    
    NSMutableString *screenStr = [NSMutableString stringWithFormat:@"筛选"];
    [screenStr appendString:count > 0 ? [NSString stringWithFormat:@" %zi", count] : @""];
    [self.functionView thn_setSelectedButtonTitle:screenStr];
    
    [self.paramDict setValuesForKeysWithDictionary:screenParams];
    [self thn_reloadGoodsDataWithPage:1 loadMore:NO];
}

// 关闭
- (void)thn_functionPopupViewClose {
    [self.functionView thn_setFunctionButtonSelected:NO];
}

#pragma mark - event response
- (void)backTopButtonAction:(UIButton *)button {
    [self.goodsCollectionView scrollToTopAnimated:YES];
}

#pragma mark - private methods
// 刷新商品数据
- (void)thn_reloadGoodsDataWithPage:(NSInteger)page loadMore:(BOOL)loadMore {
    if (!loadMore) {
        [self.goodsCollectionView resetCurrentPageNumber];
        [self.modelArray removeAllObjects];
    }
    
    self.currentPage = page;
    [self.paramDict setObject:@(page) forKey:@"page"];
    
    switch (self.goodsListType) {
        case THNGoodsListViewTypeUser: {
            [self thn_getUserCenterProductsWithType:self.userGoodsType params:self.paramDict loadMore:loadMore];
        }
            break;
            
        case THNGoodsListViewTypeCategory: {
            [self thn_getCategoryProductsWithParams:self.paramDict loadMore:loadMore];
        }
            break;
            
        case THNGoodsListViewTypeOptimal:
        case THNGoodsListViewTypeEditors:
        case THNGoodsListViewTypeNewProduct:
        case THNGoodsListViewTypeDesign:
        case THNGoodsListViewTypeGoodThing:
        case THNGoodsListViewTypeFreeShipping:
        case THNGoodsListViewTypeNewExpress: {
            [self thn_getColumnProductsWithType:self.goodsListType params:self.paramDict loadMore:loadMore];
        }
            break;
            
        case THNGoodsListViewTypeCustomization: {
            [self thn_getCustomizationProductsWithParams:self.paramDict loadMore:loadMore];
        }
            
        default:
            break;
    }
}

// 个人中心商品数据：默认的请求参数
- (NSDictionary *)thn_requestUserDefaultParams {
    NSDictionary *params = @{@"page"       : @(self.currentPage += 1),
                             @"per_page"   : @(10),
                             @"sort_newest": @(1)};
    
    if (self.userId.length) {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [paramDict setObject:self.userId forKey:@"uid"];
        
        return [paramDict copy];
    }

    return params;
}

// 分类商品数据：默认的请求参数
- (NSDictionary *)thn_requestCategoryDefaultParams {
    NSDictionary *params = @{@"id"      : self.categoryId,
                             @"page"    : @(self.currentPage += 1),
                             @"per_page": @(10),
                             @"status"  : @(1)};
    
    return params;
}

// 栏目商品数据：默认的请求参数
- (NSDictionary *)thn_requestColumnDefaultParams {
    NSDictionary *params = @{@"page"     : @(self.currentPage += 1),
                             @"per_page" : @(10),
                             @"view_more": @(1)};
    
    return params;
}

// 接单订制商品数据：默认的请求参数
- (NSDictionary *)thn_requestCustomizationParams {
    NSDictionary *params = @{@"page"    : @(self.currentPage += 1),
                             @"per_page": @(10)};
    
    return params;
}

/**
 获取请求的商品模型
 */
- (NSArray *)thn_getRequestResultGoodsModel:(NSArray *)goodsData {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in goodsData) {
        THNGoodsModel *model = [[THNGoodsModel alloc] initWithDictionary:dict];
        [modelArr addObject:model];
    }
    
    return [modelArr copy];
}

/**
 添加商品模型
 */
- (void)thn_addModelFromGoodsDataArray:(NSArray *)goodsDataArr {
    if (goodsDataArr.count) {
        [self.modelArray addObjectsFromArray:goodsDataArr];
        
    } else {
        [self.goodsCollectionView noMoreData];
    }
}

/**
 不显示筛选&排序功能栏
 */
- (void)thn_showFunctionView:(BOOL)show {
    self.functionView.hidden = !show;
    self.popupView.hidden = !show;
    
    CGFloat topH = [self thn_showHeaderView] ? 84 : 99;
    [self thn_setCollectionViewContentInsetTop:show ? topH : 54];
}

/**
 设置视图的偏移量
 */
- (void)thn_setCollectionViewContentInsetTop:(CGFloat)top {
    self.goodsCollectionView.contentInset = UIEdgeInsetsMake(top, 0, 20, 0);
}

/**
 是否显示头视图
 */
- (BOOL)thn_showHeaderView {
    switch (self.goodsListType) {
        case THNGoodsListViewTypeEditors:
        case THNGoodsListViewTypeNewProduct:
        case THNGoodsListViewTypeDesign:
        case THNGoodsListViewTypeGoodThing: {
            return YES;
        }
            break;
            
        default:
            break;
    }
    
    return NO;
}

/**
 显示回滚到顶部按钮
 */
- (void)thn_showBackTopButton:(BOOL)show {
    CGFloat originL = show ? 60 : 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backTopButton.frame = CGRectMake(SCREEN_WIDTH - originL, SCREEN_HEIGHT - 100, 45, 45);
    }];
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                      forIndexPath:indexPath];
    
    if (self.modelArray.count) {
        [cell thn_setGoodsCellViewType:(THNGoodsListCellViewTypeGoodsList)
                            goodsModel:(THNGoodsModel *)self.modelArray[indexPath.row]
                          showInfoView:YES
                                 index:indexPath.row];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self thn_showHeaderView]) {
        THNGoodsListCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderViewId
                                                                                                   forIndexPath:indexPath];
        [headerView thn_setShowContentWithListType:self.goodsListType
                                          userData:[self.userArray copy]
                                         userCount:self.userCount];

        return headerView;
    }
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:kDefualtCollectionViewHeaderViewId
                                                                                     forIndexPath:indexPath];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    
    return CGSizeMake(itemWidth, itemWidth + 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self thn_showHeaderView]) {
        return CGSizeMake(SCREEN_WIDTH, 225);
    }
    
    return CGSizeMake(0.01, 0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGoodsModel *model = self.modelArray[indexPath.row];
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:model.rid];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    BOOL maxOffset = offsetY <= 88;
    
    [self thn_showBackTopButton:!maxOffset];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.goodsCollectionView];
    [self.view addSubview:self.functionView];
    [self.view addSubview:self.backTopButton];
    [self.goodsCollectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.goodsCollectionView resetCurrentPageNumber];
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.popupView];
}

#pragma mark - getters and setters
- (UICollectionView *)goodsCollectionView {
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                  collectionViewLayout:flowLayout];
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        [_goodsCollectionView registerClass:[THNLikedGoodsCollectionViewCell class]
                 forCellWithReuseIdentifier:kCollectionViewCellId];
        [_goodsCollectionView registerClass:[THNGoodsListCollectionReusableView class]
                 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                        withReuseIdentifier:kCollectionViewHeaderViewId];
        [_goodsCollectionView registerClass:[UICollectionReusableView class]
                 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                        withReuseIdentifier:kDefualtCollectionViewHeaderViewId];
    }
    return _goodsCollectionView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (THNFunctionButtonView *)functionView {
    if (!_functionView) {
        _functionView = [[THNFunctionButtonView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 40)];
        _functionView.delegate = self;
    }
    return _functionView;
}

- (THNFunctionPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[THNFunctionPopupView alloc] init];
        [_popupView thn_setViewStyleWithGoodsListType:self.goodsListType];
        _popupView.delegate = self;
    }
    return _popupView;
}

- (UIButton *)backTopButton {
    if (!_backTopButton) {
        _backTopButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 100, 45, 45)];
        [_backTopButton setImage:[UIImage imageNamed:@"icon_back_top"] forState:(UIControlStateNormal)];
        _backTopButton.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _backTopButton.layer.shadowOpacity = 0.2;
        _backTopButton.layer.shadowOffset = CGSizeMake(0, 0);
        _backTopButton.layer.shadowRadius = 4;
        [_backTopButton addTarget:self action:@selector(backTopButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopButton;
}

- (NSMutableDictionary *)paramDict {
    if (!_paramDict) {
        _paramDict = [NSMutableDictionary dictionary];
    }
    return _paramDict;
}

@end
