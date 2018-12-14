//
//  THNLivingHallViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallViewController.h"
#import "THNLivingHallHeaderView.h"
#import "UIView+Helper.h"
#import "THNFeatureTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNLivingHallRecommendTableViewCell.h"
#import "THNMarco.h"
#import "THNLoginManager.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNProductModel.h"
#import "THNLivingHallExpandView.h"
#import "THNSaveTool.h"
#import "THNConst.h"
#import "THNPruductCenterViewController.h"
#import "THNGoodsInfoViewController.h"
#import "UIViewController+THNHud.h"
#import "THNPhotoManager.h"
#import "THNQiNiuUpload.h"
#import "THNShareViewController.h"
#import "THNShareWxaViewController.h"
#import "THNLivingRecommendProductSetTableViewCell.h"
#import "THNLivingHallRecommendTableViewController.h"
#import "UIColor+Extension.h"
#import "THNLivingHallHeadLineView.h"
#import "THNExploreTableViewCell.h"
#import "THNSignInViewController.h"
#import "THNApplyStoreViewController.h"
#import "THNBaseNavigationController.h"
#import "THNAdvertManager.h"
#import "THNAdvertCouponViewController.h"
#import "THNGoodsListViewController.h"

static CGFloat const livingHallHeaderViewHeight = 554;
static NSString *const kLivingHallRecommendProductSetCellIdentifier = @"kLivingHallRecommendProductSetCellIdentifier";
// 本周最受欢迎
static NSString *const kUrlWeekPopular = @"/fx_distribute/week_popular";
static NSString *const kUrlColumnHandpickNewExpress = @"/column/handpick_new_express";

typedef NS_ENUM(NSUInteger, LivingHallCellType) {
    LivingHallCellTypeRecommend,
    LivingHallCellTypeNewExpressProduct
};

@interface THNLivingHallViewController () <
THNFeatureTableViewCellDelegate,
THNMJRefreshDelegate,
THNExploreTableViewCellDelegate
>

@property (nonatomic, strong) THNLivingHallHeaderView *livingHallHeaderView;
// 本周最受人气欢迎Cell
@property (nonatomic, strong) THNFeatureTableViewCell *featureCell;
@property (nonatomic, strong)  THNLivingHallExpandView *expandView;
@property (nonatomic, strong) NSArray *weekPopularArray;
@property (nonatomic, strong) NSArray *expressNewProductArray;
@property (nonatomic, strong) NSArray *likeProductUserArray;
@property (nonatomic, assign) CGFloat recommenLabelHegiht;
@property (nonatomic, assign) NSInteger weekPopularPerPageCount;
@property (nonatomic, assign) BOOL isLoadMoreData;
@property (nonatomic, assign) CGFloat footerViewHeight;
@property (nonatomic, assign) CGFloat featureCellHeight;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) BOOL isNeedsHud;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *noLivingHallHeaderView;
@property (nonatomic, strong) THNLivingHallHeadLineView *headLineView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) LivingHallCellType livingHallCellType;
@property (nonatomic, assign) BOOL isHaveRecommendData;

@end

@implementation THNLivingHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCuratorRecommendedData) name:kShelfSuccess object:nil];
    self.isNeedsHud = YES;
    [self setupUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hiddenHud];
}

// 刷新馆长推荐数据
- (void)refreshCuratorRecommendedData {
    THNLivingRecommendProductSetTableViewCell *recommendProductSetCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    recommendProductSetCell.isMergeRecommendData = NO;
    [recommendProductSetCell loadCuratorRecommendedData];
}

- (void)loadData {
    
    [self.livingHallHeaderView setLifeStore];
    
    
    if (self.isNeedsHud) {
        self.isAddWindow = YES;
        self.isFromMain = YES;
        self.loadViewY = 130;
        [self showHud];
    }
    
    [self.livingHallHeaderView loadLifeStoreData:^(BOOL isHaveRecommendData) {
        self.isHaveRecommendData = isHaveRecommendData;
        if (self.isHaveRecommendData) {
            [self.dataArray addObject:@(LivingHallCellTypeRecommend)];
        }
        
        [self loadNewExpressProductData];
       
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headLineView.frame = CGRectMake(20, 107, SCREEN_WIDTH - 40, 110);
}

/**
 展示新用户领红包视图
 */
- (void)thn_showNewUserBonusAdvertView {
    if (![THNAdvertManager canGetBonus]) {
        return;
        
    } else {
        THNAdvertCouponViewController *advertVC = [[THNAdvertCouponViewController alloc] init];
        THNBaseNavigationController *navVC = [[THNBaseNavigationController alloc] initWithRootViewController:advertVC];
        navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:navVC animated:NO completion:nil];
    }
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNLivingRecommendProductSetTableViewCell" bundle:nil] forCellReuseIdentifier:kLivingHallRecommendProductSetCellIdentifier];
    // 抖动闪动漂移等问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
//    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView setRefreshHeaderWithClass:nil beginRefresh:NO animation:NO delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
    // tableView内容向下偏移20pt或向下偏移64pt,导致一进来就走scrollViewDid代理方法
    // 链接 : https://blog.csdn.net/yuhao309/article/details/78864211
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

// 新品速递
- (void)loadNewExpressProductData {
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlColumnHandpickNewExpress requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.tableView endHeaderRefresh];
        if (self.isNeedsHud) {
            [self hiddenHud];
        }
        
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.expressNewProductArray = result.data[@"products"];
        
        if (self.expressNewProductArray.count > 0) {
            [self.dataArray addObject:@(LivingHallCellTypeNewExpressProduct)];
        }
        
        self.title = result.data[@"title"];
        [self.tableView reloadData];
        
        // 等HUD隐藏后并且第一次进行弹出
        if (self.isNeedsHud) {
            [self thn_showNewUserBonusAdvertView];
        }
        
        [self loadWeekPopularData];
        
    } failure:^(THNRequest *request, NSError *error) {
    
    }];
}

// 本周最受人气欢迎
- (void)loadWeekPopularData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"per_page"] = @(20);
    THNRequest *request = [THNAPI getWithUrlString:kUrlWeekPopular requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.weekPopularArray = result.data[@"products"];
        
//        for (int i = 1; i <= self.weekPopularArray.count; i++) {
//            if ( i % 5 == 0) {
//                self.featureCellHeight += SCREEN_WIDTH - 40 + 46;
//            } else if (i % 2 == 0) {
//                self.featureCellHeight += ((SCREEN_WIDTH - 49) / 2 + 46);
//            }
//            // 加上间距
//            self.featureCellHeight += i % 2 == 0 || i % 5 == 0 ? 10 : 0;
//        }
        
        self.featureCellHeight = ((SCREEN_WIDTH - 49) / 2 + 46 + 9) * self.weekPopularArray.count / 2 + 90 - 9;
        
//        [self.tableView endFooterRefreshAndCurrentPageChange:YES];
//        if (![result.data[@"next"] boolValue] && self.weekPopularArray.count != 0) {
//
//            [self.tableView noMoreData];
//        }
        
        self.title = result.data[@"title"];
        [self.featureCell setCellTypeStyle:FeaturedNo initWithDataArray:self.weekPopularArray initWithTitle:@"本周最受欢迎"];
        [self.tableView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

#pragma mark - private methods
/**
 选择头像照片
 */
- (void)thn_getSelectImage {
    WEAKSELF;
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [weakSelf.livingHallHeaderView setHeaderImageWithData:imageData];
        
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData
                                                       compltion:^(NSDictionary *result) {
                                                           NSArray *idsArray = result[@"ids"];
                                                           [weakSelf.livingHallHeaderView setHeaderAvatarId:[idsArray[0] integerValue]];
                                                       }];
    }];
}


#pragma mark - UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataArray[indexPath.row] integerValue] == LivingHallCellTypeNewExpressProduct) {
        self.livingHallCellType = LivingHallCellTypeNewExpressProduct;
        THNExploreTableViewCell *cell = [THNExploreTableViewCell viewFromXib];
        cell.isRewriteCellHeight = self.isHaveRecommendData;
        [cell setCellTypeStyle:ExploreRecommend initWithDataArray:self.expressNewProductArray
                 initWithTitle:@"新品速递"];
        cell.delagate = self;
        return cell;
        
    } else {
        self.livingHallCellType = LivingHallCellTypeRecommend;
        THNLivingRecommendProductSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLivingHallRecommendProductSetCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeAvatarUrl = self.livingHallHeaderView.storeAvatarUrl;
        
        WEAKSELF;
        cell.lookMoreRecommenDataBlock = ^{
            THNLivingHallRecommendTableViewController *recommendProductSetVC = [[THNLivingHallRecommendTableViewController alloc]init];
            recommendProductSetVC.storeAvatarUrl = self.livingHallHeaderView.storeAvatarUrl;
            [weakSelf.navigationController pushViewController:recommendProductSetVC animated:YES];
        };
        
        cell.recommendCellBlock = ^(NSString *rid) {
            [weakSelf pushGoodInfo:rid];
        };
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate method 实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.livingHallCellType == LivingHallCellTypeRecommend) {
        return 243;
    } else {
         return self.isHaveRecommendData ? cellOtherHeight + 77 + 15 : cellOtherHeight + 77;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([THNLoginManager sharedManager].openingUser) {
        if ([THNSaveTool objectForKey:kIsCloseLivingHallView]) {
            return self.livingHallHeaderView.noProductView.hidden ? livingHallHeaderViewHeight - 115 - 100 : livingHallHeaderViewHeight - 100;
        } else {
            return self.livingHallHeaderView.noProductView.hidden ? livingHallHeaderViewHeight - 115 : livingHallHeaderViewHeight;
        }
    } else {
        
        return CGRectGetMaxY(self.noLivingHallHeaderView.frame) + 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self)weakSelf = self;
    
    if ([THNLoginManager sharedManager].openingUser) {
        self.livingHallHeaderView.changeHeaderViewBlock = ^{
            [weakSelf.tableView reloadData];
        };
        
        self.livingHallHeaderView.pushProductCenterBlock = ^{
            THNPruductCenterViewController *productCenter = [[THNPruductCenterViewController alloc]init];
            [weakSelf.navigationController pushViewController:productCenter animated:YES];
        };
        
        self.livingHallHeaderView.storeLogoBlock = ^{
            [weakSelf thn_getSelectImage];
        };
        
        self.livingHallHeaderView.livingHallShareBlock = ^{
            if (![THNLoginManager sharedManager].storeRid.length) return;
            
            THNShareWxaViewController *shareVC = [[THNShareWxaViewController alloc] initWithType:(THNShareWxaViewTypeLifeStore)
                                                                                       requestId:[THNLoginManager sharedManager].storeRid];
            shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [weakSelf presentViewController:shareVC animated:NO completion:nil];
        };
        
        return self.livingHallHeaderView;
    } else {
        UIView *headerView = [[UIView alloc]initWithFrame:self.noLivingHallHeaderView.frame];
        [headerView addSubview:self.noLivingHallHeaderView];
        [self.noLivingHallHeaderView addSubview:self.headLineView];
        
        self.headLineView.headLineViewBlock = ^{
            if (![THNLoginManager isLogin]) {
                THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
                THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
                [weakSelf presentViewController:navController animated:YES completion:nil];
                
            } else {
                THNApplyStoreViewController *applyStoreVC = [[THNApplyStoreViewController alloc] init];
                [weakSelf.navigationController pushViewController:applyStoreVC animated:YES];
            }
        };
        
        [headerView addSubview:self.noLivingHallHeaderView];
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.footerViewHeight)];
    self.featureCell.frame = CGRectMake(0, 15, SCREEN_WIDTH, self.featureCellHeight);
    self.featureCell.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:self.featureCell];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // featureCell距footerView的间距
    return self.featureCellHeight + 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:THNHomeVCDidScrollView object:nil userInfo:@{kScrollDistance : @(scrollView.contentOffset.y - self.lastContentOffset)}];
    // 解决一直上拉搜索动画导致闪动的问题,下拉刷新界面需设置bounces为YES
    self.tableView.bounces = scrollView.contentOffset.y < 0 ?: NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
    // 解决下拉搜索框位置无法改变的问题
    self.tableView.bounces = YES;
}

#pragma mark - THNFeatureTableViewCellDelegate
// 商品详情
- (void)pushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}


#pragma mark- THNExploreTableViewCellDelegate
- (void)lookAllWithType:(ExploreCellType)cellType {
    THNGoodsListViewController *goodsList = [[THNGoodsListViewController alloc]initWithGoodsListType:THNGoodsListViewTypeOptimal title:@"新品速递"];
    [self.navigationController pushViewController:goodsList animated:YES];
}

#pragma makr - THNMJRefreshDelegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    self.isNeedsHud = NO;
    [self loadWeekPopularData];
}

- (void)beginRefreshing {
    self.isNeedsHud = NO;
    self.featureCellHeight = 0;
    [self.dataArray removeAllObjects];
    [self loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - lazy
- (THNLivingHallHeaderView *)livingHallHeaderView {
    if (!_livingHallHeaderView) {
        _livingHallHeaderView = [THNLivingHallHeaderView viewFromXib];
    }
    return _livingHallHeaderView;
}

- (THNFeatureTableViewCell *)featureCell {
    if (!_featureCell) {
        _featureCell = [THNFeatureTableViewCell viewFromXib];
        _featureCell.delagate = self;
    }
    return _featureCell;
}

//- (NSMutableArray *)weekPopularArray {
//    if (!_weekPopularArray) {
//        _weekPopularArray = [NSMutableArray array];
//    }
//    return _weekPopularArray;
//}

- (UIView *)noLivingHallHeaderView {
    if (!_noLivingHallHeaderView) {
        _noLivingHallHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
        _noLivingHallHeaderView.backgroundColor = [UIColor whiteColor];
        UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 214)];
        backGroundImageView.image = [UIImage imageNamed:@"icon_noLivingHall_back"];
        UILabel *tintLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, SCREEN_WIDTH, 20)];
        tintLabel.text = @"自己买省钱 卖出去赚钱";
        tintLabel.textColor = [UIColor colorWithHexString:@"32CDBD"];
        tintLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        [_noLivingHallHeaderView addSubview:backGroundImageView];
        [_noLivingHallHeaderView addSubview:tintLabel];
    }
    return _noLivingHallHeaderView;
}

- (THNLivingHallHeadLineView *)headLineView {
    if (!_headLineView) {
        _headLineView = [THNLivingHallHeadLineView viewFromXib];
    }
    return _headLineView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
