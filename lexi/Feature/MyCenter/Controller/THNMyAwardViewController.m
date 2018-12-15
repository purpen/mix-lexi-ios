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
#import "THNAlertView.h"
#import "UIScrollView+THNMJRefresh.h"
#import "THNCashViewController.h"
#import "THNCashRecordViewController.h"

static NSInteger const maxCashCount     = 3;
static NSString *const kTitleAward      = @"我的奖励";
static NSString *const kTextRecord      = @"提现记录";
static NSString *const kTextHint        = @"你今日提现已达三次\n明日再来吧!";
/// api
static NSString *const kURLReward       = @"/invite_life_reward";
static NSString *const kURLUserReward   = @"/invite_life/rewards";
static NSString *const kURLCashCount    = @"/cash_money/count";
/// key
static NSString *const kKeyCashCount    = @"cash_count";
///
static NSString *const kAwardTableViewCellId = @"THNInvitationAwardTableViewCellId";

@interface THNMyAwardViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNCashAwardViewDelegate,
    THNMJRefreshDelegate
>

@property (nonatomic, strong) UITableView *userTableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) THNCashAwardView *cashView;
@property (nonatomic, assign) NSInteger cashCount;

@end

@implementation THNMyAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [SVProgressHUD thn_show];
    [self requestInviteLifeReward];
    [self requestInviteFriendsDataWithPage:1];
    [self requestTodayCashMoneyCount];
}

#pragma mark - custom delegate
- (void)beginRefreshing {
    [self.modelArr removeAllObjects];
    [self.userTableView resetCurrentPageNumber];
    [self.userTableView resetNoMoreData];
    [self requestInviteFriendsDataWithPage:1];
}

- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    [self requestInviteFriendsDataWithPage:currentPage.integerValue];
}

#pragma mark - network
- (void)requestInviteLifeReward {
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLReward requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        THNInviteAmountModel *model = [[THNInviteAmountModel alloc] initWithDictionary:result.data];
        [weakSelf.cashView thn_setLifeInviteAmountModel:model];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestInviteFriendsDataWithPage:(NSInteger)page {
    NSDictionary *params = @{@"page"    : @(page),
                             @"per_page": @(10)};
    
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLUserReward requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.userTableView endHeaderRefresh];
        
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            [weakSelf.userTableView endFooterRefreshAndCurrentPageChange:NO];
            return ;
        }
        
        [weakSelf.userTableView endFooterRefreshAndCurrentPageChange:YES];
        THNInviteRewardsModel *model = [[THNInviteRewardsModel alloc] initWithDictionary:result.data];
        if (model.rewards.count) {
            [weakSelf.modelArr addObjectsFromArray:model.rewards];
            
        } else {
            [weakSelf.userTableView noMoreData];
        }
        
        [weakSelf.userTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        [weakSelf.userTableView endHeaderRefreshAndCurrentPageChange:NO];
        [weakSelf.userTableView endFooterRefreshAndCurrentPageChange:NO];
    }];
}

- (void)requestTodayCashMoneyCount {
    THNRequest *request = [THNAPI getWithUrlString:kURLCashCount requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        if(![result.data[kKeyCashCount] isKindOfClass:[NSNull class]]){
            self.cashCount = [result.data[kKeyCashCount] integerValue];
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_showCashHintText {
    THNLifeActionViewController *actionVC = [[THNLifeActionViewController alloc] initWithType:(THNLifeActionTypeInvite)];
    actionVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)thn_cashAwardMoney {
    [self requestTodayCashMoneyCount];
    
    if (self.cashCount < maxCashCount) {
        [self thn_openCashMoneyController];
        
    } else {
        [self thn_overCashCountAlert];
    }
}

#pragma mark - private methods
- (void)thn_openCashMoneyController {
    THNCashViewController *cashVC = [[THNCashViewController alloc] init];
    [self.navigationController pushViewController:cashVC animated:YES];
}

- (void)thn_openCashRecordController {
    THNCashRecordViewController *recordVC = [[THNCashRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)thn_overCashCountAlert {
    THNAlertView *alertView = [THNAlertView initAlertViewTitle:kTextHint message:@""];
    alertView.mainActionColor = [UIColor whiteColor];
    alertView.mainTitleColor = [UIColor colorWithHexString:kColorMain];
    [alertView addActionButtonWithTitle:@"确定" handler:^(UIButton *actionButton, NSInteger index) {
        
    }];
    
    [alertView show];
}

#pragma mark - setup UI
- (void)setupUI {
    self.userTableView.tableHeaderView = self.cashView;
    [self.view addSubview:self.userTableView];
    
    [self.userTableView setRefreshHeaderWithClass:nil beginRefresh:NO animation:NO delegate:self];
    [self.userTableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.userTableView resetCurrentPageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleAward;
    self.navigationBarView.bottomLine = YES;
    [self.navigationBarView setNavigationRightButtonOfText:kTextRecord];
    
    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf thn_openCashRecordController];
    }];
}

#pragma mark - dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
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
        [cell thn_setInviteRewardUserModel:self.modelArr[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
