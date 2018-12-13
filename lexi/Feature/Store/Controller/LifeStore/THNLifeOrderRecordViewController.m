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
#import "THNLifeOrderStoreTableViewCell.h"
#import "THNLifeOrderInfoTableViewCell.h"
#import "THNLifeOrderProductTableViewCell.h"
#import "THNLifeOrderActionTableViewCell.h"

/// cell id
static NSString *const kOrderStoreTableViewCellId = @"THNLifeOrderStoreTableViewCellId";
static NSString *const kOrderInfoTableViewCellID = @"THNLifeOrderInfoTableViewCellId";
static NSString *const kOrderProductTableViewCellId = @"THNLifeOrderProductTableViewCell";
static NSString *const kOrderActionTableViewCellId = @"THNLifeOrderActionTableViewCell";
/// text
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
// 订单数据
@property (nonatomic, strong) NSMutableArray *orderArr;

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
                                         if (error) return;
                                         
                                         [weakSelf.orderDataView thn_setLifeOrdersCollect:model];
                                     }];
}

- (void)thn_getLifeOrderRecordData {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNLifeManager getLifeOrderRecordWithRid:[THNLoginManager sharedManager].storeRid
                                       params:[self thn_getRequestParams]
                                   completion:^(THNLifeOrderDataModel *model, NSError *error) {
                                       if (error) return;
                                       
                                       [weakSelf.segmentView thn_setLifeOrderReadData:model];
                                       [weakSelf thn_getOrdersDataOfModel:model.orders];
                                       [SVProgressHUD dismiss];
                                   }];
}

#pragma mark - custom delegate
- (void)thn_didSelectedLifeSegmentIndex:(NSInteger)index {
    self.status = index;
    
    [self.orderArr removeAllObjects];
    [self thn_getLifeOrderRecordData];
}

#pragma mark - private methods
- (void)thn_getOrdersDataOfModel:(NSArray *)orders {
    for (NSDictionary *dict in orders) {
        THNLifeOrderModel *orderModel = [THNLifeOrderModel mj_objectWithKeyValues:dict];
        [self.orderArr addObject:orderModel];
    }

    [self.recordTable reloadData];
}

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
    return self.orderArr.count ? self.orderArr.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderArr.count) {
        THNLifeOrderModel *model = self.orderArr[section];
        
        return model.items.count + 3;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderArr.count) {
        THNLifeOrderModel *model = self.orderArr[indexPath.section];
    
        if (indexPath.row == 0) {
            return 64.0;
            
        } else if (indexPath.row == (model.items.count + 3) - 2) {
            return 60.0;
            
        } else if (indexPath.row == (model.items.count + 3) - 1) {
            return model.life_order_status == 1 ? 0.01 : 49.0;
            
        } else {
            return 75.0;
        }
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 56.0 : 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? self.segmentView : [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderArr.count) {
        THNLifeOrderModel *model = self.orderArr[indexPath.section];
        
        if (indexPath.row == 0) {
            THNLifeOrderStoreTableViewCell *storeCell = [tableView dequeueReusableCellWithIdentifier:kOrderStoreTableViewCellId];
            if (!storeCell) {
                storeCell = [[THNLifeOrderStoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                                  reuseIdentifier:kOrderStoreTableViewCellId];
            }
            [storeCell thn_setLifeOrderData:self.orderArr[indexPath.section]];
            
            return storeCell;
            
        } else if (indexPath.row == (model.items.count + 3) - 2) {
            THNLifeOrderInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoTableViewCellID];
            if (!infoCell) {
                infoCell = [[THNLifeOrderInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                                reuseIdentifier:kOrderInfoTableViewCellID];
            }
            [infoCell thn_setLifeOrderInfoData:self.orderArr[indexPath.section]];
            
            return infoCell;
            
        } else if (indexPath.row == (model.items.count + 3) - 1) {
            THNLifeOrderActionTableViewCell *actionCell = [tableView dequeueReusableCellWithIdentifier:kOrderActionTableViewCellId];
            if (!actionCell) {
                actionCell = [[THNLifeOrderActionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                                    reuseIdentifier:kOrderActionTableViewCellId];
            }
            [actionCell thn_setLifeOrderExpressStatus:model.life_order_status];
            
            return actionCell;
            
        } else {
            THNLifeOrderProductTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:kOrderProductTableViewCellId];
            if (!goodsCell) {
                goodsCell = [[THNLifeOrderProductTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                                    reuseIdentifier:kOrderProductTableViewCellId];
            }
            [goodsCell thn_setLifeOrderProductData:model.items[indexPath.row - 1]];
            
            return goodsCell;
        }
    }
    
    return [UITableViewCell new];
}

#pragma mark - getters and setters
- (UITableView *)recordTable {
    if (!_recordTable) {
        _recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _recordTable.delegate = self;
        _recordTable.dataSource = self;
        _recordTable.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _recordTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _recordTable.showsVerticalScrollIndicator = NO;
        _recordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
                                                          titles:@[@"全部", @"待发货", @"已发货", @"已完成"]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (NSMutableArray *)orderArr {
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

@end
