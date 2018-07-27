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
/// 动态登录的 key
static NSString *const kParamAreaCode       = @"areacode";
/// 发送验证码 key
static NSString *const kParamAreaCode1      = @"area_code";
static NSString *const kParamMobile         = @"mobile";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamPassword       = @"password";
static NSString *const kParamVerifyCode     = @"verify_code";


@interface THNSignInViewController () <THNSignInViewDelegate>

@property (nonatomic, strong) THNSignInView *signInView;

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
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSDictionary *resultData = NULL_TO_NIL(result[kResultData]);
        
        if (!resultData) {
            [SVProgressHUD showErrorWithStatus:@"数据错误"];
            return ;
        }
        NSLog(@"短信验证码 ==== %@", result);
        [self.signInView thn_setVerifyCode:resultData[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 登录成功后的操作
 */
- (void)thn_loginSuccess {
    if ([THNLoginManager sharedManager].isFirstLogin) {
        THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
        [self.navigationController pushViewController:newUserInfoVC animated:YES];
    
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - custom delegate
- (void)thn_signInWithPhoneNum:(NSString *)phoneNum areaCode:(NSString *)areaCode extraParam:(NSString *)extraParam loginModeType:(THNLoginModeType)modeType {
    
    NSDictionary *paramDict = [NSDictionary dictionary];
    
    if (modeType == THNLoginModeTypeVeriDynamic) {
        paramDict = @{kParamEmail: phoneNum, kParamAreaCode: areaCode, kParamVerifyCode: extraParam};
        
    } else if (modeType == THNLoginModeTypePassword) {
        paramDict = @{kParamEmail: phoneNum, kParamPassword: extraParam};
    }
    
    WEAKSELF;
    [THNLoginManager userLoginWithParams:paramDict
                                modeType:modeType
                              completion:^(id result, NSError *error) {
                                  if (error) {
                                      [weakSelf.signInView thn_setErrorHintText:[error localizedDescription]];
                                      return ;
                                  }
                                  
                                  if ([result[@"success"] isEqualToNumber:@0]) {
                                      [weakSelf.signInView thn_setErrorHintText:result[@"status"][@"message"]];
                                      return;
                                  }
                                  
                                  [self thn_loginSuccess];
                              }];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode1: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    WEAKSELF;
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    __weak THNZipCodeViewController *weakZipCodeVC = zipCodeVC;
    
    weakZipCodeVC.SelectAreaCode = ^(NSString *code) {
        [weakSelf.signInView thn_setAreaCode:code];
        [weakZipCodeVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:zipCodeVC animated:YES completion:nil];
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

#pragma mark - getters and setters
- (THNSignInView *)signInView {
    if (!_signInView) {
        _signInView = [[THNSignInView alloc] init];
        _signInView.delegate = self;
    }
    return _signInView;
}

@end
