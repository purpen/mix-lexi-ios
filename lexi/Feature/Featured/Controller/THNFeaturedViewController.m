//
//  THNFeaturedViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeaturedViewController.h"
#import "THNFeaturedCollectionView.h"
#import "THNFeaturedOpeningView.h"
#import "THNMarco.h"
#import "THNCollectionViewFlowLayout.H"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNFeatureTableViewCell.h"
#import "THNActivityView.h"
#import "THNBannerView.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNGrassListModel.h"
#import "THNLoginManager.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNShopWindowViewController.h"
#import "THNGoodsListViewController.h"
#import "THNGoodsInfoViewController.h"
#import "THNApplyStoreViewController.h"
#import "THNArticleViewController.h"
#import "THNBrandHallViewController.h"
#import "THNWebKitViewViewController.h"
#import "THNDiscoverThemeViewController.h"
#import "THNSetDetailViewController.h"
#import "THNCouponsCenterViewController.h"
#import "THNShopWindowDetailViewController.h"
#import "UIViewController+THNHud.h"
#import "THNBaseNavigationController.h"
#import "THNHomeSearchView.h"
#import "THNSelectButtonView.h"

// cell共用上下的高
static CGFloat const kFeaturedCellTopBottomHeight = 80;
static CGFloat const kPopularFooterViewHeight = 180;
static CGFloat const kFeaturedX = 20;
static NSString *const kFeaturedCellIdentifier = @"kFeaturedCellIdentifier";
// 顶部banner
static NSString *const kUrlBannersHandpickTop = @"/banners/hotpick_app";
// 今日推荐
static NSString *const kUrlDailyRecommends = @"/column/daily_recommends";
// 人气推荐
static NSString *const kUrlColumnHandpickRecommend = @"/column/handpick_recommend";
// 发现生活美学
static NSString *const kUrlLifeAesthetics = @"/shop_windows/handpick";
// 乐喜优选
static NSString *const kUrlColumnHandpickOptimization = @"/column/handpick_optimization";
// 种草清单
static NSString *const kUrlLifeRecords = @"/life_records/recommend";
// 内容区banner
static NSString *const kUrlBannersHandpickContent = @"/banners/handpick_content";
NSString *const kDidScrollViewOffsetY = @"didScrollViewOffsetY";
NSString *const kLastContentOffsetY = @"lastContentOffsetY";

@interface THNFeaturedViewController () <
THNFeatureTableViewCellDelegate,
THNBannerViewDelegate,
THNFeaturedCollectionViewDelegate,
THNActivityViewDelegate,
THNMJRefreshDelegate
>

@property (nonatomic, strong) THNFeaturedCollectionView *featuredCollectionView;
@property (nonatomic, strong) THNFeaturedOpeningView *openingView;
@property (nonatomic, strong) THNActivityView *activityView;
@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) FeaturedCellType cellType;
@property (nonatomic, strong) NSString * popularTitle;
@property (nonatomic, strong) NSString * dailyTitle;
@property (nonatomic, strong) NSString *optimalTitle;
@property (nonatomic, strong) NSString *grassListTitle;
@property (nonatomic, strong) NSString *lifeAestheticTitle;
@property (nonatomic, strong) NSArray *dailyDataArray;
@property (nonatomic, strong) NSArray *popularDataArray;
@property (nonatomic, strong) NSArray *lifeAestheticDataArray;
@property (nonatomic, strong) NSArray *optimalDataArray;
@property (nonatomic, strong) NSArray *grassListDataArray;
@property (nonatomic, strong) NSMutableArray *grassLabelHeights;
@property (nonatomic, assign) NSInteger pageCount;
// 今日推荐单次请求数据数量
@property (nonatomic, assign) NSInteger dailyPerPageCount;
// 人气推荐单次请求数据数量
@property (nonatomic, assign) NSInteger pupularPerPageCount;
// 优选单次请求数据数量
@property (nonatomic, assign) NSInteger optimalPerPageCount;
//种草清单请求数据数量
@property (nonatomic, assign) NSInteger grassListPerPageCount;
@property (nonatomic, assign) CGFloat customGrassCellHeight;
@property (nonatomic, strong) NSMutableArray *newPopularDataArray;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) THNHomeSearchView *searchView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) BOOL isNeedsHud;

@end

@implementation THNFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedsHud = YES;
    [self initPageNumber];
    [self setupUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hiddenHud];
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

// 初始化页码
- (void)initPageNumber {
    self.pageCount = 1;
    self.pupularPerPageCount = 15;
    self.optimalPerPageCount = 4;
    self.grassListPerPageCount = 4;
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    // 设置tableView 组与组间距为 0
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNFeatureTableViewCell" bundle:nil] forCellReuseIdentifier:kFeaturedCellIdentifier];
    [self.tableView setRefreshHeaderWithClass:nil beginRefresh:NO animation:NO delegate:self];
    // tableView内容向下偏移20pt或向下偏移64pt,导致一进来就走scrollViewDid代理方法
    // 链接 : https://blog.csdn.net/yuhao309/article/details/78864211
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)loadData {
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    self.isAddWindow = YES;
    self.isFromMain = YES;
    self.loadViewY = 135 + 22;
    
    if (self.isNeedsHud) {
        [self showHud];
    }
    
    dispatch_group_async(group, queue, ^{
        [self loadTopBannerData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadContentBannerData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadDailyRecommendData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadPupularData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadOptimalData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadGrassListData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadLifeAestheticData];
    });
  
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView endHeaderRefresh];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - 请求数据
// 顶部Banner
- (void)loadTopBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBannersHandpickTop requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
         [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.featuredCollectionView.banners = result.data[@"banner_images"];
        self.featuredCollectionView.bannerType = BannerTypeLeft;
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 内容区Banner
- (void)loadContentBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBannersHandpickContent requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [self.bannerView setBannerView:result.data[@"banner_images"]];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 今日推荐
- (void)loadDailyRecommendData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"page"] = @(self.pageCount);
//    params[@"per_page"] = @(self.dailyPerPageCount);
    THNRequest *request = [THNAPI getWithUrlString:kUrlDailyRecommends requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.dailyTitle = result.data[@"title"];
        self.dailyDataArray = result.data[@"daily_recommends"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 人气推荐
- (void)loadPupularData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(self.pupularPerPageCount);
    THNRequest *request = [THNAPI getWithUrlString:kUrlColumnHandpickRecommend requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.popularTitle = result.data[@"title"];
        NSArray *allPopularProducts = result.data[@"products"];
        
        [allPopularProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger showMaxCount = 5;
            NSArray *array = [NSArray array];
            if (idx % showMaxCount == 0) {
                if (allPopularProducts.count - idx > showMaxCount) {
                    array = [allPopularProducts subarrayWithRange:NSMakeRange(idx, showMaxCount)];
                } else {
                    array = [allPopularProducts subarrayWithRange:NSMakeRange(idx, allPopularProducts.count - idx)];
                }
                [self.newPopularDataArray addObject:array];
            }
        }];
        self.popularDataArray = self.newPopularDataArray;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 发现生活美学
- (void)loadLifeAestheticData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeAesthetics requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.lifeAestheticTitle = result.data[@"title"];
        self.lifeAestheticDataArray = result.data[@"shop_windows"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

//优选
- (void)loadOptimalData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(self.optimalPerPageCount);
    THNRequest *request= [THNAPI getWithUrlString:kUrlColumnHandpickOptimization requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.optimalTitle = result.data[@"title"];
        self.optimalDataArray = result.data[@"products"];
        
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

//种草清单
- (void)loadGrassListData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(self.grassListPerPageCount);
    THNRequest *request= [THNAPI getWithUrlString:kUrlLifeRecords requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.grassListDataArray = result.data[@"life_records"];
        self.grassListTitle = result.data[@"title"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

#pragma mark - UITableView mehtod 实现
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView;
        
        // 业务调整，去掉该开馆头条
//        if (![THNLoginManager sharedManager].openingUser && ![THNLoginManager sharedManager].supplier) {
//             headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.openingView.frame) + 10)];
//             [headerView addSubview:self.openingView];
//             [self.openingView loadLivingHallHeadLineData:FeatureOpeningTypeMain];
//
//        } else {
        
//        }
        
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.featuredCollectionView.frame) + 10)];
        self.featuredCollectionView.featuredDelegate = self;
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:self.featuredCollectionView];
        
        __weak typeof(self)weakSelf = self;
        self.openingView.openingBlcok = ^{
            
            if (![THNLoginManager isLogin]) {
                THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
                THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
                [weakSelf presentViewController:navController animated:YES completion:nil];
            
            } else {
                THNApplyStoreViewController *applyStoreVC = [[THNApplyStoreViewController alloc] init];
                [weakSelf.navigationController pushViewController:applyStoreVC animated:YES];
            }
        };
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
//        if (![THNLoginManager sharedManager].openingUser && ![THNLoginManager sharedManager].supplier) {
//             return CGRectGetMaxY(self.openingView.frame) + 10;
//        } else {
        
//        }
       return CGRectGetMaxY(self.featuredCollectionView.frame) + 10;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.activityView;
    } else if (section == 1){
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPopularFooterViewHeight)];
        footerView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:self.lineView];
        self.bannerView.delegate = self;
        [footerView addSubview:self.bannerView];
        return footerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 130;
    } else if (section == 1) {
        return kPopularFooterViewHeight;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeaturedCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delagate = self;
    NSArray *dataArray = [NSArray array];
    NSString *title;
    
    switch (self.cellType) {
        case FeaturedRecommendedToday:
            dataArray = self.dailyDataArray;
            title = self.dailyTitle;
            break;
        case FeaturedLifeAesthetics:
            dataArray = self.lifeAestheticDataArray;
            title = self.lifeAestheticTitle;
            break;
        case FearuredOptimal:
            dataArray = self.optimalDataArray;
            title = self.optimalTitle;
            break;
        case FearuredGrassList:
            title = self.grassListTitle;
            cell.grassLabelHeights = self.grassLabelHeights;
            dataArray = self.grassListDataArray;
            break;
        default:
            dataArray = self.popularDataArray;
            title = self.popularTitle;
            break;
    }
    
    [cell setCellTypeStyle:self.cellType initWithDataArray:dataArray initWithTitle:title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            self.cellType = FeaturedRecommendedToday;
            return kCellTodayHeight + kFeaturedCellTopBottomHeight;
            break;
        case 1:
            self.cellType = FeaturedRecommendationPopular;
            CGFloat firstItemHeight = (SCREEN_WIDTH - 10 - 20 * 2) / 2;
            CGFloat secondItemHeight = (SCREEN_WIDTH - 20 - 20 * 2 - 1) / 3;
            return firstItemHeight + secondItemHeight + 46 * 2 + 10 + kFeaturedCellTopBottomHeight;
            break;
        case 2:
            self.cellType = FeaturedLifeAesthetics;
             return kCellLifeAestheticsHeight + kFeaturedCellTopBottomHeight;
            break;
        case 3:
            self.cellType = FearuredOptimal;
            return ((SCREEN_WIDTH - 49) / 2 + 46 ) * 2 + 9 + kFeaturedCellTopBottomHeight;
            break;
        case 4:
            self.cellType = FearuredGrassList;
         
            // 多次执行该方法造成重复的计算
            if (self.grassLabelHeights.count == 0) {
                    
                __block CGFloat firstRowMaxtitleHeight = 0;
                __block CGFloat firstRowMaxcontentHeight = 0;
                __block CGFloat secondRowMaxtitleHeight = 0;
                __block CGFloat secondRowMaxcontentHeight = 0;
                
                [self.grassListDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:obj];
                    //  设置最大size
                    CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
                    CGFloat contentMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 10.5;
                    CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
                    CGSize contentSize = CGSizeMake(contentMaxWidth, 33);
                    NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]};
                    NSDictionary *contentFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:11]};
                    CGFloat titleHeight = [grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
                    CGFloat contentHeight = [grassListModel.des boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentFont context:nil].size.height;
                    
                    // 取出第一列最大的titleLabel和contentLabel的高度
                    if (idx <= 1) {
                        
                        if (titleHeight > firstRowMaxtitleHeight) {
                            firstRowMaxtitleHeight = titleHeight;
                        }
                        
                        if (contentHeight > secondRowMaxtitleHeight ) {
                            firstRowMaxcontentHeight = contentHeight;
                        }
                        // 取出第二列最大的titleLabel和contentLabel的高度
                    } else {
                        
                        if (titleHeight > secondRowMaxtitleHeight) {
                            secondRowMaxtitleHeight = titleHeight;
                        }
                        
                        if (contentHeight > secondRowMaxcontentHeight) {
                            secondRowMaxcontentHeight = titleHeight;
                        }
                        
                    }
                    
                    CGFloat grassLabelHeight = titleHeight + contentHeight;
                    
                    [self.grassLabelHeights addObject:@(grassLabelHeight)];
                    
                    self.customGrassCellHeight = firstRowMaxtitleHeight + secondRowMaxtitleHeight + firstRowMaxcontentHeight + secondRowMaxcontentHeight;
                }];
            }
         
            return kCellGrassListHeight * 2 + self.customGrassCellHeight + 5 + kFeaturedCellTopBottomHeight;
            break;
    }
    
    return 0;
    
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

#pragma mark - THNMJRefreshDelegate
- (void)beginRefreshing {
    self.isNeedsHud = NO;
    [self initPageNumber];
    [self loadData];
}

#pragma mark - THNFeatureTableViewCellDelegate method 实现
- (void)lookAllWithType:(FeaturedCellType)cellType {
    switch (cellType) {
            
        case FeaturedLifeAesthetics: {
            THNShopWindowViewController *shopWindow = [[THNShopWindowViewController alloc]init];
            [self.navigationController pushViewController:shopWindow animated:YES];
            break;
        }
        case FearuredOptimal: {
            THNGoodsListViewController *goodsList = [[THNGoodsListViewController alloc]initWithGoodsListType:THNGoodsListViewTypeOptimal title:self.optimalTitle];
            [self.navigationController pushViewController:goodsList animated:YES];
            break;
        }
        case FearuredGrassList: {
            THNDiscoverThemeViewController *themeVC = [[THNDiscoverThemeViewController alloc]init];
            themeVC.themeType = DiscoverThemeTypeGrassNote;
            themeVC.navigationBarViewTitle = @"种草清单";
            [self.navigationController pushViewController:themeVC animated:YES];
            break;
        }
        default:
            break;
    }
}

// 橱窗主页
- (void)pushShopWindow:(THNShopWindowModel *)shopWindowModel {
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc]init];
    shopWindowDetail.shopWindowModel = shopWindowModel;
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}


// 商品详情
- (void)pushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

// 文章详情
- (void)pushArticle:(NSInteger)rid {
    THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
    articleVC.rid = rid;
    [self.navigationController pushViewController:articleVC animated:YES];
}

// 集合详情
- (void)pushSetDetail:(NSInteger)collectionID {
    THNSetDetailViewController *setDetailVC = [[THNSetDetailViewController alloc]init];
    setDetailVC.collectionID = collectionID;
    [self.navigationController pushViewController:setDetailVC animated:YES];
}

#pragma mark - THNBannerViewDelegate

- (void)bannerPushWeb:(NSString *)url {
    THNWebKitViewViewController *webVC = [[THNWebKitViewViewController alloc]init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)bannerPushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

- (void)bannerPushBrandHall:(NSString *)rid {
    THNBrandHallViewController *brandHall = [[THNBrandHallViewController alloc]init];
    brandHall.rid = rid;
    [self.navigationController pushViewController:brandHall animated:YES];
}

- (void)bannerPushArticle:(NSInteger)rid {
    THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
    articleVC.rid = rid;
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)bannerPushCategorie:(NSString *)name initWithCategoriesID:(NSString *)categorieID {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithCategoryId:categorieID categoryName:name];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

#pragma mark - THNActivityViewDelegate

- (void)pushGoodListShipping {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc]initWithGoodsListType:THNGoodsListViewTypeFreeShipping title:@"包邮专区"];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

- (void)pushGoodListOrderCustomization {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc]initWithGoodsListType:THNGoodsListViewTypeCustomization title:@"接单定制"];
    [self.navigationController pushViewController:goodsListVC animated:YES];

}

- (void)pushCouponsCenter {
    THNCouponsCenterViewController *couponCenterVC = [[THNCouponsCenterViewController alloc]init];
    [self.navigationController pushViewController:couponCenterVC animated:YES];
}

#pragma mark - lazy
- (THNFeaturedCollectionView *)featuredCollectionView {
    if (!_featuredCollectionView) {
        THNCollectionViewFlowLayout *flowLayout = [[THNCollectionViewFlowLayout alloc]init];
        CGFloat height = (SCREEN_WIDTH - 75) / 1.5;;
        _featuredCollectionView = [[THNFeaturedCollectionView alloc]initWithFrame:CGRectMake(kFeaturedX, 15, SCREEN_WIDTH - kFeaturedX, height) collectionViewLayout:flowLayout];
    }
    return _featuredCollectionView;
}

- (THNFeaturedOpeningView *)openingView {
    if (!_openingView) {
        _openingView = [THNFeaturedOpeningView viewFromXib];
        _openingView.frame = CGRectMake(15, CGRectGetMaxY(self.featuredCollectionView.frame) + 20, SCREEN_WIDTH - 30, 135);
    }
    
    return _openingView;
}

- (THNActivityView *)activityView {
    if (!_activityView) {
        _activityView = [THNActivityView viewFromXib];
        _activityView.delegate = self;
    }
    return _activityView;
}

- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(kFeaturedX, 20, SCREEN_WIDTH - kFeaturedX * 2, 140)];
    }
    return _bannerView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    }
    return _lineView;
}

- (NSMutableArray *)grassLabelHeights {
    if (!_grassLabelHeights) {
        _grassLabelHeights = [NSMutableArray array];
    }
    return _grassLabelHeights;
}

- (NSMutableArray *)newPopularDataArray {
    if (!_newPopularDataArray) {
        _newPopularDataArray = [NSMutableArray array];
    }
    return _newPopularDataArray;
}

@end
