//
//  THNCouponsCenterViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponsCenterViewController.h"
#import "THNCouponsCenterHeaderView.h"
#import "THNCouponCenterSectionView.h"
#import "THNCouponManager.h"
#import "THNLoginManager.h"
#import "THNGoodsManager.h"
#import "THNOfficialCollectionViewCell.h"
#import "THNBrandCouponCollectionViewCell.h"
#import "THNProductCouponCollectionViewCell.h"
#import "THNStoreCouponCollectionViewCell.h"
#import "THNNoneCouponView.h"
#import "THNMyCouponViewController.h"

static NSString *const kTitleCouponsCenter  = @"领券中心";
static NSString *const kTextOfficial        = @"乐喜官方券";
static NSString *const kTextBrand           = @"精选品牌券";
static NSString *const kTextProduct         = @"精选商品券";
///
static NSString *const kRecommendCollectionCellId    = @"kRecommendCollectionCell";
static NSString *const kCollectionHeaderViewId       = @"kCollectionHeaderView";
static NSString *const kCollectionSectionViewId      = @"kCollectionSectionView";
static NSString *const kOfficialCollectionViewCellId = @"THNOfficialCollectionViewCellId";
static NSString *const kBrandCollectionViewCellId    = @"THNBrandCouponCollectionViewCellId";
static NSString *const kProductCollectionViewCellId  = @"THNProductCouponCollectionViewCellId";
static NSString *const kStoreCollectionViewCellId    = @"THNStoreCouponCollectionViewCellId";

@interface THNCouponsCenterViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    THNCouponsCenterHeaderViewDelegate
> {
    THNCouponsType _couponType;
}

@property (nonatomic, strong) THNCouponsCenterHeaderView *headerView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, strong) THNNoneCouponView *defaultView;
@property (nonatomic, strong) UIButton *myCouponButton;
/// 推荐优惠券
@property (nonatomic, strong) UICollectionView *recommendCollectionView;
@property (nonatomic, strong) NSArray *officialCouponArr;
@property (nonatomic, strong) NSArray *brandCouponArr;
@property (nonatomic, strong) NSArray *productCouponArr;
/// 分类优惠券
@property (nonatomic, strong) UICollectionView *couponsCollectionView;
@property (nonatomic, strong) NSMutableArray *sharedCouponArr;
@property (nonatomic, strong) NSMutableArray *singleCouponArr;

@end

@implementation THNCouponsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_setCouponsCenterData];
}

#pragma mark - get data
- (void)thn_setCouponsCenterData {
    [SVProgressHUD thn_show];
    
    [self thn_getCategoryData];
    
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getOfficialCouponsDataWithGroup:group];
    [self thn_getBrandCouponsDataWithCategoryId:@"0" group:group];
    [self thn_getProductCouponsDataWithCategoryId:@"0" group:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.recommendCollectionView reloadData];
        [SVProgressHUD dismiss];
    });
}

/**
 获取官方券
 */
- (void)thn_getOfficialCouponsDataWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNCouponManager getCouponsCenterOfOfficialWithUserId:[self thn_getUserId]
                                                    completion:^(NSArray *data, NSError *error) {
                                                        dispatch_group_leave(group);
                                                        
                                                        if (error) return;
                                                        self.officialCouponArr = [NSArray arrayWithArray:data];
                                                    }];
    });
}

/**
 获取同享券（店铺）
 */
- (void)thn_getBrandCouponsDataWithCategoryId:(NSString *)categoryId group:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNCouponManager getCouponsCenterOfBrandWithCategory:categoryId
                                                       params:@{@"per_page": @(50)}
                                                   completion:^(NSArray *data, NSError *error) {
                                                       dispatch_group_leave(group);
                                                       
                                                       if (error) return;
                                                       
                                                       if ([categoryId isEqualToString:@"0"]) {
                                                           self.brandCouponArr = [NSArray arrayWithArray:data];
                                                           
                                                       } else {
                                                           [self.sharedCouponArr addObjectsFromArray:data];
                                                       }
                                                   }];
    });
}

/**
 获取单享券（商品）
 */
- (void)thn_getProductCouponsDataWithCategoryId:(NSString *)categoryId group:(dispatch_group_t)group {
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNCouponManager getCouponsCenterOfProductWithCategory:categoryId
                                                         params:@{@"per_page": @(50)}
                                                     completion:^(NSArray *data, NSError *error) {
                                                         dispatch_group_leave(group);
                                                         
                                                         if (error) return;
                                                         
                                                         if ([categoryId isEqualToString:@"0"]) {
                                                             self.productCouponArr = [NSArray arrayWithArray:data];
                                                             
                                                         } else {
                                                             [self.singleCouponArr addObjectsFromArray:data];
                                                         }
                                                     }];
    });
}

/**
 获取分类
 */
- (void)thn_getCategoryData {
    WEAKSELF;
    
    [THNGoodsManager getCategoryDataWithPid:@"0" completion:^(NSArray *categoryData, NSError *error) {
        [weakSelf.headerView thn_setCategoryData:categoryData];
    }];
}

/**
 根据分类 id 获取优惠券
 */
- (void)thn_getCouponeDataWithCategoryId:(NSString *)categoryId {
    [SVProgressHUD thn_show];
    
    dispatch_group_t group = dispatch_group_create();
    
    if (_couponType == THNCouponsTypeShared) {
        [self thn_getBrandCouponsDataWithCategoryId:categoryId group:group];
        
    } else if (_couponType == THNCouponsTypeSingle) {
        [self thn_getProductCouponsDataWithCategoryId:categoryId group:group];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.couponsCollectionView reloadData];
        [self thn_showCouponDefaultView];
        [SVProgressHUD dismiss];
    });
}

#pragma mark - custom delegate
// 切换分类
- (void)thn_didSelectedCategoryWithIndex:(NSInteger)index categoryId:(NSString *)categoryId {
    [self thn_changeCollectionViewFrameWithIndex:index];
    [self thn_fixedHeaderView];
    
    if (index == 0) {
        [self.recommendCollectionView setContentOffset:CGPointMake(0, -288) animated:NO];
        self.defaultView.alpha = 0;
        
    } else {
        [self.couponsCollectionView setContentOffset:CGPointMake(0, -343) animated:NO];
        [self.sharedCouponArr removeAllObjects];
        [self.singleCouponArr removeAllObjects];
        
        [self thn_getCouponeDataWithCategoryId:categoryId];
    }
}

// 切换同/单享券
- (void)thn_didSelectedCouponType:(NSInteger)type categoryId:(NSString *)categoryId {
    _couponType = (THNCouponsType)type;
    [self.singleCouponArr removeAllObjects];
    [self.sharedCouponArr removeAllObjects];
    
    [self thn_getCouponeDataWithCategoryId:categoryId];
}

#pragma mark - event response
- (void)myCouponButtonAction:(UIButton *)button {
    THNMyCouponViewController *myCouponVC = [[THNMyCouponViewController alloc] init];
    [self.navigationController pushViewController:myCouponVC animated:YES];
}

#pragma mark - private methods
// 固定头部广告位的位置
- (void)thn_fixedHeaderViewWithOriginY:(CGFloat)originY {
    CGFloat offsetY = self.originY - ((150 + self.originY + 44) + originY);
    offsetY = offsetY >= self.originY ? self.originY : offsetY;
    offsetY = offsetY <= self.originY - 150 ? self.originY - 150 : offsetY;
    
    CGPoint headerOriginY = CGPointMake(0, offsetY);
    self.headerView.origin = headerOriginY;
}

- (void)thn_fixedHeaderView {
    CGPoint headerOriginY = CGPointMake(0, self.originY);
    self.headerView.origin = headerOriginY;
}

// 切换优惠券列表
- (void)thn_changeCollectionViewFrameWithIndex:(NSInteger)index {
    CGFloat recommendOriginX = index == 0 ? 0 : -SCREEN_WIDTH;
    CGRect recommendFrame = CGRectMake(recommendOriginX, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    CGFloat couponOriginX = index == 0 ? SCREEN_WIDTH : 0;
    CGRect couponFrame = CGRectMake(couponOriginX, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.recommendCollectionView.frame = recommendFrame;
        self.couponsCollectionView.frame = couponFrame;
    }];
}

// 显示“没有优惠券”提示视图
- (void)thn_showCouponDefaultView {
    if (_couponType == THNCouponsTypeShared) {
        [UIView animateWithDuration:0.3 animations:^{
            self.defaultView.alpha = self.sharedCouponArr.count ? 0 : 1;
        }];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.defaultView.alpha = self.singleCouponArr.count ? 0 : 1;
        }];
    }
}

// 显示“我的优惠券”按钮
- (void)thn_showMyCouponButton {
    self.myCouponButton.hidden = ![THNLoginManager isLogin];
}

// 用户是否登录，获取 id
- (NSString *)thn_getUserId {
    return [THNLoginManager isLogin] ? [THNLoginManager sharedManager].userId : @"";
}

// 品牌券 cell size
- (CGSize)thn_getBrandCouponCellSizeWithIndexPath:(NSIndexPath *)indexPath {
    if (!self.brandCouponArr.count) {
        return CGSizeMake(SCREEN_WIDTH, 0.01);
    }
    
    CGFloat itemWidth = indexPath.row % 3 ? (SCREEN_WIDTH - 39) / 2 : SCREEN_WIDTH - 30;
    CGFloat itemHeight = indexPath.row % 3 ? 225 : 260;
    
    return CGSizeMake(itemWidth, itemHeight);
}

// 商品券 cell size
- (CGSize)thn_getProductCouponCellSize {
    if (!self.productCouponArr.count) {
        return CGSizeMake((SCREEN_WIDTH - 39) / 2, 0.01);
    }
    
    return CGSizeMake((SCREEN_WIDTH - 39) / 2, 264);
}

// 同/单享券 cell size
- (CGSize)thn_getSharedOrSingleCouponCellSizeWithIndexPath:(NSIndexPath *)indexPath {
    if (_couponType == THNCouponsTypeShared) {
        if (!self.sharedCouponArr.count) {
            return CGSizeMake(SCREEN_WIDTH, 0.01);
        }
        
        CGFloat itemWidth = indexPath.row % 3 ? (SCREEN_WIDTH - 39) / 2 : SCREEN_WIDTH - 30;
        CGFloat itemHeight = indexPath.row % 3 ? 225 : 260;
        
        return CGSizeMake(itemWidth, itemHeight);
        
    } else {
        if (!self.singleCouponArr.count) {
            return CGSizeMake((SCREEN_WIDTH - 39) / 2, 0.01);
        }
        
        return CGSizeMake((SCREEN_WIDTH - 39) / 2, 264);
    }
}

// 优惠券列表 item
- (NSInteger)thn_getCouponsCollectionViewItemsCount {
    NSInteger itemsCount = _couponType == THNCouponsTypeShared ? self.sharedCouponArr.count : self.singleCouponArr.count;
    
    return itemsCount;
}

#pragma mark - collection detasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return collectionView == self.recommendCollectionView ? 3 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.recommendCollectionView) {
        if (section == 0) {
            return 1;
            
        } else if (section == 1) {
            return self.brandCouponArr.count;
            
        } else if (section == 2) {
            return self.productCouponArr.count;
        }
    
    } else if (collectionView == self.couponsCollectionView) {
        return [self thn_getCouponsCollectionViewItemsCount];
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.recommendCollectionView) {
        if (indexPath.section == 0) {
            return CGSizeMake(SCREEN_WIDTH - 30, self.officialCouponArr.count ? 128 : 0.01);
            
        } else if (indexPath.section == 1) {
            return [self thn_getBrandCouponCellSizeWithIndexPath:indexPath];
            
        } else if (indexPath.section == 2) {
            return [self thn_getProductCouponCellSize];
        }
        
    } else if (collectionView == self.couponsCollectionView) {
        return [self thn_getSharedOrSingleCouponCellSizeWithIndexPath:indexPath];
    }

    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == self.recommendCollectionView) {
        if (section == 0) {
            return CGSizeMake(SCREEN_WIDTH, self.officialCouponArr.count ? 75 : 0.01);
            
        } else if (section == 1) {
            return CGSizeMake(SCREEN_WIDTH, self.brandCouponArr.count ? 75 : 0.01);
            
        } else if (section == 2) {
            return CGSizeMake(SCREEN_WIDTH, self.productCouponArr.count ? 75 : 0.01);
        }
    }
    
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.recommendCollectionView) {
        if (indexPath.section == 0) {
            THNOfficialCollectionViewCell *officialCell = [collectionView dequeueReusableCellWithReuseIdentifier:kOfficialCollectionViewCellId
                                                                                                    forIndexPath:indexPath];
            if (self.officialCouponArr.count) {
                [officialCell thn_setOfficialCouponData:self.officialCouponArr];
                officialCell.currentVC = self;
            }
            
            return officialCell;
            
        } else if (indexPath.section == 1) {
            if (indexPath.row % 3) {
                THNBrandCouponCollectionViewCell *brandCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandCollectionViewCellId
                                                                                                        forIndexPath:indexPath];
                if (self.brandCouponArr.count) {
                    [brandCell thn_setBrandCouponModel:self.brandCouponArr[indexPath.row]];
                    brandCell.currentVC = self;
                }
                
                return brandCell;
                
            } else {
                THNStoreCouponCollectionViewCell *storeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStoreCollectionViewCellId
                                                                                                        forIndexPath:indexPath];
                if (self.brandCouponArr.count) {
                    [storeCell thn_setStoreCouponModel:self.brandCouponArr[indexPath.row]];
                    storeCell.currentVC = self;
                }
                
                return storeCell;
            }
            
        } else if (indexPath.section == 2) {
            THNProductCouponCollectionViewCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCollectionViewCellId
                                                                                                        forIndexPath:indexPath];
            if (self.productCouponArr.count) {
                [productCell thn_setProductCouponModel:self.productCouponArr[indexPath.row]];
                productCell.currentVC = self;
            }
            
            return productCell;
        }
    
    } else if (collectionView == self.couponsCollectionView) {
        if (_couponType == THNCouponsTypeShared) {
            if (indexPath.row % 3) {
                THNBrandCouponCollectionViewCell *brandCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandCollectionViewCellId
                                                                                                        forIndexPath:indexPath];
                if (self.sharedCouponArr.count) {
                    [brandCell thn_setBrandCouponModel:self.sharedCouponArr[indexPath.row]];
                    brandCell.currentVC = self;
                }
                
                return brandCell;
                
            } else {
                THNStoreCouponCollectionViewCell *storeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStoreCollectionViewCellId
                                                                                                        forIndexPath:indexPath];
                if (self.sharedCouponArr.count) {
                    [storeCell thn_setStoreCouponModel:self.sharedCouponArr[indexPath.row]];
                    storeCell.currentVC = self;
                }
                
                return storeCell;
            }
            
        } else {
            THNProductCouponCollectionViewCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCollectionViewCellId
                                                                                                        forIndexPath:indexPath];
            if (self.singleCouponArr.count) {
                [productCell thn_setProductCouponModel:self.singleCouponArr[indexPath.row]];
                productCell.currentVC = self;
            }
            
            return productCell;
        }
    }
    
    return [UICollectionViewCell new];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.recommendCollectionView) {
        THNCouponCenterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:kCollectionSectionViewId
                                                                                            forIndexPath:indexPath];
        sectionView.title = self.sectionTitles[indexPath.section];
        
        return sectionView;
    }
    
    return [UICollectionReusableView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= self.originY) {
        [self thn_fixedHeaderViewWithOriginY:scrollView.contentOffset.y];
    }
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
    
    [self.view addSubview:self.recommendCollectionView];
    [self.view addSubview:self.couponsCollectionView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.defaultView];
    [self.view addSubview:self.myCouponButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self thn_showMyCouponButton];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCouponsCenter;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.recommendCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark - getters and setters
- (CGFloat)originY {
    return kDeviceiPhoneX ? 88 : 64;
}

- (THNCouponsCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNCouponsCenterHeaderView alloc] initWithFrame:CGRectMake(0, self.originY, SCREEN_WIDTH, 240)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UICollectionView *)recommendCollectionView {
    if (!_recommendCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                      collectionViewLayout:flowLayout];
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
        _recommendCollectionView.showsVerticalScrollIndicator = NO;
        _recommendCollectionView.contentInset = UIEdgeInsetsMake(240, 0, 15, 0);
        
        [_recommendCollectionView registerClass:[UICollectionViewCell class]
                     forCellWithReuseIdentifier:kRecommendCollectionCellId];
        
        [_recommendCollectionView registerClass:[THNOfficialCollectionViewCell class]
                     forCellWithReuseIdentifier:kOfficialCollectionViewCellId];
        
        [_recommendCollectionView registerClass:[THNBrandCouponCollectionViewCell class]
                     forCellWithReuseIdentifier:kBrandCollectionViewCellId];
        
        [_recommendCollectionView registerClass:[THNStoreCouponCollectionViewCell class]
                     forCellWithReuseIdentifier:kStoreCollectionViewCellId];
        
        [_recommendCollectionView registerClass:[THNProductCouponCollectionViewCell class]
                     forCellWithReuseIdentifier:kProductCollectionViewCellId];
        
        [_recommendCollectionView registerClass:[THNCouponCenterSectionView class]
                     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                            withReuseIdentifier:kCollectionSectionViewId];
    }
    return _recommendCollectionView;
}

- (UICollectionView *)couponsCollectionView {
    if (!_couponsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _couponsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                    collectionViewLayout:flowLayout];
        _couponsCollectionView.delegate = self;
        _couponsCollectionView.dataSource = self;
        _couponsCollectionView.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
        _couponsCollectionView.showsVerticalScrollIndicator = NO;
        _couponsCollectionView.contentInset = UIEdgeInsetsMake(240 + 44 + 15, 0, 15, 0);
        
        [_couponsCollectionView registerClass:[THNBrandCouponCollectionViewCell class]
                   forCellWithReuseIdentifier:kBrandCollectionViewCellId];
        
        [_couponsCollectionView registerClass:[THNStoreCouponCollectionViewCell class]
                   forCellWithReuseIdentifier:kStoreCollectionViewCellId];
        
        [_couponsCollectionView registerClass:[THNProductCouponCollectionViewCell class]
                   forCellWithReuseIdentifier:kProductCollectionViewCellId];
        
        [_couponsCollectionView registerClass:[UICollectionReusableView class]
                   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                          withReuseIdentifier:kCollectionSectionViewId];
    }
    return _couponsCollectionView;
}

- (UIButton *)myCouponButton {
    if (!_myCouponButton) {
        _myCouponButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 76, SCREEN_HEIGHT - 200, 78, 30)];
        [_myCouponButton setImage:[UIImage imageNamed:@"coupon_my"] forState:(UIControlStateNormal)];
        [_myCouponButton addTarget:self action:@selector(myCouponButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _myCouponButton;
}

- (THNNoneCouponView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[THNNoneCouponView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 100)];
        _defaultView.alpha = 0;
    }
    return _defaultView;
}

- (NSArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = @[kTextOfficial, kTextBrand, kTextProduct];
    }
    return _sectionTitles;
}

- (NSMutableArray *)sharedCouponArr {
    if (!_sharedCouponArr) {
        _sharedCouponArr = [NSMutableArray array];
    }
    return _sharedCouponArr;
}

- (NSMutableArray *)singleCouponArr {
    if (!_singleCouponArr) {
        _singleCouponArr = [NSMutableArray array];
    }
    return _singleCouponArr;
}

@end
