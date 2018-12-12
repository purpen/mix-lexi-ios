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
#import "THNWebKitViewViewController.h"

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
///
static NSString *const kTextSkip            = @"跳过";

@interface THNSignUpViewController () <THNSignUpViewDelegate>

@property (nonatomic, strong) THNSignUpView *signUpView;

@end

@implementation THNSignUpViewController

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
#ifdef DEBUG
        NSLog(@"注册-验证码：%@", result.responseDict);
#endif
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self.signUpView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 app 注册验证
 */
- (void)networkPostAppRegisterWithParam:(NSDictionary *)param completion:(void (^)(NSString *areaCode, NSString *email))completion {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLAppRegister requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [self.signUpView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        if (![result hasData]) return;
        
        [SVProgressHUD dismiss];
        if (completion) {
            completion(result.data[kParamAreaCode1], result.data[kParamEmail]);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_signUpSetPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamAreaCode1 : zipCode,
                                kParamEmail     : phoneNum,
                                kParamVerifyCode: code};
    
    [self networkPostAppRegisterWithParam:paramDict completion:^(NSString *areaCode, NSString *email) {
        [self thn_openSetPwdControllerWithAreaCode:areaCode email:email];
    }];
}

- (void)thn_signUpSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile  : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_signUpShowZipCodeList {
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    zipCodeVC.selectAreaCodeBlock = ^(NSString *code) {
        [self.signUpView thn_setAreaCode:code];
    };
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

- (void)thn_signUpDirectLogin {
    THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
    [self.navigationController pushViewController:signInVC animated:YES];
}

- (void)thn_signUpCheckProtocolUrl:(NSString *)url {
    THNWebKitViewViewController *webVC = [[THNWebKitViewViewController alloc] init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - private methods
- (void)thn_openSetPwdControllerWithAreaCode:(NSString *)areaCode email:(NSString *)email {
    THNSetPasswordViewController *setPasswordVC = [[THNSetPasswordViewController alloc] init];
    setPasswordVC.areacode = areaCode;
    setPasswordVC.email = email;
    [self.navigationController pushViewController:setPasswordVC animated:YES];
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
    if (self.canSkip) {
        WEAKSELF;
        [self.navigationBarView setNavigationRightButtonOfText:kTextSkip textHexColor:@"#666666"];
        [self.navigationBarView didNavigationRightButtonCompletion:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
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
