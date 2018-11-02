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

static NSString *const kTitleCouponsCenter  = @"领券中心";
static NSString *const kTextOfficial        = @"乐喜官方券";
static NSString *const kTextBrand           = @"精选品牌券";
static NSString *const kTextProduct         = @"精选商品券";
///
static NSString *const kRecommendCollectionCellId    = @"kRecommendCollectionCell";
static NSString *const kCollectionHeaderViewId       = @"kCollectionHeaderView";
static NSString *const kCollectionSectionViewId      = @"kCollectionSectionView";
static NSString *const kOfficialCollectionViewCellId = @"THNOfficialCollectionViewCellId";

@interface THNCouponsCenterViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    THNCouponsCenterHeaderViewDelegate
>

@property (nonatomic, strong) UICollectionView *recommendCollectionView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) THNCouponsCenterHeaderView *headerView;
@property (nonatomic, assign) CGFloat originY;

@end

@implementation THNCouponsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_getCategoryData];
    [self thn_getOfficialCouponsData];
    [self thn_getBrandCouponsDataWithCategoryId:@"0"];
    [self thn_getProductCouponsDataWithCategoryId:@"0"];
}

#pragma mark - get data
/**
 获取官方券
 */
- (void)thn_getOfficialCouponsData {
    [THNCouponManager getCouponsCenterOfOfficialWithUserId:[self thn_getUserId]
                                                completion:^(NSArray *data, NSError *error) {
        
                                                }];
}

/**
 获取同享券（店铺）
 */
- (void)thn_getBrandCouponsDataWithCategoryId:(NSString *)categoryId {
    [THNCouponManager getCouponsCenterOfBrandWithCategory:categoryId
                                                   params:@{}
                                               completion:^(NSArray *data, NSError *error) {
        
                                               }];
}

/**
 获取单享券（商品）
 */
- (void)thn_getProductCouponsDataWithCategoryId:(NSString *)categoryId {
    [THNCouponManager getCouponsCenterOfProductWithCategory:categoryId
                                                     params:@{}
                                                 completion:^(NSArray *data, NSError *error) {
        
                                                 }];
}

/**
 获取分类
 */
- (void)thn_getCategoryData {
    WEAKSELF;
    
    [THNGoodsManager getCategoryDataWithPid:0 completion:^(NSArray *categoryData, NSError *error) {
        NSLog(@"---------- 所有分类：%@", categoryData);
        [weakSelf.headerView thn_setCategoryData:categoryData];
    }];
}

#pragma mark - custom delegate
- (void)thn_didSelectedCategoryWithIndex:(NSInteger)index {
    NSLog(@"=========== 选中分类：%zi", index);
}

- (void)thn_didSelectedCouponType:(NSInteger)type {
    NSLog(@"=========== 选中类型：%zi", type);
}

#pragma mark - private methods
- (void)thn_fixedHeaderViewWithOriginY:(CGFloat)originY {
    CGFloat offsetY = self.originY - ((150 + self.originY + 44) + originY);
    offsetY = offsetY > self.originY ? self.originY : offsetY;
    offsetY = offsetY < self.originY - 150 ? self.originY - 150 : offsetY;
    
    CGPoint headerOriginY = CGPointMake(0, offsetY);
    self.headerView.origin = headerOriginY;
}

- (NSString *)thn_getUserId {
    return [THNLoginManager isLogin] ? [THNLoginManager sharedManager].userId : @"";
}

#pragma mark - collection detasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
        
    } else if (section == 1) {
        return 6;
    }
    
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH - 30, 128);
        
    } else if (indexPath.section == 1) {
        CGFloat itemWidth = indexPath.row % 3 ? (SCREEN_WIDTH - 39) / 2 : SCREEN_WIDTH - 30;
        CGFloat itemHeight = indexPath.row % 3 ? 225 : 260;
        
        return CGSizeMake(itemWidth, itemHeight);
    
    }
    
    return CGSizeMake((SCREEN_WIDTH - 39) / 2, 264);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 75);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNOfficialCollectionViewCell *officialCell = [collectionView dequeueReusableCellWithReuseIdentifier:kOfficialCollectionViewCellId
                                                                                                forIndexPath:indexPath];
        return officialCell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCollectionCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    THNCouponCenterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                 withReuseIdentifier:kCollectionSectionViewId
                                                                                        forIndexPath:indexPath];
    sectionView.title = self.sectionTitles[indexPath.section];
    
    return sectionView;
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
    [self.view addSubview:self.headerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCouponsCenter;
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
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                      collectionViewLayout:flowLayout];
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
        _recommendCollectionView.showsVerticalScrollIndicator = NO;
        _recommendCollectionView.contentInset = UIEdgeInsetsMake(150 + 88, 15, 15, 15);
        
        [_recommendCollectionView registerClass:[UICollectionViewCell class]
                     forCellWithReuseIdentifier:kRecommendCollectionCellId];
        [_recommendCollectionView registerClass:[THNOfficialCollectionViewCell class]
                     forCellWithReuseIdentifier:kOfficialCollectionViewCellId];
        
        [_recommendCollectionView registerClass:[THNCouponCenterSectionView class]
                     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                            withReuseIdentifier:kCollectionSectionViewId];
    }
    return _recommendCollectionView;
}

- (NSArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = @[kTextOfficial, kTextBrand, kTextProduct];
    }
    return _sectionTitles;
}

@end
