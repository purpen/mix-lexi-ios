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

static CGFloat const livingHallHeaderViewHeight = 500;
static CGFloat const expandViewHeight = 59;
static CGFloat const cellSpacing = 15;
static NSInteger const perPageCount = 3;
static NSString *const kLivingHallRecommendCellIdentifier = @"kLivingHallRecommendCellIdentifier";
// 馆长推荐
static NSString *const kUrlCuratorRecommended = @"/fx_distribute/agency";

@interface THNLivingHallViewController ()

@property (nonatomic, strong) THNLivingHallHeaderView *livingHallHeaderView;
@property (nonatomic, strong) THNFeatureTableViewCell *featureCell;
@property (nonatomic, strong)  THNLivingHallExpandView *expandView;
@property (nonatomic, strong) NSArray *recommendedArray;
@property (nonatomic, strong) NSMutableArray *recommendedMutableArray;
@property (nonatomic, strong) NSArray *likeProductUserArray;
@property (nonatomic, assign) CGFloat recommenLabelHegiht;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation THNLivingHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCount = 1;
    [self.livingHallHeaderView setLifeStore];
    [self loadCuratorRecommendedData];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"THNLivingHallRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:kLivingHallRecommendCellIdentifier];
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

// 馆长推荐
- (void)loadCuratorRecommendedData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(perPageCount);
    THNRequest *request = [THNAPI getWithUrlString:kUrlCuratorRecommended requestDictionary:params isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.recommendedArray = result.data[@"products"];
        self.expandView.hidden = self.recommendedArray.count < perPageCount ? : NO;
        
        for (NSDictionary *dict in self.recommendedArray) {
            [self.recommendedmutableArray addObject:dict];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendedmutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLivingHallRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLivingHallRecommendCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedmutableArray[indexPath.row]];
    // 设置喜欢用户头像
    [cell loadLikeProductUserData:productModel.rid];
    // 设置馆长头像
    [cell setCurtorAvatar:self.livingHallHeaderView.storeAvatarUrl];
    [cell setProductModel:productModel];
    return cell;
}

#pragma mark - UITableViewDelegate method 实现
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return livingHallHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.livingHallHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.expandView.hidden) {
        self.featureCell.viewY = 0;
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, -15, SCREEN_WIDTH,CGRectGetMaxY(self.featureCell.frame))];
    self.featureCell.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    
    self.expandView.loadMoreDateBlcok = ^{
        weakSelf.pageCount++;
        [weakSelf loadCuratorRecommendedData];
    };
    [footerView addSubview:self.featureCell];
    [footerView addSubview:self.expandView];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kCellOptimalHeight * 2 + 20 + 90;
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
        _featureCell.frame = CGRectMake(0, -cellSpacing + expandViewHeight, SCREEN_WIDTH, 190 * 2 + 90);
//        [_featureCell setCellTypeStyle:FearuredOptimal initWithDataArray:nil initWithTitle:@"最受人气欢迎"];
    }
    return _featureCell;
}

- (THNLivingHallExpandView *)expandView {
    if (!_expandView) {
        _expandView = [THNLivingHallExpandView viewFromXib];
        _expandView.frame = CGRectMake(0, -cellSpacing, SCREEN_WIDTH, expandViewHeight);
    }
    return _expandView;
}

- (NSMutableArray *)recommendedmutableArray {
    if (!_recommendedMutableArray) {
        _recommendedMutableArray = [NSMutableArray array];
    }
    return _recommendedMutableArray;
}

@end
