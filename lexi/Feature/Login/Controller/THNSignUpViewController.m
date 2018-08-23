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
static NSString *const kResultData          = @"data";
static NSString *const kResultVerifyCode    = @"phone_verify_code";
/// app 注册验证api
static NSString *const kURLAppRegister      = @"/auth/app_register";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamAreaCode1      = @"areacode";
static NSString *const kParamVerifyCode     = @"verify_code";

@interface THNSignUpViewController () <THNSignUpViewDelegate>

@property (nonatomic, strong) THNSignUpView *signUpView;
@property (nonatomic, strong) THNZipCodeViewController *zipCodeVC;

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
    THNRequest *request = [THNAPI postWithUrlString:kURLVerifyCode requestDictionary:param delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSLog(@"注册验证码 ==== %@", result.responseDict);
        
        if (![result hasData] || ![result isSuccess]) {
            [SVProgressHUD showErrorWithStatus:@"数据错误"];
            return ;
        }
        
        [self.signUpView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 app 注册验证
 */
- (void)networkPostAppRegisterWithParam:(NSDictionary *)param completion:(void (^)(NSString *areaCode, NSString *email))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLAppRegister requestDictionary:param delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [self.signUpView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        if (![result hasData]) return;
        
        if (completion) {
            completion(result.data[kParamAreaCode1], result.data[kParamEmail]);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_signUpSetPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamAreaCode1: zipCode,
                                kParamEmail: phoneNum,
                                kParamVerifyCode: code};
    
    [self networkPostAppRegisterWithParam:paramDict completion:^(NSString *areaCode, NSString *email) {
        THNSetPasswordViewController *setPasswordVC = [[THNSetPasswordViewController alloc] init];
        setPasswordVC.areacode = areaCode;
        setPasswordVC.email = email;
        [self.navigationController pushViewController:setPasswordVC animated:YES];
    }];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    [self presentViewController:self.zipCodeVC animated:YES completion:nil];
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

- (void)setNavigationBar {
    WEAKSELF;
    [self.navigationBarView setNavigationRightButtonOfText:@"跳过" textHexColor:@"#666666"];
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - getters and setters
- (THNSignUpView *)signUpView {
    if (!_signUpView) {
        _signUpView = [[THNSignUpView alloc] init];
        _signUpView.delegate = self;
    }
    return _signUpView;
}

- (THNZipCodeViewController *)zipCodeVC {
    if (!_zipCodeVC) {
        _zipCodeVC = [[THNZipCodeViewController alloc] init];
        
        WEAKSELF;
        _zipCodeVC.SelectAreaCode = ^(NSString *code) {
            [weakSelf.signUpView thn_setAreaCode:code];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _zipCodeVC;
}

#pragma mark - dealloc
- (BOOL)willDealloc {
    [self.signUpView removeFromSuperview];
    
    return YES;
}

@end
