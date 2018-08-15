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

static NSInteger const allLinesCount = 6;
static CGFloat const kBannerViewHeight = 115;
static CGFloat const kBannerViewSpacing = 20;
static CGFloat const kBannerViewY = 15;
static CGFloat const kCategoriesViewHeight = 155;
static CGFloat const kCaregoriesCellWidth = 55;
static CGFloat const kExploreCellTopBottomHeight = 87;

static NSString *const kExploreCellIdentifier = @"kExploreCellIdentifier";
// banner
static NSString *const kUrlBanner = @"/banners/explore";
// 分类列表
static NSString *const kUrlCategorie = @"/categories";
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

@interface THNExploresViewController () 

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

@end

@implementation THNExploresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBannerData];
    [self loadCategorieData];
    [self loadRecommendData];
    [self loadBrandHallData];
    [self loadNewProductData];
    [self loadSetData];
    [self loadGoodDesignData];
    [self loadGoodThingData];
    [self setupUI];
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - 请求数据
// banner
- (void)loadBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBanner requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.bannerView setBannerView:result.data[@"banner_images"]];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 分类列表
- (void)loadCategorieData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlCategorie requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.categoriesCollectionView.categorieDataArray = result.data[@"categories"];
        [self.categoriesCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 编辑推荐
- (void)loadRecommendData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlRecommend requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.recommendTitle = result.data[@"title"];
        self.recommendDataArray = result.data[@"products"];
        [self reloadRowData:0];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 特色品牌馆
- (void)loadBrandHallData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHall requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.brandHallDataArray = result.data[@"stores"];
        self.brandHallTitle = result.data[@"title"];
        [self reloadRowData:1];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 优质新品
- (void)loadNewProductData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlNewProduct requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.productNewTitle = result.data[@"title"];
        self.productNewDataArray = result.data[@"products"];
       [self reloadRowData:2];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 集合
- (void)loadSetData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlSet requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.setTitle = result.data[@"title"];
        self.setDataArray = result.data[@"collections"];
        [self reloadRowData:3];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 特惠好设计
- (void)loadGoodDesignData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlGoodDesign requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.goodDesignTitle = result.data[@"title"];
        self.goodDesignDataArray = result.data[@"products"];
        [self reloadRowData:4];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 百元好物
- (void)loadGoodThingData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlHundredGoodThings requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.goodThingTitle = result.data[@"title"];
        self.goodThingDataArray = result.data[@"products"];
        [self reloadRowData:5];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)reloadRowData:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
    [headerView addSubview:self.bannerView];
    [headerView addSubview:self.categoriesCollectionView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.categoriesCollectionView.frame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        _categoriesCollectionView = [[THNCategoriesCollectionView alloc] initWithFrame: \
                                     CGRectMake(20, CGRectGetMaxY(self.bannerView.frame), SCREEN_WIDTH, kCategoriesViewHeight)
                                                                  collectionViewLayout:layout];
    }
    return _categoriesCollectionView;
}


@end
