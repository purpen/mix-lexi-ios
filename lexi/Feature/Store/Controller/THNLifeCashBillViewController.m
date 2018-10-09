//
//  THNLifeCashBillViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillViewController.h"
#import "THNLifeCashBillTableViewCell.h"
#import "THNLifeCashBillSectionHeaderView.h"
#import "THNLifeCashBillInfoViewController.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

/// cell id
static NSString *const kCashBillTableViewCellId = @"THNLifeCashBillTableViewCellId";
/// text
static NSString *const kTextCashBill = @"对账单";
/// key
static NSString *const kKeyPage     = @"page";

@interface THNLifeCashBillViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *billTable;
// 当前页码
@property (nonatomic, assign) NSInteger page;

@end

@implementation THNLifeCashBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self thn_getLifeCashBillData];
    [self setupUI];
}

- (void)thn_getLifeCashBillData {
    WEAKSELF;
    
    [THNLifeManager getLifeCashBillWithRid:[THNLoginManager sharedManager].storeRid
                                    params:@{kKeyPage: @(self.page)}
                                completion:^(NSError *error) {
                                    if (error) {
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                        return ;
                                    }
    
                                }];
}

#pragma mark - private methods
- (void)thn_openCashBillInfoWithId:(NSString *)billId {
    THNLifeCashBillInfoViewController *billInfoVC = [[THNLifeCashBillInfoViewController alloc] initWithCashBillId:billId];
    [self.navigationController pushViewController:billInfoVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.billTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextCashBill;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNLifeCashBillSectionHeaderView *headerView = [[THNLifeCashBillSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeCashBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCashBillTableViewCellId];
    if (!cell) {
        cell = [[THNLifeCashBillTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kCashBillTableViewCellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self thn_openCashBillInfoWithId:@"1"];
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

@end
