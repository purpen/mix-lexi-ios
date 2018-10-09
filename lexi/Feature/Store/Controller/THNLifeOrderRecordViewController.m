//
//  THNLifeOrderRecordViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderRecordViewController.h"
#import "THNLifeOrderView.h"
#import "THNLifeSegmentView.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

static NSString *const kTextOrder = @"成交订单";
/// key
static NSString *const kKeyPage     = @"page";
static NSString *const kKeyStatus   = @"status";

@interface THNLifeOrderRecordViewController () <UITableViewDelegate, UITableViewDataSource, THNLifeSegmentViewDelegate>

// 功能按钮
@property (nonatomic, strong) THNLifeSegmentView *segmentView;
// 订单数据
@property (nonatomic, strong) THNLifeOrderView *orderDataView;
// 记录
@property (nonatomic, strong) UITableView *recordTable;
// 头部视图
@property (nonatomic, strong) UIView *headerView;
// 当前页码
@property (nonatomic, assign) NSInteger page;
// 记录状态：0、全部 1、待结算 2、成功 3、退款
@property (nonatomic, assign) NSInteger status;

@end

@implementation THNLifeOrderRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_getLifeOrderCollectData];
    [self thn_getLifeOrderRecordData];
    [self setupUI];
}

- (void)thn_getLifeOrderCollectData {
    WEAKSELF;
    
    [THNLifeManager getLifeOrdersCollectWithRid:[THNLoginManager sharedManager].storeRid
                                     completion:^(THNLifeOrdersCollectModel *model, NSError *error) {
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                             return ;
                                         }
                                         
                                         [weakSelf.orderDataView thn_setLifeOrdersCollect:model];
                                     }];
}

- (void)thn_getLifeOrderRecordData {
    WEAKSELF;
    
    [THNLifeManager getLifeOrderRecordWithRid:[THNLoginManager sharedManager].storeRid
                                       params:[self thn_getRequestParams]
                                   completion:^(THNLifeOrderDataModel *model, NSError *error) {
                                       if (error) {
                                           [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                           return ;
                                       }
                                       
                                       [weakSelf.segmentView thn_setLifeOrderReadData:model];
                                   }];
}

#pragma mark - custom delegate
- (void)thn_didSelectedLifeSegmentIndex:(NSInteger)index {
    self.status = index;
}

#pragma mark - private methods
- (void)thn_setDefaultValue {
    self.page = 1;
    self.status = 0;
}

- (NSDictionary *)thn_getRequestParams {
    NSDictionary *dict = @{kKeyPage: @(self.page),
                           kKeyStatus: @(self.status)};
    
    return dict;
}

#pragma mark - setup UI
- (void)setupUI {
    self.recordTable.tableHeaderView = self.orderDataView;
    [self.view addSubview:self.recordTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextOrder;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 14;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellID"];
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

- (THNLifeOrderView *)orderDataView {
    if (!_orderDataView) {
        _orderDataView = [[THNLifeOrderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 142)];
    }
    return _orderDataView;
}

- (THNLifeSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[THNLifeSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)
                                                          titles:@[@"全部", @"待发货", @"已收货", @"已完成"]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

@end
