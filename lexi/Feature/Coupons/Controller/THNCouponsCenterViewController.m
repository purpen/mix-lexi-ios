//
//  THNCouponsCenterViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponsCenterViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "THNCouponsCenterHeaderView.h"
#import "THNCouponCenterSectionView.h"

static NSString *const kTitleCouponsCenter  = @"领券中心";
static NSString *const kTextOfficial        = @"乐喜官方券";
static NSString *const kTextBrand           = @"精选品牌券";
static NSString *const kTextProduct         = @"精选商品券";
///
static NSString *const kRecommendCollectionCellId = @"kRecommendCollectionCell";
static NSString *const kCollectionHeaderViewId = @"kCollectionHeaderView";
static NSString *const kCollectionSectionViewId = @"kCollectionSectionView";

@interface THNCouponsCenterViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *recommendCollectionView;
@property (nonatomic, strong) NSArray *sectionTitles;

@end

@implementation THNCouponsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
    
    [self.view addSubview:self.recommendCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCouponsCenter;
}

#pragma mark - collection detasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
        
    } else if (section == 1) {
        return 1;
        
    } else if (section == 2) {
        return 6;
    }
    
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(0.01, 0.01);
        
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH - 30, 153);
        
    } else if (indexPath.section == 2) {
        CGFloat itemWidth = indexPath.row % 3 ? (SCREEN_WIDTH - 39) / 2 : SCREEN_WIDTH - 30;
        CGFloat itemHeight = indexPath.row % 3 ? 225 : 260;
        
        return CGSizeMake(itemWidth, itemHeight);
    
    }
    
    return CGSizeMake((SCREEN_WIDTH - 39) / 2, 264);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 150);
    }
    
    return CGSizeMake(SCREEN_WIDTH, 75);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCollectionCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNCouponsCenterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                    withReuseIdentifier:kCollectionHeaderViewId
                                                                                           forIndexPath:indexPath];
        
        return headerView;
    }
    
    THNCouponCenterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                 withReuseIdentifier:kCollectionSectionViewId
                                                                                        forIndexPath:indexPath];
    sectionView.title = self.sectionTitles[indexPath.section - 1];
    
    return sectionView;
}

#pragma mark - getters and setters
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
        _recommendCollectionView.contentInset = UIEdgeInsetsMake(44, 15, 15, 15);
        
        [_recommendCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kRecommendCollectionCellId];
        [_recommendCollectionView registerClass:[THNCouponsCenterHeaderView class]
                     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                            withReuseIdentifier:kCollectionHeaderViewId];
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
