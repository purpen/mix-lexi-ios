//
//  THNLifeTransactionRecordsViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeTransactionRecordsViewController.h"
#import "THNEarningsView.h"
#import "THNEarningsDateView.h"
#import "THNLifeSegmentView.h"
#import "THNLifeTransactionRecordTableViewCell.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

/// cell id
static NSString *const kRecordTableViewCellId = @"THNLifeTransactionRecordTableViewCellId";
/// text
static NSString *const kTextRecords   = @"交易记录";
static NSString *const kTextDateWeek  = @"week";
static NSString *const kTextDateMonth = @"month";
/// key
static NSString *const kKeyPage     = @"page";
static NSString *const kKeyStatus   = @"status";
static NSString *const kKeyDate     = @"date_range";

@interface THNLifeTransactionRecordsViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNLifeSegmentViewDelegate,
    THNEarningsDateViewDelegate
>

// 功能按钮
@property (nonatomic, strong) THNLifeSegmentView *segmentView;
// 收益视图
@property (nonatomic, strong) THNEarningsView *earningsView;
// 交易记录选择日期
@property (nonatomic, strong) THNEarningsDateView *dateView;
// 记录
@property (nonatomic, strong) UITableView *recordTable;
// 头部视图
@property (nonatomic, strong) UIView *headerView;
// 当前页码
@property (nonatomic, assign) NSInteger page;
// 记录状态：0、全部 1、待结算 2、成功 3、退款
@property (nonatomic, assign) NSInteger status;
// 时间区间
@property (nonatomic, strong) NSString *dateRange;
// 数据
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation THNLifeTransactionRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setDefaultValue];
    [self thn_getLifeTransactionData];
    [self thn_getTransactionsRecordData];
    [self setupUI];
}

- (void)thn_getLifeTransactionData {
    WEAKSELF;
    
    [THNLifeManager getLifeOrdersSaleCollectWithRid:[THNLoginManager sharedManager].storeRid
                                         completion:^(THNLifeSaleCollectModel *model, NSError *error) {
                                             if (error) {
                                                 [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                 return ;
                                             }
                                             
                                             [weakSelf.earningsView thn_setLifeSaleColleciton:model];
                                         }];
}

- (void)thn_getTransactionsRecordData {
    WEAKSELF;
    
    [THNLifeManager getLifeTransactionsRecordWithRid:[THNLoginManager sharedManager].storeRid
                                              params:[self thn_getRequestParams]
                                          completion:^(THNTransactionsDataModel *model, NSError *error) {
                                              if (error) {
                                                  [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                  return ;
                                              }
                                              
                                              weakSelf.modelArr = [NSArray arrayWithArray:model.transactions];
                                              [weakSelf.segmentView thn_setTransactionReadData:model];
                                              [weakSelf.recordTable reloadData];
                                          }];
}

#pragma mark - custom delegate
- (void)thn_didSelectedLifeSegmentIndex:(NSInteger)index {
    self.status = index;
    
    [self thn_getTransactionsRecordData];
}

- (void)thn_didSelectedDate {
    [SVProgressHUD showInfoWithStatus:@"选择日期"];
}

- (void)thn_didSelectedDateWithDefaultIndex:(NSInteger)index {
    NSString *dateStr = index == 0 ? kTextDateWeek : kTextDateMonth;
    self.dateRange = dateStr;
    
    [self thn_getTransactionsRecordData];
}

#pragma mark - private methods
- (void)thn_setDefaultValue {
    self.dateRange = kTextDateWeek;
    self.page = 1;
    self.status = 0;
}

- (NSDictionary *)thn_getRequestParams {
    NSDictionary *dict = @{kKeyDate: self.dateRange,
                           kKeyPage: @(self.page),
                           kKeyStatus: @(self.status)};
    
    return dict;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.headerView addSubview:self.earningsView];
    [self.headerView addSubview:self.dateView];
    self.recordTable.tableHeaderView = self.headerView;
    [self.view addSubview:self.recordTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextRecords;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeTransactionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellId];
    if (!cell) {
        cell = [[THNLifeTransactionRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kRecordTableViewCellId];
    }
    
    if (self.modelArr.count) {
        [cell thn_setLifeTransactionsData:self.modelArr[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - getters and setters
- (UITableView *)recordTable {
    if (!_recordTable) {
        _recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _recordTable.delegate = self;
        _recordTable.dataSource = self;
        _recordTable.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _recordTable.backgroundColor = [UIColor whiteColor];
        _recordTable.showsVerticalScrollIndicator = NO;
        _recordTable.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _recordTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _recordTable.tableFooterView = [UIView new];
    }
    return _recordTable;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 245)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (THNEarningsView *)earningsView {
    if (!_earningsView) {
        _earningsView = [[THNEarningsView alloc] initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 40, 140)];
    }
    return _earningsView;
}

- (THNEarningsDateView *)dateView {
    if (!_dateView) {
        _dateView = [[THNEarningsDateView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.earningsView.frame) + 30, SCREEN_WIDTH, 60)];
        _dateView.delegate = self;
    }
    return _dateView;
}

- (THNLifeSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[THNLifeSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)
                                                          titles:@[@"全部", @"待结算", @"成功", @"退款"]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}


@end
