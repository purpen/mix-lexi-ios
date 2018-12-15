//
//  THNCashViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashViewController.h"
#import "THNCashRecordViewController.h"
#import "THNCashAlipayViewController.h"
#import "THNBindPhoneViewController.h"
#import "THNCashView.h"
#import "THNAlertView.h"
#import "THNLoginManager.h"
#import "THNUserModel.h"

static NSString *const kTitleCash    = @"提现";
static NSString *const kTextRecord   = @"提现记录";
static NSString *const kTextWechat   = @"即将提现到你的微信账号";
/// api
static NSString *const kURLCashMoney = @"/win_cash/cash_money";

@interface THNCashViewController () <THNCashViewDelegate>

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) THNCashView *cashView;
@property (nonatomic, strong) THNUserDataModel *userModel;
@property (nonatomic, assign) CGFloat cashAmount;

@end

@implementation THNCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)requestCashMoneyData {
    if (!self.userModel.openid) return;
    
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLCashMoney requestDictionary:[self thn_getRequestParams] delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"微信提现 === %@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        [SVProgressHUD thn_showSuccessWithStatus:@"提现成功"];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_didSelectedDoneCashWithAmount:(CGFloat)amount mode:(NSInteger)mode {
    self.cashAmount = amount;
    
    if (amount > self.cashView.cashAmount) {
        [SVProgressHUD thn_showInfoWithStatus:@"可提现金额不足"];
        return;
    }
    
    if (mode == 0) {
        [self thn_showWechatCashAlertView];
        
    } else {
        [self thn_openCashAlipayControllerWithAmount:amount];
    }
}

#pragma mark - private methods
- (void)thn_openCashRecordController {
    THNCashRecordViewController *recordVC = [[THNCashRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)thn_openCashAlipayControllerWithAmount:(CGFloat)amount {
    THNCashAlipayViewController *alipayVC = [[THNCashAlipayViewController alloc] init];
    alipayVC.cashAmount = amount;
    [self.navigationController pushViewController:alipayVC animated:YES];
}

- (void)thn_openBindPhoneControllerWithWechatOpenId:(NSString *)openId {
    THNBindPhoneViewController *bindVC = [[THNBindPhoneViewController alloc] init];
    bindVC.wechatOpenId = openId;
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)thn_userBindWechat {
    WEAKSELF;
    [THNLoginManager useWechatBindCompletion:^(BOOL isBind, NSString *openId, NSError *error) {
        if (!isBind) {
            [weakSelf thn_openBindPhoneControllerWithWechatOpenId:openId];
            
        } else {
            [SVProgressHUD thn_showSuccessWithStatus:@"已绑定"];
        }
    }];
}

- (void)thn_showWechatCashAlertView {
    if (![self thn_getUserInfoModel]) return;
    
    if ([self thn_getUserInfoModel].is_bind_wx) {
        THNAlertView *alertView = [THNAlertView initAlertViewWechatHeadImage:[self thn_getUserInfoModel].avatar
                                                                    nickname:@"Fynn"
                                                                       title:kTextWechat];
        alertView.canClickBackgroundDismiss = YES;
        [alertView addActionButtonWithTitle:@"确定" handler:^(UIButton *actionButton, NSInteger index) {
            [self requestCashMoneyData];
        }];
        
        [alertView show];
    
    } else {
        [self thn_userBindWechat];
    }
}

- (THNUserDataModel *)thn_getUserInfoModel {
    if ([THNLoginManager isLogin]) {
        self.userModel = [THNUserDataModel mj_objectWithKeyValues:[THNLoginManager sharedManager].userData];
        
        return self.userModel;
    }
    
    return nil;
}

- (NSDictionary *)thn_getRequestParams {
    NSDictionary *param = @{@"cash_type": @(1),
                            @"open_id"  : self.userModel.openid,
                            @"amount"   : @(self.cashAmount)};
    
    return param;
}

#pragma mark - setup UI
- (void)setupUI {
    self.cashView.cashAmount = 99999;
    
    [self.containerView addSubview:self.cashView];
    [self.view addSubview:self.containerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCash;
    self.navigationBarView.bottomLine = YES;
    [self.navigationBarView setNavigationRightButtonOfText:kTextRecord];
    
    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf thn_openCashRecordController];
    }];
}

#pragma mark - getters and setters
- (UIScrollView *)containerView {
    if (!_containerView) {
        CGFloat originY = kDeviceiPhoneX ? 88 : 64;
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY)];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _containerView.contentSize = CGSizeMake(SCREEN_WIDTH, 650);
        _containerView.showsVerticalScrollIndicator = NO;
    }
    return _containerView;
}

- (THNCashView *)cashView {
    if (!_cashView) {
        _cashView = [[THNCashView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 650)];
        _cashView.delegate = self;
    }
    return _cashView;
}

@end
