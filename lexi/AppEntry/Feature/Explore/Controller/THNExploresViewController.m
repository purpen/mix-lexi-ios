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

static CGFloat const kBannerViewHeight = 115;
static CGFloat const kBannerViewSpacing = 20;
static CGFloat const kBannerViewY = 15;
static CGFloat const kCategoriesViewHeight = 155;
static CGFloat const kCaregoriesCellWidth = 55;
static CGFloat const kExploreCellTopBottomHeight = 87;
static NSString *const kExploreCellIdentifier = @"kExploreCellIdentifier";

@interface THNExploresViewController () 

@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) THNCategoriesCollectionView *categoriesCollectionView;
@property (nonatomic, assign) ExploreCellType cellType;

@end

@implementation THNExploresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNExploreTableViewCell" bundle:nil] forCellReuseIdentifier:kExploreCellIdentifier];
}

- (void)loadData {
    //@"https://kg.erp.taihuoniao.com/20180706/4605FpseCHcjdicYOsLROtwF_SVFKg_9.jpg",@"https://kg.erp.taihuoniao.com/20180702/3306FghyFReC2A0CWCUoZ4nTDV1KdhWT.jpg
    NSArray * array = @[@"https://kg.erp.taihuoniao.com/20180711/1808FgkTUxcFE3_2DAXlTdi4rQMRU7IY.jpg",@"https://kg.erp.taihuoniao.com/20180705/2856FgnuLr9GzH9Yg5Izfa3Cu5Y8iLHH.jpg",@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"];
    self.data = array;
    
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

#pragma mark -lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(kBannerViewSpacing, kBannerViewY, SCREEN_WIDTH - kBannerViewSpacing * 2, kBannerViewHeight) images:self.data];
    }
    return _bannerView;
}

- (THNCategoriesCollectionView *)categoriesCollectionView {
    if (!_categoriesCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:25 initWithWidth:kCaregoriesCellWidth initwithHeight:kCategoriesViewHeight];
        _categoriesCollectionView = [[THNCategoriesCollectionView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bannerView.frame), SCREEN_WIDTH, kCategoriesViewHeight) collectionViewLayout:layout];
    }
    return _categoriesCollectionView;
}

#pragma mark UITableViewDatesource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExploreCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 1:
            self.cellType = ExploreFeaturedBrand;
            break;
        case 3:
            self.cellType = ExploreSet;
            break;
        default:
            self.cellType = ExploreOther;
            break;
    }
    
    [cell setCellTypeStyle:self.cellType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
        case ExploreFeaturedBrand:
           return cellFeaturedBrandHeight + kExploreCellTopBottomHeight;
            break;
        case ExploreSet:
            return cellSetHeight + kExploreCellTopBottomHeight;
            break;
        case ExploreOther:
            return cellOtherHeight + kExploreCellTopBottomHeight;
            break;
    }
    
}


@end
