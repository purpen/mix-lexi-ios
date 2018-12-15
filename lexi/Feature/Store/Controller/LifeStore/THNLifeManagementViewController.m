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
#import "THNShareViewController.h"
#import "THNAlertView.h"
#import "THNLifeInviteView.h"
#import "THNInvitationFriendViewController.h"
#import "THNMyAwardViewController.h"

#define kTextInTitle(obj) [NSString stringWithFormat:@"@%@邀请你一起来乐喜", obj]

static NSString *const kTextTableViewCellId = @"THNLifeManagementTextTableViewCellId";
static NSString *const kURLApplyStore       = @"https://h5.lexivip.com/shop/guide";
/// text
static NSString *const kTextFriends         = @"邀请好友开馆赚钱";
static NSString *const kTextInvitation      = @"开一个能赚钱的生活馆";
static NSString *const kTextWechat          = @"加入馆主群，获取赚钱攻略";
static NSString *const kTextPhone           = @"客服电话 400-2345-0000";
/// api
static NSString *const kURLCount            = @"/invite_life_count";
static NSString *const kURLReward           = @"/invite_life_reward";

@interface THNLifeManagementViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNLifeHintViewDelegate,
    THNLifeDataViewDelegate,
    THNEarningsViewDelegate,
    THNLifeInviteViewDelegate
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
// 邀请数据视图
@property (nonatomic, strong) THNLifeInviteView *inviteView;
// 加入关注群
@property (nonatomic, strong) UIButton *joinButton;
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
    
    [self setupUI];
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

- (void)thn_lifeInviteCheckFriend {
    THNInvitationFriendViewController *friendVC = [[THNInvitationFriendViewController alloc] init];
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)thn_lifeInviteCheckMoney {
    THNMyAwardViewController *awardVC = [[THNMyAwardViewController alloc] init];
    [self.navigationController pushViewController:awardVC animated:YES];
}

- (void)thn_lifeInviteMoneyHint {
    THNLifeActionViewController *actionVC = [[THNLifeActionViewController alloc] initWithType:(THNLifeActionTypeInvite)];
    actionVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)thn_lifeInviteApplyStore {
    [self thn_openShareImageController];
}

#pragma mark - network
- (void)thn_requestLifeStoreData {
    [self thn_setLifeStoreUserData];
    [self thn_getLifeTransactionData];
    [self thn_getLifeOrdersCollectData];
    [self thn_getLifeCashCollectData];
    [self requestInviteLifeCount];
    [self requestInviteLifeReward];
}

- (void)thn_setLifeStoreUserData {
    WEAKSELF;
    [THNLifeManager getLifeStoreInfoWithRid:[THNLoginManager sharedManager].storeRid
                                 completion:^(THNLifeStoreModel *model, NSError *error) {
                                     if (error) return;
                                     
                                     [weakSelf.userView thn_setLifeStoreInfo:model];
                                     [weakSelf.countdownView thn_setLifeStoreCreatedAt:model.created_at];
                                     [weakSelf thn_showCountdownPhases:model.phases];
                                 }];
}

- (void)thn_getLifeTransactionData {
    WEAKSELF;
    [THNLifeManager getLifeOrdersSaleCollectWithRid:[THNLoginManager sharedManager].storeRid
                                         completion:^(THNLifeSaleCollectModel *model, NSError *error) {
                                             if (error) return;
                                             
                                             [weakSelf.earningsView thn_setLifeSaleColleciton:model];
                                         }];
}

- (void)thn_getLifeOrdersCollectData {
    WEAKSELF;
    [THNLifeManager getLifeOrdersCollectWithRid:[THNLoginManager sharedManager].storeRid
                                     completion:^(THNLifeOrdersCollectModel *model, NSError *error) {
                                         if (error) return;
                                         
                                         [weakSelf.dataView thn_setLifeOrdersCollecitonModel:model];
                                     }];
}

- (void)thn_getLifeCashCollectData {
    WEAKSELF;
    [THNLifeManager getLifeCashCollectWithRid:[THNLoginManager sharedManager].storeRid
                                   completion:^(THNLifeCashCollectModel *model, NSError *error) {
                                       if (error) return;
                                       
                                       [weakSelf.dataView thn_setLifeCashCollectModel:model];
                                   }];
}

- (void)requestInviteLifeCount {
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLCount requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        THNInviteCountModel *model = [[THNInviteCountModel alloc] initWithDictionary:result.data];
        [weakSelf.inviteView thn_setLifeInviteCountModel:model];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestInviteLifeReward {
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLReward requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        THNInviteAmountModel *model = [[THNInviteAmountModel alloc] initWithDictionary:result.data];
        [weakSelf.inviteView thn_setLifeInviteAmountModel:model];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
// 是否显示倒计时
- (void)thn_showCountdownPhases:(NSInteger)phases {
    self.countdownView.hidden = phases != 1;
}

// 邀请好友开馆海报
- (void)thn_openShareImageController {
    NSString *lifeStoreId = [THNLoginManager sharedManager].storeRid;
    
    if (!lifeStoreId.length) return;
    
    THNUserDataModel *userModel = [THNUserDataModel mj_objectWithKeyValues:[THNLoginManager sharedManager].userData];
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeInvitation)
                                                                         requestId:lifeStoreId];
    [shareVC shareObjectWithTitle:kTextInTitle(userModel.username)
                            descr:kTextInvitation
                        thumImage:userModel.avatar
                           webUrl:kURLApplyStore];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

// 复制微信号
- (void)thn_copyWechat {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:@"lexixiaoduo"];
    
    THNAlertView *alertView = [THNAlertView initAlertViewTitle:@"" message:@"复制成功，去添加乐喜辅导员微信:\nlexixiaoduo"];
    [alertView addActionButtonWithTitle:@"确定" handler:nil];
    [alertView show];
}

#pragma mark - event response
- (void)joinButtonAction:(UIButton *)button {
    [self thn_copyWechat];
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    THNLifeManagementTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextTableViewCellId];
//    if (!cell) {
//        cell = [[THNLifeManagementTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTextTableViewCellId];
//    }
//
//    cell.hintText = indexPath.row == 0 ? kTextFriends : kTextWechat;
//    cell.iconImage = indexPath.row == 0 ? [UIImage imageNamed:@"icon_friends_main"] : [UIImage new];
//
//    return cell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextTableViewCellId];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTextTableViewCellId];
    
    return cell;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.headerView addSubview:self.userView];
    [self.headerView addSubview:self.countdownView];
    [self.headerView addSubview:self.earningsView];
    [self.headerView addSubview:self.dataView];
    [self.headerView addSubview:self.hintView];
    [self.footerView addSubview:self.inviteView];
    [self.footerView addSubview:self.joinButton];
    
    self.lifeInfoTable.tableHeaderView = self.headerView;
    self.lifeInfoTable.tableFooterView = self.footerView;
    [self.view addSubview:self.lifeInfoTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
    
    if (![THNLoginManager sharedManager].openingUser) return;
    
    [self thn_requestLifeStoreData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.lifeInfoTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame));
}

#pragma mark - getters and setters
- (UITableView *)lifeInfoTable {
    if (!_lifeInfoTable) {
        _lifeInfoTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _lifeInfoTable.delegate = self;
        _lifeInfoTable.dataSource = self;
        _lifeInfoTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _lifeInfoTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _lifeInfoTable.showsVerticalScrollIndicator = NO;
        _lifeInfoTable.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
    }
    return _lifeInfoTable;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 585)];
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
        _earningsView = [[THNEarningsView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.userView.frame) - 20, SCREEN_WIDTH - 40, 180)];
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

- (THNLifeInviteView *)inviteView {
    if (!_inviteView) {
        _inviteView = [[THNLifeInviteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
        _inviteView.delegate = self;
    }
    return _inviteView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    return _footerView;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 185, SCREEN_WIDTH - 40, 44)];
        _joinButton.backgroundColor = [UIColor whiteColor];
        _joinButton.layer.cornerRadius = 4;
        _joinButton.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
        _joinButton.layer.shadowOffset = CGSizeMake(0, 0);
        _joinButton.layer.shadowRadius = 4;
        _joinButton.layer.shadowOpacity = 0.2;
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateNormal)];
        [_joinButton setTitle:kTextWechat forState:(UIControlStateNormal)];
        [_joinButton addTarget:self action:@selector(joinButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _joinButton;
}

@end
