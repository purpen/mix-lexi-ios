//
//  THNSignInViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignInViewController.h"
#import "THNSignUpViewController.h"
#import "THNSignInView.h"
#import "THNSignUpViewController.h"
#import "THNFindPasswordViewController.h"
#import "THNZipCodeViewController.h"
#import "THNLoginManager.h"
#import "THNNewUserInfoViewController.h"

/// 发送登录验证码 api
static NSString *const kURLVerifyCode       = @"/users/dynamic_login_verify_code";
/// 获取请求结果参数
static NSString *const kResultData          = @"data";
static NSString *const kResultVerifyCode    = @"phone_verify_code";
/// 发送验证码 key
static NSString *const kParamAreaCode1      = @"area_code";
static NSString *const kParamMobile         = @"mobile";

@interface THNSignInViewController () <THNSignInViewDelegate>

@property (nonatomic, strong) THNSignInView *signInView;
@property (nonatomic, strong) THNZipCodeViewController *zipCodeVC;

@end

@implementation THNSignInViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
/**
 获取短信验证码
 */
- (void)networkGetVerifyCodeWithParam:(NSDictionary *)param {
    THNRequest *request = [THNAPI postWithUrlString:kURLVerifyCode
                                  requestDictionary:param
                                             isSign:NO
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || ![result isSuccess]) {
            [SVProgressHUD showErrorWithStatus:@"数据错误"];
            return ;
        }
        
        NSLog(@"短信验证码 ==== %@", result.data);
        [self.signInView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 登录成功后的操作
 */
- (void)thn_loginSuccess {
    WEAKSELF;
    if ([THNLoginManager sharedManager].isFirstLogin) {
        THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController:newUserInfoVC animated:YES];
    
    } else {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - custom delegate
- (void)thn_signInWithParam:(NSDictionary *)param loginModeType:(THNLoginModeType)type {
    WEAKSELF;
    [THNLoginManager userLoginWithParams:param modeType:type completion:^(THNResponse *result, NSError *error) {
        if (error) {
            [weakSelf.signInView thn_setErrorHintText:[error localizedDescription]];
            return ;
        }
        
        if (![result isSuccess]) {
            [weakSelf.signInView thn_setErrorHintText:result.statusMessage];
            return;
        }
        NSLog(@"登录成功 ===== %@", result.data);
        [weakSelf thn_loginSuccess];
    }];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode1: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    [self presentViewController:self.zipCodeVC animated:YES completion:nil];
}

- (void)thn_forgetPassword {
    THNFindPasswordViewController *findPasswordVC = [[THNFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

- (void)thn_goToRegister {
    THNSignUpViewController *signUpVC = [[THNSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.signInView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    WEAKSELF;
    [self.navigationBarView setNavigationRightButtonOfText:@"跳过" textHexColor:@"#666666"];
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - getters and setters
- (THNSignInView *)signInView {
    if (!_signInView) {
        _signInView = [[THNSignInView alloc] init];
        _signInView.delegate = self;
    }
    return _signInView;
}

- (THNZipCodeViewController *)zipCodeVC {
    if (!_zipCodeVC) {
        _zipCodeVC = [[THNZipCodeViewController alloc] init];
        
        WEAKSELF;
        
        _zipCodeVC.SelectAreaCode = ^(NSString *code) {
            [weakSelf.signInView thn_setAreaCode:code];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _zipCodeVC;
}

@end
