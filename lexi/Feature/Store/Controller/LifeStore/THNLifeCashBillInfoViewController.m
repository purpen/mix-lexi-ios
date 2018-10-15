//
//  THNLifeCashBillInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillInfoViewController.h"
#import "THNLifeCashBillInfoView.h"
#import "THNLifeCashBillSectionHeaderView.h"
#import "THNLifeCashBillInfoTableViewCell.h"
#import "THNLifeCashBillDetailViewController.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"
#import "THNLifeCashBillOrderModel.h"

/// text
static NSString *const kTextCashBillInfo = @"账单详情";
/// cell id
static NSString *const kCashBillInfoTableViewCellId = @"THNLifeCashBillInfoTableViewCellId";

@interface THNLifeCashBillInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *billTable;
@property (nonatomic, strong) THNLifeCashBillInfoView *billInfoView;
// 日期
@property (nonatomic, strong) NSArray *allKey;
// 数据
@property (nonatomic, strong) NSMutableArray *allValue;

@end

@implementation THNLifeCashBillInfoViewController

- (instancetype)initWithCashBillId:(NSString *)billId {
    self = [super init];
    if (self) {
        [self thn_getCashBillInfoDataWithId:billId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)thn_getCashBillInfoDataWithId:(NSString *)billId {
    if (!billId.length) return;
    [SVProgressHUD showInfoWithStatus:@""];
    WEAKSELF;
    
    [THNLifeManager getLifeCashBillDetailWithRid:[THNLoginManager sharedManager].storeRid
                                        recordId:billId
                                      completion:^(THNLifeCashBillModel *model, NSError *error) {
                                          [SVProgressHUD dismiss];
                                          if (error) return;
                                          
                                          [weakSelf.billInfoView thn_setLifeCashBillDetailData:model];
                                          weakSelf.allKey = [model.order_info allKeys];
                                          [weakSelf thn_recombinationOfOrderData:model.order_info];
                                      }];
}

#pragma mark - private methods
- (void)thn_openCashBillDetailControllerWithRid:(NSString *)rid model:(THNLifeCashBillOrderModel *)model {
    THNLifeCashBillDetailViewController *billDetailVC = [[THNLifeCashBillDetailViewController alloc] initWithRid:rid
                                                                                                     detailModel:model];
    billDetailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:billDetailVC animated:NO completion:nil];
}

// 重新组合订单数据
- (void)thn_recombinationOfOrderData:(NSDictionary *)data {
    for (NSString *key in [data allKeys]) {
        NSDictionary *dict = data[key];
        NSMutableArray *dataArr = [NSMutableArray array];
        
        for (NSUInteger idx = 0; idx < [dict allValues].count; idx ++) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[dict allValues][idx]];
            NSString *orderId = [dict allKeys][idx];
            [dataDict setObject:orderId forKey:@"order_id"];
            
            THNLifeCashBillOrderModel *model = [THNLifeCashBillOrderModel mj_objectWithKeyValues:dataDict];
            [dataArr addObject:model];
        }
        
        [self.allValue addObject:dataArr];
    }

    [self.billTable reloadData];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    self.billTable.tableHeaderView = self.billInfoView;
    [self.view addSubview:self.billTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextCashBillInfo;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allKey.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.allValue[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNLifeCashBillSectionHeaderView *headerView = [[THNLifeCashBillSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [headerView thn_setTitleText:self.allKey[section] subTitleText:@""];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeCashBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCashBillInfoTableViewCellId];
    if (!cell) {
        cell = [[THNLifeCashBillInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kCashBillInfoTableViewCellId];
    }
    
    if (self.allValue.count) {
        [cell thn_setLifeCashBillOrderData:self.allValue[indexPath.section][indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allValue.count) {
        THNLifeCashBillOrderModel *model = self.allValue[indexPath.section][indexPath.row];
        [self thn_openCashBillDetailControllerWithRid:model.order_id model:model];
    }
}

#pragma mark - getters and setters
- (UITableView *)billTable {
    if (!_billTable) {
        _billTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _billTable.delegate = self;
        _billTable.dataSource = self;
        _billTable.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _billTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _billTable.showsVerticalScrollIndicator = NO;
        _billTable.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _billTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _billTable.tableFooterView = [UIView new];
    }
    return _billTable;
}

- (THNLifeCashBillInfoView *)billInfoView {
    if (!_billInfoView) {
        _billInfoView = [[THNLifeCashBillInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    }
    return _billInfoView;
}

- (NSMutableArray *)allValue {
    if (!_allValue) {
        _allValue = [NSMutableArray array];
    }
    return _allValue;
}

@end
