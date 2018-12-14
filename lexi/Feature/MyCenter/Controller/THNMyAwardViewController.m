//
//  THNMyAwardViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNMyAwardViewController.h"
#import "THNInvitationAwardTableViewCell.h"
#import "THNCashAwardView.h"
#import "THNLifeActionViewController.h"

static NSString *kTitleAward = @"我的奖励";
///
static NSString *const kAwardTableViewCellId = @"THNInvitationAwardTableViewCellId";

@interface THNMyAwardViewController () <UITableViewDelegate, UITableViewDataSource, THNCashAwardViewDelegate>

@property (nonatomic, strong) UITableView *userTableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) THNCashAwardView *cashView;

@end

@implementation THNMyAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_showCashHintText {
    THNLifeActionViewController *actionVC = [[THNLifeActionViewController alloc] initWithType:(THNLifeActionTypeInvite)];
    actionVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)thn_cashAwardMoney {
    [SVProgressHUD thn_showInfoWithStatus:@"提现"];
}

#pragma mark - setup UI
- (void)setupUI {
    self.userTableView.tableHeaderView = self.cashView;
    [self.view addSubview:self.userTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.title = kTitleAward;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.modelArr.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNInvitationAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAwardTableViewCellId];
    if (!cell) {
        cell = [[THNInvitationAwardTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kAwardTableViewCellId];
    }
    
    if (self.modelArr.count) {
        //        [cell thn_setUserListCellModel:self.modelArr[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    THNUserModel *model = [THNUserModel mj_objectWithKeyValues:self.modelArr[indexPath.row]];
    //
    //    if ([[THNLoginManager sharedManager].userId isEqualToString:model.uid]) {
    //        return;
    //    }
    //
    //    THNUserCenterViewController *userCenterVC = [[THNUserCenterViewController alloc] initWithUserId:model.uid];
    //    [self.navigationController pushViewController:userCenterVC animated:YES];
}

#pragma mark - getters and setters
- (UITableView *)userTableView {
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _userTableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.showsVerticalScrollIndicator = NO;
        _userTableView.backgroundColor = [UIColor whiteColor];
        _userTableView.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _userTableView.tableFooterView = [UIView new];
    }
    return _userTableView;
}

- (THNCashAwardView *)cashView {
    if (!_cashView) {
        _cashView = [[THNCashAwardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
        _cashView.delegate = self;
    }
    return _cashView;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
