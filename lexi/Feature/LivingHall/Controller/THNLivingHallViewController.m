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

static CGFloat const livingHallHeaderViewHeight = 500;
static CGFloat const expandViewHeight = 59;
static CGFloat const cellSpacing = 15;
static NSString *const kLivingHallRecommendCellIdentifier = @"kLivingHallRecommendCellIdentifier";
// 馆长推荐
static NSString *const kUrlCuratorRecommended = @"/fx_distribute/agency";
// 删除商品
static NSString *const kUrlDeleteProduct = @"/fx_distribute/remove";
// 本周最受欢迎
static NSString *const kUrlWeekPopular = @"/fx_distribute/week_popular";

@interface THNLivingHallViewController ()

@property (nonatomic, strong) THNLivingHallHeaderView *livingHallHeaderView;
@property (nonatomic, strong) THNFeatureTableViewCell *featureCell;
@property (nonatomic, strong)  THNLivingHallExpandView *expandView;
@property (nonatomic, strong) NSArray *recommendedArray;
@property (nonatomic, strong) NSArray *weekPopularArray;
@property (nonatomic, strong) NSMutableArray *recommendedMutableArray;
@property (nonatomic, strong) NSArray *likeProductUserArray;
@property (nonatomic, assign) CGFloat recommenLabelHegiht;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger curatorPerPageCount;
@property (nonatomic, assign) NSInteger weekPopularPerPageCount;

@end

@implementation THNLivingHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllData];
    [self setupUI];
}

- (void)loadAllData {
    [self initPageNumber];
    [self.livingHallHeaderView setLifeStore];
    [self loadCuratorRecommendedData];
    [self loadWeekPopularData];
}

// 初始化页码
- (void)initPageNumber {
    self.pageCount = 1;
    self.curatorPerPageCount = 3;
    self.weekPopularPerPageCount = 4;
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
    params[@"per_page"] = @(self.curatorPerPageCount);
    params[@"user_record"] = @(1);
    THNRequest *request = [THNAPI getWithUrlString:kUrlCuratorRecommended requestDictionary:params isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.recommendedArray = result.data[@"products"];
        self.expandView.hidden = self.recommendedArray.count < self.curatorPerPageCount ? : NO;
        
        for (NSDictionary *dict in self.recommendedArray) {
            [self.recommendedmutableArray addObject:dict];
        }
        
        if (self.recommendedmutableArray.count > 0) {
            self.livingHallHeaderView.noProductView.hidden = YES;
            [self.tableView reloadData];
        }
        
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 删除馆长推荐商品
- (void)deleteProduct:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlDeleteProduct requestDictionary:params isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self loadCuratorRecommendedData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 本周最受人气欢迎
- (void)loadWeekPopularData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(1);
    params[@"per_page"] = @(self.weekPopularPerPageCount);
    THNRequest *request = [THNAPI getWithUrlString:kUrlWeekPopular requestDictionary:params isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.weekPopularArray = result.data[@"products"];
        self.title = result.data[@"title"];
        [self.featureCell setCellTypeStyle:FeaturedNo initWithDataArray:self.weekPopularArray initWithTitle:@"本周最受欢迎"];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource method 实现
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
    
    __weak typeof(self)weakSelf = self;
    cell.deleteProductBlock = ^(UITableViewCell *cell) {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
         THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedmutableArray[indexPath.row]];
        [weakSelf deleteProduct:productModel.rid];
    };
    return cell;
}

#pragma mark - UITableViewDelegate method 实现
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([THNSaveTool objectForKey:kIsCloseLivingHallView]) {
        return self.livingHallHeaderView.noProductView.hidden ? livingHallHeaderViewHeight - 115 - 100 : livingHallHeaderViewHeight - 100;
    } else {
          return self.livingHallHeaderView.noProductView.hidden ? livingHallHeaderViewHeight - 115 : livingHallHeaderViewHeight;
    }
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self)weakSelf = self;
    
    self.livingHallHeaderView.changeHeaderViewBlock = ^{
        [weakSelf.tableView reloadData];
    };
    
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
        _featureCell.frame = CGRectMake(0, -cellSpacing + expandViewHeight, SCREEN_WIDTH, 200 * 2 + 90 + 20);
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
