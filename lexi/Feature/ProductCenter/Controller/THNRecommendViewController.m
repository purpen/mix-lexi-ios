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

static NSString *const kCenterProductCellIdentifier = @"kCenterProductCellIdentifier";
static NSString *const kUrlDistributeHot = @"/fx_distribute/hot";
static NSString *const kUrlDistributeSticked = @"/fx_distribute/sticked";
static NSString *const kUrlDistributeLatest = @"/fx_distribute/latest";

@interface THNRecommendViewController ()<THNSelectButtonViewDelegate, THNCenterProductTableViewCellDelegate>

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

// 顶部Banner
- (void)loadTopBannerData {
    THNRequest *request = [THNAPI getWithUrlString:@"/banners/center_ad" requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.featuredCollectionView.dataArray = result.data[@"banner_images"];
        self.featuredCollectionView.bannerType = BannerTypeCenter;
        [self.featuredCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 热门单品
- (void)loadDistributeHotData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeHot requestDictionary:nil  delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.hotDataArray = result.data[@"products"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 官方推荐
- (void)loadDistributeStickedData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeSticked requestDictionary:nil  delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.officialRecommendDataArray = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//新品首发
- (void)loadDistributeLatestData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeLatest requestDictionary:nil  delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.dataArrayNew = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - lazy
- (THNFeaturedCollectionView *)featuredCollectionView {
    if (!_featuredCollectionView) {
        THNCollectionViewFlowLayout *flowLayout = [[THNCollectionViewFlowLayout alloc]init];
        _featuredCollectionView = [[THNFeaturedCollectionView alloc]initWithFrame:CGRectMake(20 , 10, SCREEN_WIDTH, 140) collectionViewLayout:flowLayout];
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
    [cell setProductModel:productModel];
    return cell;
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

@end
