//
//  THNLifeTransactionRecordsViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeTransactionRecordsViewController.h"
#import "THNEarningsView.h"
#import "THNLifeOrderRecordTableViewCell.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

static NSString *const kRecordTableViewCellId = @"THNLifeOrderRecordTableViewCellId";
///
static NSString *const kTextRecords = @"交易记录";

@interface THNLifeTransactionRecordsViewController () <UITableViewDelegate, UITableViewDataSource>

// 收益视图
@property (nonatomic, strong) THNEarningsView *earningsView;
// 记录
@property (nonatomic, strong) UITableView *recordTable;
// 头部视图
@property (nonatomic, strong) UIView *headerView;

@end

@implementation THNLifeTransactionRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setLifeTransactionData];
    [self setupUI];
}

- (void)thn_setLifeTransactionData {
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

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.recordTable];
    [self.headerView addSubview:self.earningsView];
    
    self.recordTable.tableHeaderView = self.headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextRecords;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeOrderRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCellId];
    if (!cell) {
        cell = [[THNLifeOrderRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kRecordTableViewCellId];
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
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (THNEarningsView *)earningsView {
    if (!_earningsView) {
        _earningsView = [[THNEarningsView alloc] initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 40, 140)];
        _earningsView.layer.cornerRadius = 4;
        _earningsView.layer.masksToBounds = YES;
    }
    return _earningsView;
}

@end
