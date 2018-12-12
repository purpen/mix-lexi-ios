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
#import "THNGrassListCollectionViewCell.h"
#import "THNProductModel.h"
#import "THNAPI.h"
#import "THNLoginManager.h"
#import "THNSelectButtonView.h"
#import "THNOffcialStoreModel.h"
#import "THNAnnouncementModel.h"
#import "THNGrassListModel.h"
#import "THNFeatureTableViewCell.h"
#import "THNFunctionPopupView.h"
#import "THNFunctionButtonView.h"
#import "THNConst.h"
#import "THNSaveTool.h"
#import "THNGoodsInfoViewController.h"
#import "THNArticleViewController.h"
#import "THNBrandHallStoryViewController.h"
#import "UIViewController+THNHud.h"
#import "THNShareViewController.h"
#import "THNConst.h"
#import "THNWebKitViewViewController.h"

static NSString *const kBrandHallProductCellIdentifier = @"kBrandHallProductCellIdentifier";
static NSString *const kBrandHallLifeRecordsCellIdentifier = @"kBrandHallLifeRecordsCellIdentifier";
static NSString *const kBrandHallHeaderViewIdentifier = @"kBrandHallHeaderViewIdentifier";
static NSString *const kUrlProductsByStore = @"/core_platforms/products/by_store";
static NSString *const kUrlOffcialStore = @"/official_store/info";
static NSString *const kUrlOffcialStoreAnnouncement = @"/official_store/announcement";
static NSString *const kUrlUserMasterCoupons = @"/market/user_master_coupons";
static NSString *const kUrlNotLoginCoupons = @"/market/not_login_coupons";
static NSString *const kUrlLifeRecords = @"/core_platforms/life_records";

@interface THNBrandHallViewController () <
UICollectionViewDataSource,
UICollectionViewDelegate,
THNNavigationBarViewDelegate,
THNBrandHallHeaderViewDelegate,
THNFunctionButtonViewDelegate,
THNFunctionPopupViewDelegate,
THNMJRefreshDelegate
>

@property (nonatomic, strong) THNBrandHallHeaderView *brandHallView;
@property (nonatomic, strong) THNAnnouncementView *announcementView;
@property (nonatomic, strong) THNCouponView *couponView;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) THNAnnouncementModel *announcementModel;
@property (nonatomic, assign) CGFloat announcementViewHeight;
@property (nonatomic, assign) CGFloat couponViewHeight;
@property (nonatomic, strong) NSArray *fullReductions;
@property (nonatomic, strong) NSArray *loginCoupons;
@property (nonatomic, strong) NSArray *noLoginCoupons;
@property (nonatomic, strong) NSArray *lifeRecords;
@property (nonatomic, assign) BrandShowType  brandShowType;
@property (nonatomic, strong) UICollectionReusableView *headerView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) THNOffcialStoreModel *offcialStoreModel;
// 设置商品的弹窗
@property (nonatomic, strong) THNFunctionPopupView *popupView;
// 设置商品的buttonView
@property (nonatomic, strong) THNFunctionButtonView *functionView;
// 商品筛选的参数
@property (nonatomic, strong) NSDictionary *producrConditionParams;
// 是否展示文章
@property (nonatomic, assign) BOOL isRecords;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNBrandHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 存储品牌馆ID
    [THNSaveTool setObject:self.rid forKey:kBrandHallRid];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self showHud];
    
    dispatch_group_async(group, queue, ^{
        [self loadOffcialStoreData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadOffcialStoreAnnouncementData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadProductsByStoreData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadCouponData];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenHud];
            [self setupLayout];
            [self.collectionView reloadData];
        });
    });
}

- (void)loadCouponData {
    [THNLoginManager isLogin] ?  [self loadUserMasterCouponsData] : [self loadNotLoginCouponsData];
}

// 品牌馆商品
- (void)loadProductsByStoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = self.rid;
    // 商品类别 0: 全部; 1：自营商品；2：分销商品
    params[@"is_distributed"] = @(1);
    params[@"page"] = @(self.currentPage);
    [params setValuesForKeysWithDictionary:self.producrConditionParams];
    THNRequest *request = [THNAPI getWithUrlString:kUrlProductsByStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSInteger signalQuantity = dispatch_semaphore_signal(self.semaphore);

        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [self.collectionView endFooterRefreshAndCurrentPageChange:YES];
        NSArray *products = result.data[@"products"];
        [self.products addObjectsFromArray:products];
        
        if (![result.data[@"next"] boolValue] && self.products.count != 0) {
            
            [self.collectionView noMoreData];
        }
        
        [self.popupView thn_setDoneButtonTitleWithGoodsCount:[result.data[@"count"] integerValue] show:YES];
        if (signalQuantity == 0) {
            [self.collectionView reloadData];
        }
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 品牌馆信息
- (void)loadOffcialStoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlOffcialStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.offcialStoreModel = [THNOffcialStoreModel mj_objectWithKeyValues:result.data];
        [self.brandHallView setOffcialStoreModel:self.offcialStoreModel];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 品牌馆公告
- (void)loadOffcialStoreAnnouncementData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlOffcialStoreAnnouncement requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.announcementModel = [THNAnnouncementModel mj_objectWithKeyValues:result.data];
        [self.announcementView setAnnouncementModel:self.announcementModel];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

//已登录用户获取商家优惠券列表
- (void)loadUserMasterCouponsData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"store_rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlUserMasterCoupons requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        self.loginCoupons = result.data[@"coupons"];
        [self loadNotLoginCouponsData];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

//未登录用户获取商家优惠券列表
- (void)loadNotLoginCouponsData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"store_rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlNotLoginCoupons requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        NSArray *allCoupons = result.data[@"coupons"];
        // type = 3  满减   type = 1 或者 2  为优惠券
        NSPredicate *fullReductionPredicate = [NSPredicate predicateWithFormat:@"type = 3"];
        NSPredicate *couponPredicate = [NSPredicate predicateWithFormat:@"type = 1 || type = 2"];
        self.fullReductions = [allCoupons filteredArrayUsingPredicate:fullReductionPredicate];
        
        if (![THNLoginManager isLogin]) {
              self.noLoginCoupons = [allCoupons filteredArrayUsingPredicate:couponPredicate];
        }
      
        self.couponViewHeight =  [self.couponView layoutCouponView:self.fullReductions withLoginCoupons:self.loginCoupons withNologinCoupos:self.noLoginCoupons];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

//生活志列表
- (void)loadLifeRecordData{
    [SVProgressHUD thn_show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecords requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        self.lifeRecords = result.data[@"life_records"];
        [self.collectionView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)setupUI {
    self.brandShowType = BrandShowTypeProduct;
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share"];
    
    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeBrandStore)
                                                                             requestId:weakSelf.rid];
        [shareVC shareObjectWithTitle:weakSelf.offcialStoreModel.name
                                descr:weakSelf.offcialStoreModel.tag_line
                            thumImage:weakSelf.offcialStoreModel.logo
                               webUrl:[kShareBrandHallPrefix stringByAppendingString:weakSelf.rid]];
        shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:shareVC animated:NO completion:nil];
    }];
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.popupView];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandHallProductCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNGrassListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandHallLifeRecordsCellIdentifier];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kBrandHallHeaderViewIdentifier];
     self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)setupLayout {
    if (self.headerView.subviews.count == 0) {
        [self.headerView addSubview:self.brandHallView];
        self.brandHallView.delegate = self;
        [self.headerView addSubview:self.couponView];
        [self.headerView addSubview:self.announcementView];
        [self.headerView addSubview:self.functionView];
        [self.functionView thn_createFunctionButtonWithType:THNGoodsListViewTypeStore];
        [self.headerView addSubview:self.lineView];
    }
    
    if (self.announcementModel.announcement.length == 0) {
        self.announcementViewHeight = 0;
        self.announcementView.hidden = YES;
    } else {
        self.announcementView.hidden = NO;
        self.announcementViewHeight = self.announcementModel.is_closed ? 126 : 72;
    }
    
    if (self.isRecords) {
        self.couponView.hidden = YES;
        self.announcementView.hidden = YES;
        self.functionView.hidden = YES;
        self.lineView.hidden = YES;
    } else {
        self.couponView.hidden = NO;
        self.announcementView.hidden = NO;
        self.functionView.hidden = NO;
        self.lineView.hidden = NO;
    }
    
    [self.brandHallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.headerView);
        make.height.equalTo(@265);
    }];
    
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).with.offset(20);
        make.trailing.equalTo(self.headerView).with.offset(-20);
        make.top.equalTo(self.brandHallView.mas_bottom).with.offset(15);
        make.height.equalTo(@(self.couponViewHeight));
    }];
    
    [self.announcementView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.couponViewHeight > 0) {
            make.top.equalTo(self.couponView.mas_bottom).with.offset(20);
        } else {
            make.top.equalTo(self.brandHallView.mas_bottom).with.offset(15);
        }
        
        make.leading.equalTo(self.headerView).with.offset(20);
        make.trailing.equalTo(self.headerView).with.offset(-20);
        make.height.equalTo(@(self.announcementViewHeight));
    }];
    
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.announcementViewHeight > 0) {
            make.top.equalTo(self.announcementView.mas_bottom);
        } else if (self.announcementViewHeight == 0 && self.couponViewHeight == 0) {
            make.top.equalTo(self.brandHallView.mas_bottom).with.offset(15);
        } else if (self.announcementViewHeight == 0) {
            make.top.equalTo(self.couponView.mas_bottom).with.offset(20);
        }
        
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.functionView);
        make.top.equalTo(self.functionView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
    [self.collectionView reloadData];
    [self.collectionView setCollectionViewLayout:layout];
}

#pragma mark - THNFunctionButtonViewDelegate  Method 实现
- (void)thn_functionViewSelectedWithIndex:(NSInteger)index {
    [self.popupView thn_showFunctionViewWithType:index];
}

#pragma mark - THNFunctionPopupViewDelegate
- (void)thn_functionPopupViewClose {
    [self.functionView thn_setFunctionButtonSelected:NO];
}

- (void)thn_functionPopupViewScreenParams:(NSDictionary *)screenParams count:(NSInteger)count {
    [self.functionView thn_setFunctionButtonSelected:NO];
    NSMutableString *screenStr = [NSMutableString stringWithFormat:@"筛选"];
    [screenStr appendString:count > 0 ? [NSString stringWithFormat:@" %zi", count] : @""];
    [self.functionView thn_setSelectedButtonTitle:screenStr];
    self.producrConditionParams = screenParams;
    [self.products removeAllObjects];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;
    [self loadProductsByStoreData];
}

- (void)thn_functionPopupViewType:(THNFunctionPopupViewType)viewType sortType:(NSInteger)type title:(NSString *)title {
    [self.functionView thn_setFunctionButtonSelected:NO];
    [self.functionView thn_setSelectedButtonTitle:title];
    
    if (viewType == THNFunctionPopupViewTypeSort) {
        self.producrConditionParams = @{@"sort_type": @(type)};
    } else if (viewType == THNFunctionPopupViewTypeProfitSort) {
        self.producrConditionParams = @{@"profit_type" : @(type)};
    }
    
    [self loadProductsByStoreData];
}

#pragma mark - UICollectionViewDataSourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.brandShowType) {
        case BrandShowTypeProduct:
            return self.products.count;
        case BrandShowTypelifeRecord:
            return self.lifeRecords.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.brandShowType) {
        case BrandShowTypeProduct:
        {
            THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandHallProductCellIdentifier forIndexPath:indexPath];
            THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
            [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
            return cell;
        }
            
        case BrandShowTypelifeRecord:
        {
            THNGrassListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandHallLifeRecordsCellIdentifier forIndexPath:indexPath];
            cell.showTextType = ShowTextTypeTheme;
            THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:self.lifeRecords[indexPath.row]];
            [cell setGrassListModel:grassListModel];
            return cell;
        }

    }
    
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size;
    if (self.isRecords) {
         size  = CGSizeMake(SCREEN_WIDTH, 265);
    } else {
         size = CGSizeMake(SCREEN_WIDTH, 265 + self.couponViewHeight + self.announcementViewHeight + 40 + 15 + 25);
    }
   
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kBrandHallHeaderViewIdentifier forIndexPath:indexPath];
    self.headerView = headerView;
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.brandShowType) {
        case BrandShowTypeProduct: {
            CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
            
            return CGSizeMake(itemWidth, itemWidth + 50);
        }
        case BrandShowTypelifeRecord: {
            THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:self.lifeRecords[indexPath.row]];
                //  设置最大size
                CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
                CGFloat contentMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 10.5;
                CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
                CGSize contentSize = CGSizeMake(contentMaxWidth, 33);
                NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]};
                NSDictionary *contentFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]};
                CGFloat titleHeight = [grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
                CGFloat contentHeight = [grassListModel.des boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentFont context:nil].size.height;
                CGFloat grassLabelHeight = titleHeight + contentHeight;
                grassListModel.grassLabelHeight = grassLabelHeight;
                return CGSizeMake((SCREEN_WIDTH - 50) / 2, kCellGrassListHeight + grassListModel.grassLabelHeight);
        }
            
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.brandShowType) {
        case BrandShowTypeProduct: {
            THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
            THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:productModel.rid];
            [self.navigationController pushViewController:goodInfo animated:YES];
        }
            break;
        case BrandShowTypelifeRecord: {
            THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:self.lifeRecords[indexPath.row]];
            THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
            articleVC.rid = grassListModel.rid;
            [self.navigationController pushViewController:articleVC animated:YES];
        }
            break;
            
    }
    
}

#pragma mark - THNBrandHallHeaderViewDelegate
- (void)showProduct {
    self.brandShowType = BrandShowTypeProduct;
    self.isRecords = NO;
    [self setupLayout];
}

- (void)showLifeRecords {
    if (self.lifeRecords.count == 0) {
        [self loadLifeRecordData];
    }
    
    self.brandShowType = BrandShowTypelifeRecord;
    self.isRecords = YES;
    [self setupLayout];
}

- (void)pushBrandHallStory:(NSString *)rid {
    THNBrandHallStoryViewController *brandHallStoryVC = [[THNBrandHallStoryViewController alloc]init];
    brandHallStoryVC.rid = rid;
    [self.navigationController pushViewController:brandHallStoryVC animated:YES];
}

- (void)lookBrandHallQualification:(NSString *)rid {
    THNWebKitViewViewController *webkitVC = [[THNWebKitViewViewController alloc]init];
    webkitVC.url = [NSString stringWithFormat:@"%@%@",THNBrandHallVCQualificationPrefix, rid];
    webkitVC.title = @"资质信息";
    [self.navigationController pushViewController:webkitVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 120) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationBarView.title = self.offcialStoreModel.name;
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationBarView.title = @"";
        }];
    }
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadProductsByStoreData];
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

- (THNFunctionPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[THNFunctionPopupView alloc] init];
        _popupView.sid = self.rid;
        [_popupView thn_setViewStyleWithGoodsListType:THNGoodsListViewTypeStore];
        [_popupView thn_setCategoryId:@"0"];
        _popupView.delegate = self;
    }
    return _popupView;
}

- (THNFunctionButtonView *)functionView {
    if (!_functionView) {
        _functionView = [[THNFunctionButtonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _functionView.delegate = self;
    }
    return _functionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    }
    return _lineView;
}

- (NSDictionary *)producrConditionParams {
    if (!_producrConditionParams) {
        _producrConditionParams = [NSDictionary dictionary];
    }
    return _producrConditionParams;
}

- (NSMutableArray *)products {
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}

@end
