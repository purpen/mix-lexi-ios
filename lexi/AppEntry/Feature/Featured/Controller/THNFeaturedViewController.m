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

static CGFloat const kFeaturedCellTopBottomHeight = 90;
static CGFloat const kPopularFooterViewHeight = 180;
static CGFloat const kFeaturedX = 20;
static NSString *const kFeaturedCellIdentifier = @"kFeaturedCellIdentifier";

@interface THNFeaturedViewController ()

@property (nonatomic, strong) THNFeaturedCollectionView *featuredCollectionView;
@property (nonatomic, strong) THNFeaturedOpeningView *openingView;
@property (nonatomic, strong) THNActivityView *activityView;
@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) FeaturedCellType cellType;
@property (nonatomic, strong) NSArray *data;

@end

@implementation THNFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    return [super initWithStyle:UITableViewStyleGrouped];
    
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
}

- (void)loadData {
    NSArray * array = @[@"https://kg.erp.taihuoniao.com/20180711/1808FgkTUxcFE3_2DAXlTdi4rQMRU7IY.jpg",@"https://kg.erp.taihuoniao.com/20180705/2856FgnuLr9GzH9Yg5Izfa3Cu5Y8iLHH.jpg",@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"];
    self.data = array;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.openingView.frame) + 10)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:self.featuredCollectionView];
        [headerView addSubview:self.openingView];
        return headerView;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGRectGetMaxY(self.openingView.frame) + 10;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     THNFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeaturedCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            self.cellType = FeaturedRecommendedToday;
            break;
        case 1:
            self.cellType = FeaturedRecommendationPopular;
            break;
        case 2:
            self.cellType = FeaturedLifeAesthetics;
            break;
        case 3:
            self.cellType = FearuredOptimal;
            break;
        default:
            self.cellType = FearuredGrassList;
    }
    [cell setCellTypeStyle:self.cellType];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.activityView;
    } else if (section == 1){
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPopularFooterViewHeight)];
        footerView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:self.lineView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
            
        case FeaturedRecommendedToday:
            return kCellTodayHeight + kFeaturedCellTopBottomHeight;
            break;
        case FeaturedLifeAesthetics:
            return kCellLifeAestheticsHeight + kFeaturedCellTopBottomHeight;
            break;
        case FearuredOptimal:
            return kCellOptimalHeight * 2 + 20 + kFeaturedCellTopBottomHeight;
            break;
        case FearuredGrassList:
            return kCellGrassListHeight * 2 + 20 + kFeaturedCellTopBottomHeight;
            break;
        case FeaturedRecommendationPopular:
            return kCellPopularHeight + kFeaturedCellTopBottomHeight;
    }
}

#pragma mark - lazy
- (THNFeaturedCollectionView *)featuredCollectionView {
    if (!_featuredCollectionView) {
        THNCollectionViewFlowLayout *flowLayout = [[THNCollectionViewFlowLayout alloc]init];
        _featuredCollectionView = [[THNFeaturedCollectionView alloc]initWithFrame:CGRectMake(kFeaturedX, 15, SCREEN_WIDTH - kFeaturedX, 200) collectionViewLayout:flowLayout withDataArray:self.data];
    }
    return _featuredCollectionView;
}

- (THNFeaturedOpeningView *)openingView {
    if (!_openingView) {
        _openingView = [THNFeaturedOpeningView viewFromXib];
        _openingView.frame = CGRectMake(15, CGRectGetMaxY(self.featuredCollectionView.frame) + 20, SCREEN_WIDTH - 30, 156);
    }
    return _openingView;
}

- (THNActivityView *)activityView {
    if (!_activityView) {
        _activityView = [THNActivityView viewFromXib];
    }
    return _activityView;
}

- (THNBannerView *)bannerView {
    if (!_bannerView) {
        NSArray * array = @[@"https://kg.erp.taihuoniao.com/20180711/1808FgkTUxcFE3_2DAXlTdi4rQMRU7IY.jpg",@"https://kg.erp.taihuoniao.com/20180705/2856FgnuLr9GzH9Yg5Izfa3Cu5Y8iLHH.jpg",@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"];
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(kFeaturedX, 20, SCREEN_WIDTH - kFeaturedX * 2, 140) images:array];
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

@end
