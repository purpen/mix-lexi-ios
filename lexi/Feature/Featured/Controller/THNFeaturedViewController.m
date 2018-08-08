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
#import "THNLifeRecordModel.h"
#import "THNLoginManager.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"

// cell共用上下的高
static CGFloat const kFeaturedCellTopBottomHeight = 90;
static CGFloat const kPopularFooterViewHeight = 180;
static CGFloat const kFeaturedX = 20;
static NSString *const kFeaturedCellIdentifier = @"kFeaturedCellIdentifier";
// 顶部banner
static NSString *const kUrlBannersHandpickTop = @"/banners/handpick";
// 人气推荐
static NSString *const kUrlColumnHandpickRecommend = @"/column/handpick_recommend";
// 发现生活美学
static NSString *const kUrlLifeAesthetics = @"/shop_windows/recommend";
// 乐喜优选
static NSString *const kUrlColumnHandpickOptimization = @"/column/handpick_optimization";
// 种草清单
static NSString *const kUrlLifeRecords = @"/life_records/recommend";
// 内容区banner
static NSString *const kUrlBannersHandpickContent = @"/banners/handpick_content";

@interface THNFeaturedViewController ()

@property (nonatomic, strong) THNFeaturedCollectionView *featuredCollectionView;
@property (nonatomic, strong) THNFeaturedOpeningView *openingView;
@property (nonatomic, strong) THNActivityView *activityView;
@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) FeaturedCellType cellType;
@property (nonatomic, strong) NSString * pupularTitle;
@property (nonatomic, strong) NSString *optimalTitle;
@property (nonatomic, strong) NSArray *popularDataArray;
@property (nonatomic, strong) NSArray *optimalDataArray;
@property (nonatomic, strong) NSArray *lifeRecordDataArray;
@property (nonatomic, strong) NSMutableArray *grassLabelHeights;

@end

@implementation THNFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTopBannerData];
    [self loadContentBannerData];
    [self loadPupularData];
    [self loadOptimalData];
    [self loadLifeAestheticData];
    [self loadGrassListData];
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

#pragma mark - 请求数据
// 顶部Banner
- (void)loadTopBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBannersHandpickTop requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.featuredCollectionView.dataArray = result.data[@"banner_images"];
        [self.featuredCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 内容区Banner
- (void)loadContentBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBannersHandpickContent requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.bannerView.bannerDataArray = result.data[@"banner_images"];
        [self.bannerView.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}
// 人气推荐
- (void)loadPupularData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlColumnHandpickRecommend requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.pupularTitle = result.data[@"title"];
        self.popularDataArray = result.data[@"products"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 发现生活美学
- (void)loadLifeAestheticData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeAesthetics requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//优选
- (void)loadOptimalData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlColumnHandpickOptimization requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.optimalTitle = result.data[@"title"];
        self.optimalDataArray = result.data[@"products"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//种草清单
- (void)loadGrassListData {
    THNRequest *request= [THNAPI getWithUrlString:kUrlLifeRecords requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.lifeRecordDataArray = result.data[@"life_records"];
       [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

#pragma mark - UITableViewDelegate mehtod 实现
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.openingView.frame) + 10)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:self.featuredCollectionView];
        [headerView addSubview:self.openingView];
        __weak typeof(self)weakSelf = self;
        self.openingView.openingBlcok = ^{
            
            if (![THNLoginManager isLogin]) {
                THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
                THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
                [weakSelf presentViewController:navController animated:YES completion:nil];
            }
            
        };
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeaturedCellIdentifier forIndexPath:indexPath];
    NSArray *dataArray = [NSArray array];
    NSString *title;
    
    switch (self.cellType) {
        case FeaturedRecommendedToday:
            break;
        case FeaturedLifeAesthetics:
            break;
        case FearuredOptimal:
            dataArray = self.optimalDataArray;
            title = self.optimalTitle;
            break;
        case FearuredGrassList:
            cell.grassLabelHeights = self.grassLabelHeights;
            dataArray = self.lifeRecordDataArray;
            break;
        case FeaturedRecommendationPopular:
            dataArray = self.popularDataArray;
            title = self.pupularTitle;
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
            return kCellPopularHeight + kFeaturedCellTopBottomHeight;
            break;
        case 2:
            self.cellType = FeaturedLifeAesthetics;
             return kCellLifeAestheticsHeight + kFeaturedCellTopBottomHeight;
            break;
        case 3:
            self.cellType = FearuredOptimal;
            return kCellOptimalHeight * 2 + 20 + kFeaturedCellTopBottomHeight;
            break;
        case 4:
            self.cellType = FearuredGrassList;
           __block CGFloat firstRowMaxtitleHeight = 0;
           __block CGFloat firstRowMaxcontentHeight = 0;
           __block CGFloat secondRowMaxtitleHeight = 0;
            __block CGFloat secondRowMaxcontentHeight = 0;
            // 多次执行该方法造成重复的计算
            if (self.grassLabelHeights.count == 0) {
                [self.lifeRecordDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    THNLifeRecordModel *lifeRecordModel = [THNLifeRecordModel mj_objectWithKeyValues:obj];
                    //  设置最大size
                    CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
                    CGFloat contentMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 10.5;
                    CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
                    CGSize contentSize = CGSizeMake(contentMaxWidth, 33);
                    NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]};
                    NSDictionary *contentFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:11]};
                    CGFloat titleHeight = [lifeRecordModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
                    CGFloat contentHeight = [lifeRecordModel.content boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentFont context:nil].size.height;
                    
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
                }];
                
               
            }
             CGFloat customGrassCellHeight = firstRowMaxtitleHeight + secondRowMaxtitleHeight + firstRowMaxcontentHeight + secondRowMaxcontentHeight;
             return kCellGrassListHeight * 2 + customGrassCellHeight + 20 + kFeaturedCellTopBottomHeight;
            break;
    }
    
    return 0;
    
}

#pragma mark - lazy
- (THNFeaturedCollectionView *)featuredCollectionView {
    if (!_featuredCollectionView) {
        THNCollectionViewFlowLayout *flowLayout = [[THNCollectionViewFlowLayout alloc]init];
        _featuredCollectionView = [[THNFeaturedCollectionView alloc]initWithFrame:CGRectMake(kFeaturedX, 15, SCREEN_WIDTH - kFeaturedX, 200) collectionViewLayout:flowLayout];
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

@end
