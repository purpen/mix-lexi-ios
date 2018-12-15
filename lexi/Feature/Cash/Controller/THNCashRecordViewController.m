//
//  THNCashRecordViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashRecordViewController.h"
#import "THNLifeCashBillTableViewCell.h"
#import "THNLifeCashBillSectionHeaderView.h"
#import "THNCashInfoViewController.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"
#import "THNCashRecordDefaultView.h"
#import "UIScrollView+THNMJRefresh.h"
#import "THNCashRecordModel.h"

/// cell id
static NSString *const kCashBillTableViewCellId = @"THNLifeCashBillTableViewCellId";
/// text
static NSString *const kTextCashBill    = @"对账单";
static NSString *const kTitleRecord     = @"提现记录";
/// api
static NSString *const kURLCashRecord   = @"/win_cash/withdrawal_record";

@interface THNCashRecordViewController () <UITableViewDelegate, UITableViewDataSource, THNMJRefreshDelegate>

@property (nonatomic, strong) UITableView *billTable;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) THNCashRecordDefaultView *defaultView;

@end

@implementation THNCashRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [SVProgressHUD thn_show];
    [self thn_getLifeCashBillDataWithPage:1];
}

#pragma mark - custom delegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    [self thn_getLifeCashBillDataWithPage:currentPage.integerValue];
}

#pragma mark - network
- (void)thn_getLifeCashBillDataWithPage:(NSInteger)page {
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLCashRecord requestDictionary:@{@"page": @(page)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"提现记录 === %@", [NSString jsonStringWithObject:result.responseDict]);
        if (!result.isSuccess) {
            [weakSelf.billTable endFooterRefreshAndCurrentPageChange:NO];
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [weakSelf.billTable endFooterRefreshAndCurrentPageChange:YES];
        THNCashRecordModel *model = [[THNCashRecordModel alloc] initWithDictionary:result.data];
        
        if (model.recordList.count) {
            [weakSelf.modelArr addObjectsFromArray:model.recordList];
            
        } else {
            [weakSelf.billTable noMoreData];
        }
        
        [weakSelf.billTable reloadData];
        [weakSelf thn_setDefaultView];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
- (void)thn_openCashBillInfoWithId:(NSString *)billId {
    THNCashInfoViewController *billInfoVC = [[THNCashInfoViewController alloc] initWithCashBillId:billId];
    [self.navigationController pushViewController:billInfoVC animated:YES];
}

- (void)thn_setDefaultView {
    self.billTable.tableHeaderView = self.modelArr.count ? [UIView new] : self.defaultView;
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.billTable];
    [self.billTable setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.billTable resetCurrentPageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleRecord;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeCashBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCashBillTableViewCellId];
    if (!cell) {
        cell = [[THNLifeCashBillTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kCashBillTableViewCellId];
    }
    
    if (self.modelArr.count) {
        THNCashRecordModelRecordList *itemModel = self.modelArr[indexPath.row];
        [cell thn_setWinCashRecordData:[itemModel toDictionary]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelArr.count) {
        THNCashRecordModelRecordList *itemModel = self.modelArr[indexPath.row];
        [self thn_openCashBillInfoWithId:itemModel.rid];
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

- (THNCashRecordDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[THNCashRecordDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _defaultView;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
