//
//  THNSignUpViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignUpViewController.h"
#import "THNSignUpView.h"
#import "THNSetPasswordViewController.h"
#import "THNSignInViewController.h"
#import "THNZipCodeViewController.h"

/// 发送注册验证码 api
static NSString *const kURLVerifyCode       = @"/users/register_verify_code";
static NSString *const kParamMobile         = @"mobile";
static NSString *const kParamAreaCode       = @"area_code";
static NSString *const kResultVerifyCode    = @"phone_verify_code";
/// app 注册验证api
static NSString *const kURLAppRegister      = @"/auth/app_register";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamAreaCode1      = @"areacode";
static NSString *const kParamVerifyCode     = @"verify_code";

@interface THNSignUpViewController () <THNSignUpViewDelegate>

@property (nonatomic, strong) THNSignUpView *signUpView;

@end

@implementation THNSignUpViewController

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
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        if ([result[@"data"] isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:@"数据错误"];
            return ;
        }
        NSLog(@"验证码 ==== %@", result);
        NSString *verifyCode = result[@"data"][kResultVerifyCode];
        [self.signUpView thn_setVerifyCode:verifyCode];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 app 注册验证
 */
- (void)networkPostAppRegisterWithParam:(NSDictionary *)param {
    THNRequest *request = [THNAPI postWithUrlString:kURLAppRegister
                                  requestDictionary:param
                                             isSign:NO
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        if ([result[@"data"] isKindOfClass:[NSNull class]]) {
            return ;
        }
        NSLog(@"注册验证 ==== %@", result);
        THNSetPasswordViewController *setPasswordVC = [[THNSetPasswordViewController alloc] init];
        setPasswordVC.areacode = result[@"data"][kParamAreaCode1];
        setPasswordVC.email = result[@"data"][kParamEmail];
        [self.navigationController pushViewController:setPasswordVC animated:YES];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_signUpSetPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamAreaCode1: zipCode,
                                kParamEmail: phoneNum,
                                kParamVerifyCode: code};
    
    [self networkPostAppRegisterWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    WEAKSELF;
    
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    __weak THNZipCodeViewController *weakZipCodeVC = zipCodeVC;
    
    weakZipCodeVC.SelectAreaCode = ^(NSString *code) {
        [weakSelf.signUpView thn_setAreaCode:code];
        [weakZipCodeVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_directLogin {
    THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
    [self.navigationController pushViewController:signInVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.signUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    WEAKSELF;
    
    [self.navigationBarView setNavigationRightButtonOfText:@"跳过" textHexColor:@"#666666"];
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.signUpView endEditing:YES];
}

#pragma mark - getters and setters
- (THNSignUpView *)signUpView {
    if (!_signUpView) {
        _signUpView = [[THNSignUpView alloc] init];
        _signUpView.delegate = self;
    }
    return _signUpView;
}

@end
