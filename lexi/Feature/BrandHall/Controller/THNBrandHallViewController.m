//
//  THNBrandHallViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallViewController.h"
#import "THNBaseViewController.h"
#import "THNBrandHallHeaderView.h"
#import "THNAnnouncementView.h"
#import "THNCouponView.h"
#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"
#import "THNAPI.h"
#import "THNLoginManager.h"
#import "THNSelectButtonView.h"
#import "THNOffcialStoreModel.h"
#import "THNAnnouncementModel.h"

static NSString *const kUrlBrandHallCellIdentifier = @"kUrlBrandHallCellIdentifier";
static NSString *const kUrlBrandHallHeaderViewIdentifier = @"kUrlBrandHallHeaderViewIdentifier";
static NSString *const kUrlProductsByStore = @"/core_platforms/products/by_store";
static NSString *const kUrlOffcialStore = @"/official_store/info";
static NSString *const kUrlOffcialStoreAnnouncement = @"/official_store/announcement";
static NSString *const kUrlUserMasterCoupons = @"/market/user_master_coupons";
static NSString *const kUrlNotLoginCoupons = @"/market/not_login_coupons";

@interface THNBrandHallViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, THNNavigationBarViewDelegate>

@property (nonatomic, strong) THNBrandHallHeaderView *brandHallView;
@property (nonatomic, strong) THNAnnouncementView *announcementView;
@property (nonatomic, strong) THNCouponView *couponView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)  THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) THNAnnouncementModel *announcementModel;
@property (nonatomic, assign) CGFloat announcementViewHeight;
@property (nonatomic, assign) CGFloat couponViewHeight;
@property (nonatomic, strong) NSArray *fullReductions;
@property (nonatomic, strong) NSArray *loginCoupons;
@property (nonatomic, strong) NSArray *noLoginCoupons;

@end

@implementation THNBrandHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.couponViewHeight = 65;
    [THNLoginManager isLogin] ?  [self loadUserMasterCouponsData] : [self loadNotLoginCouponsData];
    [self loadOffcialStoreAnnouncementData];
    [self loadOffcialStoreData];
    [self loadProductsByStoreData];
    [self setupUI];
}

// 品牌馆商品
- (void)loadProductsByStoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlProductsByStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.dataArray = result.data[@"products"];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 品牌馆信息
- (void)loadOffcialStoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlOffcialStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNOffcialStoreModel *offcialStoreModel = [THNOffcialStoreModel mj_objectWithKeyValues:result.data];
        [self.brandHallView setOffcialStoreModel:offcialStoreModel];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 品牌馆公告
- (void)loadOffcialStoreAnnouncementData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlOffcialStoreAnnouncement requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.announcementModel = [THNAnnouncementModel mj_objectWithKeyValues:result.data];
        [self.announcementView setAnnouncementModel:self.announcementModel];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//已登录用户获取商家优惠券列表
- (void)loadUserMasterCouponsData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"store_rid"] = @"99130748";
    THNRequest *request = [THNAPI getWithUrlString:kUrlUserMasterCoupons requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.loginCoupons = result.data[@"coupons"];
        [self loadNotLoginCouponsData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//未登录用户获取商家优惠券列表
- (void)loadNotLoginCouponsData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"store_rid"] = @"99130748";
    THNRequest *request = [THNAPI getWithUrlString:kUrlNotLoginCoupons requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSArray *allCoupons = result.data[@"coupons"];
        // type = 3  满减   type = 1 或者 2  为优惠券
        NSPredicate *fullReductionPredicate = [NSPredicate predicateWithFormat:@"type = 3"];
        NSPredicate *couponPredicate = [NSPredicate predicateWithFormat:@"type = 1 || type = 2"];
        self.fullReductions = [allCoupons filteredArrayUsingPredicate:fullReductionPredicate];
        self.noLoginCoupons = [allCoupons filteredArrayUsingPredicate:couponPredicate];
//        [self.couponView layoutCouponView:self.fullReductions withLoginCoupons:self.loginCoupons withNologinCoupos:self.noLoginCoupons withHeightBlock:^(CGFloat couponViewHeight) {
//            self.couponViewHeight = couponViewHeight;
//        }];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_gray"];
    [self.view addSubview:self.collectionView];
     [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kUrlBrandHallCellIdentifier];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUrlBrandHallHeaderViewIdentifier];
     self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma UICollectionViewDataSourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUrlBrandHallCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    
    return CGSizeMake(itemWidth, itemWidth + 50);
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.announcementModel.announcement.length == 0) {
        self.announcementViewHeight = 0;
        self.announcementView.hidden = YES;
    } else {
        self.announcementView.hidden = NO;
        self.announcementViewHeight = self.announcementModel.is_closed ? 126 : 72;
    }
        
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, 265 + self.couponViewHeight + self.announcementViewHeight + 40 + 15 + 25);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUrlBrandHallHeaderViewIdentifier forIndexPath:indexPath];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    [headerView addSubview:self.brandHallView];
    [headerView addSubview:self.couponView];
    [headerView addSubview:self.announcementView];
    [headerView addSubview:self.selectButtonView];
    [headerView addSubview:lineView];
    
    [self.brandHallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(headerView);
        make.height.equalTo(@265);
    }];
    
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView).with.offset(20);
        make.trailing.equalTo(headerView).with.offset(-20);
        make.top.equalTo(self.brandHallView.mas_bottom).with.offset(15);
        make.height.equalTo(@65);
    }];
    
    [self.announcementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView).with.offset(20);
        make.trailing.equalTo(headerView).with.offset(-20);
        make.top.equalTo(self.couponView.mas_bottom).with.offset(20);
    }];
    
    [self.selectButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.announcementView.mas_bottom);
        make.leading.trailing.equalTo(headerView);
        make.height.equalTo(@40);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.selectButtonView);
        make.top.equalTo(self.selectButtonView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    
    [self.couponView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.couponViewHeight));
    }];
    
    [self.announcementView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.announcementViewHeight));
    }];
    
    return headerView;
}


#pragma mark - lazy
- (THNBrandHallHeaderView *)brandHallView {
    if (!_brandHallView) {
        _brandHallView = [THNBrandHallHeaderView viewFromXib];
    }
    return _brandHallView;
}

- (THNCouponView *)couponView {
    if (!_couponView) {
        _couponView = [THNCouponView viewFromXib];
    }
    return _couponView;
}

- (THNAnnouncementView *)announcementView {
    if (!_announcementView) {
        _announcementView = [THNAnnouncementView viewFromXib];
    }
    return _announcementView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"综合排序", @"筛选"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titleArray initWithButtonType:ButtonTypeTriangle];
    }
    return _selectButtonView;
}

@end
