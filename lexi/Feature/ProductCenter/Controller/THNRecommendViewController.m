//
//  THNRecommendTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNRecommendViewController.h"
#import "THNMarco.h"
#import "THNFeaturedCollectionView.h"
#import "THNAPI.h"
#import "THNCollectionViewFlowLayout.h"
#import "THNFeaturedOpeningView.h"
#import "UIView+Helper.h"
#import "THNExploresViewController.h"
#import "UIColor+Extension.h"
#import "THNSelectButtonView.h"
#import "THNAPI.h"
#import "THNCenterProductTableViewCell.h"
#import "THNProductModel.h"
#import "THNShelfViewController.h"
#import "THNGoodsInfoViewController.h"
#import "THNBrandHallViewController.h"
#import "THNArticleViewController.h"
#import "THNGoodsListViewController.h"
#import "UIViewController+THNHud.h"
#import "THNLoginManager.h"
#import "THNWebKitViewViewController.h"

static NSString *const kCenterProductCellIdentifier = @"kCenterProductCellIdentifier";
static NSString *const kUrlDistributeHot = @"/fx_distribute/hot";
static NSString *const kUrlDistributeSticked = @"/fx_distribute/sticked";
static NSString *const kUrlDistributeLatest = @"/fx_distribute/latest";

@interface THNRecommendViewController ()<THNSelectButtonViewDelegate, THNCenterProductTableViewCellDelegate, THNFeaturedCollectionViewDelegate>

@property (nonatomic, strong) THNFeaturedCollectionView *featuredCollectionView;
@property (nonatomic, strong) THNFeaturedOpeningView *openingView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) NSArray *hotDataArray;
@property (nonatomic, strong) NSArray *officialRecommendDataArray;
@property (nonatomic, strong) NSArray *dataArrayNew;

@end

@implementation THNRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:kShelfSuccess object:nil];
    [self loadDistributeHotData];
    [self loadDistributeStickedData];
    [self loadDistributeLatestData];
    [self loadTopBannerData];
    [self setupUI];
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)setupUI {
    self.productType = ProductTypeHot;
    self.tableView.rowHeight = 171;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNCenterProductTableViewCell" bundle:nil] forCellReuseIdentifier:kCenterProductCellIdentifier];
}

- (void)refreshData {
    switch (self.productType) {
        case ProductTypeHot:
            [self loadDistributeHotData];
            break;
        case ProductTypeNew:
            [self loadDistributeLatestData];
            break;
        case ProductTypeOfficialRecommend:
            [self loadDistributeStickedData];
            break;
    }
}

// 顶部Banner
- (void)loadTopBannerData {
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:@"/banners/center_ad" requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.featuredCollectionView.banners = result.data[@"banner_images"];
        self.featuredCollectionView.bannerType = BannerTypeCenter;
        [self.featuredCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 热门单品
- (void)loadDistributeHotData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeHot requestDictionary:params  delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        self.hotDataArray = result.data[@"products"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// 官方推荐
- (void)loadDistributeStickedData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeSticked requestDictionary:params  delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.officialRecommendDataArray = result.data[@"products"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//新品首发
- (void)loadDistributeLatestData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeLatest requestDictionary:params  delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.dataArrayNew = result.data[@"products"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
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

- (void)bannerPushCategorie:(NSString *)name initWithCategoriesID:(NSInteger)categorieID {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithCategoryId:categorieID categoryName:name];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.productType) {
        case ProductTypeHot:
            return self.hotDataArray.count;
            break;
         case ProductTypeOfficialRecommend:
            return self.officialRecommendDataArray.count;
            break;
        default:
            return self.dataArrayNew.count;
            break;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCenterProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCenterProductCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    THNProductModel *productModel;
    switch (self.productType) {
        case ProductTypeHot:
            productModel = [THNProductModel mj_objectWithKeyValues:self.hotDataArray[indexPath.row]];
            break;
        case ProductTypeOfficialRecommend:
            productModel = [THNProductModel mj_objectWithKeyValues:self.officialRecommendDataArray[indexPath.row]];
            break;
        default:
           productModel = [THNProductModel mj_objectWithKeyValues:self.dataArrayNew[indexPath.row]];
            break;
    }
    
    if (productModel) {
        [cell setProductModel:productModel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel;
    switch (self.productType) {
        case ProductTypeHot:
            productModel = [THNProductModel mj_objectWithKeyValues:self.hotDataArray[indexPath.row]];
            break;
        case ProductTypeOfficialRecommend:
            productModel = [THNProductModel mj_objectWithKeyValues:self.officialRecommendDataArray[indexPath.row]];
            break;
        default:
            productModel = [THNProductModel mj_objectWithKeyValues:self.dataArrayNew[indexPath.row]];
            break;
    }
    
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:productModel.rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.selectButtonView.frame);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.selectButtonView.frame))];
    [headerView addSubview:self.featuredCollectionView];
    [headerView addSubview:self.openingView];
    [self.openingView loadLivingHallHeadLineData:FeatureOpeningTypeProductCenterType];
    [headerView addSubview:self.selectButtonView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}


#pragma marl - THNCenterProductTableViewCellDelegate Method 实现
- (void)shelf:(THNCenterProductTableViewCell *)cell {
    THNShelfViewController *shelf = [[THNShelfViewController alloc]init];
    THNProductModel *productModel;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (self.productType) {
        case ProductTypeHot:
            productModel = [THNProductModel mj_objectWithKeyValues:self.hotDataArray[indexPath.row]];
            break;
        case ProductTypeOfficialRecommend:
            productModel = [THNProductModel mj_objectWithKeyValues:self.officialRecommendDataArray[indexPath.row]];
            break;
        default:
            productModel = [THNProductModel mj_objectWithKeyValues:self.dataArrayNew[indexPath.row]];
            break;
    }
    
    shelf.productModel = productModel;
    
    [self.navigationController pushViewController:shelf animated:YES];
}

#pragma mark - THNSelectButtonViewDelegate Method 实现
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            self.productType = ProductTypeHot;
            break;
        case 1:
            self.productType = ProductTypeOfficialRecommend;
            break;
        default:
            self.productType = ProductTypeNew;
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - lazy
- (THNFeaturedCollectionView *)featuredCollectionView {
    if (!_featuredCollectionView) {
        THNCollectionViewFlowLayout *flowLayout = [[THNCollectionViewFlowLayout alloc]init];
        CGFloat height = (SCREEN_WIDTH - 75) / 2;
        _featuredCollectionView = [[THNFeaturedCollectionView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, height) collectionViewLayout:flowLayout];
        _featuredCollectionView.featuredDelegate = self;
    }
    return _featuredCollectionView;
}

- (THNFeaturedOpeningView *)openingView {
    if (!_openingView) {
        _openingView = [THNFeaturedOpeningView viewFromXib];
        _openingView.topTintView.hidden = YES;
        _openingView.frame = CGRectMake(15, CGRectGetMaxY(self.featuredCollectionView.frame) + 20, SCREEN_WIDTH - 30, 70);
    }
    return _openingView;
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"热门单品", @"官方推荐", @"新品首发"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.openingView.frame), SCREEN_WIDTH, 60) titles:titleArray initWithButtonType:ButtonTypeDefault];
        _selectButtonView.delegate = self;
    }
    return _selectButtonView;
}

@end
