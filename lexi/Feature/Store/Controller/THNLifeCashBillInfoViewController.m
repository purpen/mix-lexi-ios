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

/// text
static NSString *const kTextCashBillInfo = @"账单详情";
/// cell id
static NSString *const kCashBillInfoTableViewCellId = @"THNLifeCashBillInfoTableViewCellId";

@interface THNLifeCashBillInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *billTable;
@property (nonatomic, strong) THNLifeCashBillInfoView *billInfoView;

@end

@implementation THNLifeCashBillInfoViewController

- (instancetype)initWithCashBillId:(NSString *)billId {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - private methods
- (void)thn_openCashBillDetailController {
    THNLifeCashBillDetailViewController *billDetailVC = [[THNLifeCashBillDetailViewController alloc] init];
    billDetailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:billDetailVC animated:YES completion:nil];
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
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNLifeCashBillSectionHeaderView *headerView = [[THNLifeCashBillSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.showSubLabel = NO;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeCashBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCashBillInfoTableViewCellId];
    if (!cell) {
        cell = [[THNLifeCashBillInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kCashBillInfoTableViewCellId];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self thn_openCashBillDetailController];
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

@end
