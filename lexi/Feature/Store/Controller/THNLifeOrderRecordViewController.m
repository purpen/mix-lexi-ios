//
//  THNLifeOrderRecordViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderRecordViewController.h"
#import "THNLifeOrderView.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

static NSString *const kTextOrder = @"成交订单";

@interface THNLifeOrderRecordViewController () <UITableViewDelegate, UITableViewDataSource>

// 订单数据
@property (nonatomic, strong) THNLifeOrderView *orderDataView;
// 记录
@property (nonatomic, strong) UITableView *recordTable;
// 头部视图
@property (nonatomic, strong) UIView *headerView;

@end

@implementation THNLifeOrderRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setLifeOrderRecordData];
    [self setupUI];
}

- (void)thn_setLifeOrderRecordData {
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

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.recordTable];
    [self.headerView addSubview:self.orderDataView];
    
    self.recordTable.tableHeaderView = self.headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextOrder;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 142)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (THNLifeOrderView *)orderDataView {
    if (!_orderDataView) {
        _orderDataView = [[THNLifeOrderView alloc] initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 40, 112)];
        _orderDataView.layer.cornerRadius = 4;
        _orderDataView.layer.masksToBounds = YES;
    }
    return _orderDataView;
}

@end
