//
//  THNLifeManagementViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/25.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeManagementViewController.h"
#import "THNLifeManagementUserView.h"
#import "THNLifeCountdownView.h"
#import "THNEarningsView.h"
#import "THNLifeDataView.h"
#import "THNLifeHintView.h"
#import "THNLifeManagementTextTableViewCell.h"
#import "THNLifeManager.h"
#import "thnLoginManager.h"
#import "THNLifeTransactionRecordsViewController.h"
#import "THNLifeOrderRecordViewController.h"
#import "THNLifeCashViewController.h"
#import "THNLifeActionViewController.h"

static NSString *const kTextTableViewCellId = @"THNLifeManagementTextTableViewCellId";
///
static NSString *const kTextFriends = @"邀请好友开馆赚钱";
static NSString *const kTextWechat  = @"加入馆主群，获取赚钱攻略";
static NSString *const kTextPhone   = @"客服电话 400-2345-0000";

@interface THNLifeManagementViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNLifeHintViewDelegate,
    THNLifeDataViewDelegate,
    THNEarningsViewDelegate
>

// 用户信息视图
@property (nonatomic, strong) THNLifeManagementUserView *userView;
// 倒计时
@property (nonatomic, strong) THNLifeCountdownView *countdownView;
// 收益视图
@property (nonatomic, strong) THNEarningsView *earningsView;
// 数据视图
@property (nonatomic, strong) THNLifeDataView *dataView;
// 提示视图
@property (nonatomic, strong) THNLifeHintView *hintView;
// 客服电话
@property (nonatomic, strong) UIButton *phoneButton;
// 头部视图
@property (nonatomic, strong) UIView *headerView;
// 尾部视图
@property (nonatomic, strong) UIView *footerView;
// 内容视图
@property (nonatomic, strong) UITableView *lifeInfoTable;

@end

@implementation THNLifeManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![THNLoginManager sharedManager].storeRid) {
        [SVProgressHUD showInfoWithStatus:@"生活馆不存在"];
        return;
    }
    
    [self thn_setLifeStoreUserData];
    [self thn_getLifeTransactionData];
    [self thn_getLifeOrdersCollectData];
    [self thn_getLifeCashCollectData];
}

#pragma mark - custom delegate
- (void)thn_checkLifeTransactionRecord {
    THNLifeTransactionRecordsViewController *transactionVC = [[THNLifeTransactionRecordsViewController alloc] init];
    [self.navigationController pushViewController:transactionVC animated:YES];
}

- (void)thn_checkLifeOrderRecord {
    THNLifeOrderRecordViewController *orderVC = [[THNLifeOrderRecordViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)thn_checkLifeCashMoney {
    THNLifeCashViewController *cashVC = [[THNLifeCashViewController alloc] init];
    [self.navigationController pushViewController:cashVC animated:YES];
}

- (void)thn_checkWechatInfo {
    THNLifeActionViewController *actionVC = [[THNLifeActionViewController alloc] initWithType:(THNLifeActionTypeImage)];
    actionVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)thn_showCashHintText {
    THNLifeActionViewController *actionVC = [[THNLifeActionViewController alloc] initWithType:(THNLifeActionTypeText)];
    actionVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:actionVC animated:NO completion:nil];
}

#pragma mark - network
- (void)thn_setLifeStoreUserData {
    [SVProgressHUD showInfoWithStatus:@""];
    WEAKSELF;
    
    [THNLifeManager getLifeStoreInfoWithRid:[THNLoginManager sharedManager].storeRid
                                 completion:^(THNLifeStoreModel *model, NSError *error) {
                                     [SVProgressHUD dismiss];
                                     if (error) return;
                                     
                                     [weakSelf.userView thn_setLifeStoreInfo:model];
                                     [weakSelf.countdownView thn_setLifeStoreCreatedAt:model.created_at];
                                     [weakSelf thn_showCountdownPhases:model.phases];
                                     
                                     [weakSelf setupUI];
                                 }];
}

- (void)thn_getLifeTransactionData {
    [SVProgressHUD showInfoWithStatus:@""];
    WEAKSELF;
    
    [THNLifeManager getLifeOrdersSaleCollectWithRid:[THNLoginManager sharedManager].storeRid
                                         completion:^(THNLifeSaleCollectModel *model, NSError *error) {
                                             [SVProgressHUD dismiss];
                                             if (error) return;
                                             
                                             [weakSelf.earningsView thn_setLifeSaleColleciton:model];
                                         }];
}

- (void)thn_getLifeOrdersCollectData {
    [SVProgressHUD showInfoWithStatus:@""];
    WEAKSELF;
    
    [THNLifeManager getLifeOrdersCollectWithRid:[THNLoginManager sharedManager].storeRid
                                     completion:^(THNLifeOrdersCollectModel *model, NSError *error) {
                                         [SVProgressHUD dismiss];
                                         if (error) return;
                                         
                                         [weakSelf.dataView thn_setLifeOrdersCollecitonModel:model];
                                     }];
}

- (void)thn_getLifeCashCollectData {
    [SVProgressHUD showInfoWithStatus:@""];
    WEAKSELF;
    
    [THNLifeManager getLifeCashCollectWithRid:[THNLoginManager sharedManager].storeRid
                                   completion:^(THNLifeCashCollectModel *model, NSError *error) {
                                       [SVProgressHUD dismiss];
                                       if (error) return;
                                       
                                       [weakSelf.dataView thn_setLifeCashCollectModel:model];
                                   }];
}

#pragma mark - private methods
// 是否显示倒计时
- (void)thn_showCountdownPhases:(NSInteger)phases {
    self.countdownView.hidden = phases != 1;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeManagementTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextTableViewCellId];
    if (!cell) {
        cell = [[THNLifeManagementTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTextTableViewCellId];
    }
    
    cell.hintText = indexPath.row == 0 ? kTextFriends : kTextWechat;
    cell.iconImage = indexPath.row == 0 ? [UIImage imageNamed:@"icon_friends_main"] : [UIImage new];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [SVProgressHUD showInfoWithStatus:@"邀请好友"];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"加入馆主群"];
    }
}

#pragma mark - setup UI
- (void)setupUI {
    [self.headerView addSubview:self.userView];
    [self.headerView addSubview:self.countdownView];
    [self.headerView addSubview:self.earningsView];
    [self.headerView addSubview:self.dataView];
    [self.headerView addSubview:self.hintView];
    self.lifeInfoTable.tableHeaderView = self.headerView;
    [self.footerView addSubview:self.phoneButton];
    self.lifeInfoTable.tableFooterView = self.footerView;
    [self.view addSubview:self.lifeInfoTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (UITableView *)lifeInfoTable {
    if (!_lifeInfoTable) {
        _lifeInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame))
                                                      style:(UITableViewStylePlain)];
        _lifeInfoTable.delegate = self;
        _lifeInfoTable.dataSource = self;
        _lifeInfoTable.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _lifeInfoTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _lifeInfoTable.showsVerticalScrollIndicator = NO;
        _lifeInfoTable.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
    }
    return _lifeInfoTable;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 545)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _headerView;
}

- (THNLifeManagementUserView *)userView {
    if (!_userView) {
        _userView = [[THNLifeManagementUserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    return _userView;
}

- (THNLifeCountdownView *)countdownView {
    if (!_countdownView) {
        _countdownView = [[THNLifeCountdownView alloc] initWithFrame:CGRectMake(20, 85, SCREEN_WIDTH - 40, 40)];
        _countdownView.hidden = YES;
    }
    return _countdownView;
}

- (THNEarningsView *)earningsView {
    if (!_earningsView) {
        _earningsView = [[THNEarningsView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.userView.frame) - 20, SCREEN_WIDTH - 40, 140)];
        _earningsView.delegate = self;
    }
    return _earningsView;
}

- (THNLifeDataView *)dataView {
    if (!_dataView) {
        _dataView = [[THNLifeDataView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.earningsView.frame) + 20, SCREEN_WIDTH, 107)];
        _dataView.delegate = self;
    }
    return _dataView;
}

- (THNLifeHintView *)hintView {
    if (!_hintView) {
        _hintView = [[THNLifeHintView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dataView.frame), SCREEN_WIDTH, 153)];
        _hintView.delegate = self;
    }
    return _hintView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
        _footerView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    }
    return _footerView;
}

- (UIButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 44)];
        _phoneButton.backgroundColor = [UIColor whiteColor];
        _phoneButton.layer.cornerRadius = 4;
        _phoneButton.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.1].CGColor;
        _phoneButton.layer.shadowOffset = CGSizeMake(0, 0);
        _phoneButton.layer.shadowRadius = 8;
        _phoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_phoneButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateNormal)];
        [_phoneButton setTitle:kTextPhone forState:(UIControlStateNormal)];
    }
    return _phoneButton;
}

@end
