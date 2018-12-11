//
//  THNExploresViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNExploresViewController.h"
#import "THNBannerView.h"
#import "THNCategoriesCollectionView.h"
#import "THNMarco.h"
#import "THNExploreTableViewCell.h"
#import "UIColor+Extension.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNRequest.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "UITableView+Helper.h"
#import "THNBrandHallViewController.h"
#import "THNFeaturedBrandModel.h"
#import "THNGoodsListViewController.h"
#import "THNAllBrandHallViewController.h"
#import "THNAllsetTableViewController.h"
#import "THNSetDetailViewController.h"
#import "THNSetModel.h"
#import "THNGoodsListViewController.h"
#import "THNGoodsInfoViewController.h"
#import "THNBannerModel.h"
#import "THNArticleViewController.h"
#import "THNWebKitViewViewController.h"
#import "UIViewController+THNHud.h"

static NSInteger const allLinesCount = 6;
static CGFloat const kBannerViewHeight = 115;
static CGFloat const kBannerViewSpacing = 20;
static CGFloat const kBannerViewY = 15;
static CGFloat const kCategoriesViewHeight = 155;
static CGFloat const kCaregoriesCellWidth = 55;
static CGFloat const kExploreCellTopBottomHeight = 77;

static NSString *const kExploreCellIdentifier = @"kExploreCellIdentifier";
// banner
static NSString *const kUrlBanner = @"/banners/explore";
// 分类列表
static NSString *const kUrlCategorie = @"/official/categories";
// 编辑推荐
static NSString *const kUrlRecommend = @"/column/explore_recommend";
// 特色品牌馆
static NSString *const kUrlBrandHall = @"/column/feature_store";
// 优质新品
static NSString *const kUrlNewProduct = @"/column/explore_new";
// 集合
static NSString *const kUrlSet = @"/column/collections";
// 特惠好设计
static NSString *const kUrlGoodDesign = @"/column/preferential_design";
// 百元好物
static NSString *const kUrlHundredGoodThings  = @"/column/affordable_goods";

@interface THNExploresViewController ()<THNExploreTableViewCellDelegate, THNBannerViewDelegate>

@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) THNCategoriesCollectionView *categoriesCollectionView;
@property (nonatomic, assign) ExploreCellType cellType;
@property (nonatomic, strong) NSArray *recommendDataArray;
@property (nonatomic, strong) NSArray *goodThingDataArray;
@property (nonatomic, strong) NSArray *brandHallDataArray;
@property (nonatomic, strong) NSArray *productNewDataArray;
@property (nonatomic, strong) NSArray *goodDesignDataArray;
@property (nonatomic, strong) NSArray *setDataArray;
@property (nonatomic, strong) NSString *recommendTitle;
@property (nonatomic, strong) NSString *brandHallTitle;
@property (nonatomic, strong) NSString *productNewTitle;
@property (nonatomic, strong) NSString *setTitle;
@property (nonatomic, strong) NSString *goodDesignTitle;
@property (nonatomic, strong) NSString *goodThingTitle;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation THNExploresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadBrandHallData) name:@"FollowStoreSuccess" object:nil];
    [self setupUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hiddenHud];
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
    [self showHud];
    
    dispatch_group_async(group, queue, ^{
        [self loadBannerData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadSetData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadBrandHallData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadCategorieData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadRecommendData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadNewProductData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadGoodDesignData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadGoodThingData];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)setupUI {
    // 抖动闪动漂移等问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.bounces = NO;
    // tableView内容向下偏移20pt或向下偏移64pt,导致一进来就走scrollViewDid代理方法
    // 链接 : https://blog.csdn.net/yuhao309/article/details/78864211
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 请求数据
// banner
- (void)loadBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBanner requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
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

// 分类列表
- (void)loadCategorieData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlCategorie requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        THNLog(@"-------- %@", result.responseDict);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.categoriesCollectionView.categorieDataArray = result.data[@"categories"];
        [self.categoriesCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 编辑推荐
- (void)loadRecommendData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlRecommend requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.recommendTitle = result.data[@"title"];
        self.recommendDataArray = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 特色品牌馆
- (void)loadBrandHallData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHall requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
       NSInteger signalQuantity =  dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.brandHallDataArray = [THNFeaturedBrandModel mj_objectArrayWithKeyValuesArray:result.data[@"stores"]];
        self.brandHallTitle = result.data[@"title"];

        if (signalQuantity == 0) {
            [self.tableView reloadData];
        }
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 优质新品
- (void)loadNewProductData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlNewProduct requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.productNewTitle = result.data[@"title"];
        self.productNewDataArray = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 集合
- (void)loadSetData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlSet requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.setTitle = result.data[@"title"];
        self.setDataArray = result.data[@"collections"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 特惠好设计
- (void)loadGoodDesignData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlGoodDesign requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.goodDesignTitle = result.data[@"title"];
        self.goodDesignDataArray = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 百元好物
- (void)loadGoodThingData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlHundredGoodThings requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.goodThingTitle = result.data[@"title"];
        self.goodThingDataArray = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

#pragma mark UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allLinesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNExploreTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"THNExploreTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delagate = self;
    
    NSArray *dataArray = [NSArray array];
    NSString *title;
    
    switch (indexPath.row) {
        case 0:
            self.cellType = ExploreRecommend;
            dataArray = self.recommendDataArray;
            title = self.recommendTitle;
            break;
        case 1:
            dataArray = self.brandHallDataArray;
            title = self.brandHallTitle;
            dataArray = self.brandHallDataArray;
            self.cellType = ExploreFeaturedBrand;
            break;
        case 2:
            self.cellType = ExploreNewProduct;
            dataArray = self.productNewDataArray;
            title = self.productNewTitle;
            break;
        case 3:
            self.cellType = ExploreSet;
            dataArray = self.setDataArray;
            title = self.setTitle;
            break;
        case 4:
            self.cellType = ExploreGoodDesign;
            dataArray = self.goodDesignDataArray;
            title = self.goodDesignTitle;
            break;
        case 5:
            self.cellType = ExploreGoodThings;
            dataArray = self.goodThingDataArray;
            title = self.goodThingTitle;
            break;
    }
    
    [cell setCellTypeStyle:self.cellType initWithDataArray:dataArray initWithTitle:title];
    return cell;
}

#pragma mark - UITableViewDelegate method 实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
        case ExploreFeaturedBrand:
           return cellFeaturedBrandHeight + kExploreCellTopBottomHeight;
            break;
        case ExploreSet:
            return cellSetHeight + kExploreCellTopBottomHeight;
            break;
        default :
            return cellOtherHeight + kExploreCellTopBottomHeight;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.categoriesCollectionView.frame))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    self.bannerView.delegate = self;
    [headerView addSubview:self.bannerView];
    self.categoriesCollectionView.categoriesBlock = ^(NSString *categorieID, NSString *name) {
        THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithCategoryId:categorieID categoryName:name];
        [weakSelf.navigationController pushViewController:goodsListVC animated:YES];
    };
    
    [headerView addSubview:self.categoriesCollectionView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.categoriesCollectionView.frame);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:THNHomeVCDidScrollView object:nil userInfo:@{kScrollDistance : @(scrollView.contentOffset.y - self.lastContentOffset)}];
    // 解决一直上拉搜索动画导致闪动的问题
    self.tableView.bounces = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 解决下拉搜索框位置无法改变的问题
    self.tableView.bounces = YES;
    self.lastContentOffset = scrollView.contentOffset.y;
}


#pragma mark - THNExploreTableViewCellDelegate
- (void)lookAllWithType:(ExploreCellType)cellType {
    switch (cellType) {
        case ExploreRecommend: {
            THNGoodsListViewController *goodsList = [[THNGoodsListViewController alloc] initWithGoodsListType:THNGoodsListViewTypeEditors
                                                                                                        title:self.recommendTitle];
            [self.navigationController pushViewController:goodsList animated:YES];
            break;
        }
        case ExploreFeaturedBrand: {
            THNAllBrandHallViewController *brandHall = [[THNAllBrandHallViewController alloc]init];
            [self.navigationController pushViewController:brandHall animated:YES];
            break;
        }
            
        case ExploreNewProduct: {
            THNGoodsListViewController *goodsList = [[THNGoodsListViewController alloc] initWithGoodsListType:THNGoodsListViewTypeNewProduct
                                                                                                        title:self.productNewTitle];
            [self.navigationController pushViewController:goodsList animated:YES];
            break;
        }
            
        case ExploreSet: {
            THNAllsetTableViewController *set = [[THNAllsetTableViewController alloc]init];
            [self.navigationController pushViewController:set animated:YES];
            break;
        }
            
        case ExploreGoodDesign: {
            THNGoodsListViewController *goodsList = [[THNGoodsListViewController alloc] initWithGoodsListType:THNGoodsListViewTypeDesign
                                                                                                        title:self.goodDesignTitle];
            [self.navigationController pushViewController:goodsList animated:YES];
            break;
        }
            
        case ExploreGoodThings: {
            THNGoodsListViewController *goodsList = [[THNGoodsListViewController alloc] initWithGoodsListType:THNGoodsListViewTypeGoodThing
                                                                                                        title:self.goodThingTitle];
            [self.navigationController pushViewController:goodsList animated:YES];
            break;
        }
    }
}

// 品牌馆详情
- (void)pushBrandHall:(THNFeaturedBrandModel *)featuredBrandModel {
    THNBrandHallViewController *brandHall = [[THNBrandHallViewController alloc]init];
    brandHall.rid = featuredBrandModel.rid;
    [self.navigationController pushViewController:brandHall animated:YES];
}

// 集合详情
- (void)pushSetDetail:(THNSetModel *)setModel {
    THNSetDetailViewController *setDetail = [[THNSetDetailViewController alloc]init];
    setDetail.collectionID = setModel.collectionID;
    [self.navigationController pushViewController:setDetail animated:YES];
}

// 商品详情
- (void)pushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
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

#pragma mark -lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(kBannerViewSpacing, kBannerViewY, SCREEN_WIDTH - kBannerViewSpacing * 2, kBannerViewHeight)];
    }
    return _bannerView;
}

- (THNCategoriesCollectionView *)categoriesCollectionView {
    if (!_categoriesCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] initWithLineSpacing:25
                                                                                       initWithWidth:kCaregoriesCellWidth
                                                                                      initwithHeight:kCategoriesViewHeight];
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        
        _categoriesCollectionView = [[THNCategoriesCollectionView alloc] initWithFrame: 
                                     CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), SCREEN_WIDTH, kCategoriesViewHeight)
                                                                  collectionViewLayout:layout];
    }
    return _categoriesCollectionView;
}


@end
