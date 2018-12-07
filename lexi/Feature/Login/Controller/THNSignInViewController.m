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
#import "THNAdvertManager.h"
#import "THNBindPhoneViewController.h"

/// 发送登录验证码 api
static NSString *const kURLVerifyCode       = @"/users/dynamic_login_verify_code";
/// 获取请求结果参数
static NSString *const kResultData          = @"data";
static NSString *const kResultVerifyCode    = @"phone_verify_code";
/// 发送验证码 key
static NSString *const kParamAreaCode1      = @"area_code";
static NSString *const kParamMobile         = @"mobile";
///
static NSString *const kTextSkip            = @"跳过";

@interface THNSignInViewController () <THNSignInViewDelegate>

@property (nonatomic, strong) THNSignInView *signInView;

@end

@implementation THNSignInViewController

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
        NSLog(@"登录-验证码：%@", result.responseDict);
#endif
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self.signInView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 登录成功后的操作
 */
- (void)thn_loginSuccessWithModeType:(THNLoginModeType)type {
    if (type == THNLoginModeTypePassword) {
        [self thn_loginSuccessBack];
        
    } else if (type == THNLoginModeTypeVeriDynamic) {
        if ([THNLoginManager isFirstLogin]) {
            [self thn_openNewUserInfoController];
            
        } else {
            [self thn_loginSuccessBack];
        }
    }

    [THNAdvertManager checkIsNewUserBonus];
}

- (void)thn_loginSuccessBack {
    [SVProgressHUD thn_show];
    
    [[THNLoginManager sharedManager] getUserProfile:^(THNResponse *result, NSError *error) {
        if (error) {
            [self.signInView thn_setErrorHintText:[error localizedDescription]];
            return ;
        }
        
        if (![result isSuccess]) {
            [self.signInView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        [SVProgressHUD thn_showSuccessWithStatus:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLivingHallStatus object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

/**
 新用户去设置个人信息
 */
- (void)thn_openNewUserInfoController {
    THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
    [self.navigationController pushViewController:newUserInfoVC animated:YES];
}

/**
 微信绑定手机号
 */
- (void)thn_openBindPhoneControllerWithWechatOpenId:(NSString *)openId {
    THNBindPhoneViewController *bindVC = [[THNBindPhoneViewController alloc] init];
    bindVC.wechatOpenId = openId;
    [self.navigationController pushViewController:bindVC animated:YES];
}

/**
 获取错误信息提示
 */
- (NSString *)thn_getErrorMessage:(NSError *)error {
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return body[@"status"][@"message"];
}

#pragma mark - custom delegate
- (void)thn_signInWithParam:(NSDictionary *)param loginModeType:(THNLoginModeType)type {
    [THNLoginManager userLoginWithParams:param
                                modeType:type
                              completion:^(THNResponse *result, NSError *error) {
                                  if (error) {
                                      [self.signInView thn_setErrorHintText:[self thn_getErrorMessage:error]];
                                      return ;
                                  }
                                  
                                  if (![result isSuccess]) {
                                      [self.signInView thn_setErrorHintText:result.statusMessage];
                                      return;
                                  }
                                  
                                  [self thn_loginSuccessWithModeType:type];
                              }];
}

- (void)thn_signInSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode1: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_signInShowZipCodeList {
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    zipCodeVC.selectAreaCodeBlock = ^(NSString *code) {
        [self.signInView thn_setAreaCode:code];
    };
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

- (void)thn_signInForgetPassword {
    THNFindPasswordViewController *findPasswordVC = [[THNFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

- (void)thn_signInToRegister {
    THNSignUpViewController *signUpVC = [[THNSignUpViewController alloc] init];
    signUpVC.canSkip = self.canSkip;
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (void)thn_signInUseWechatLogin {
    WEAKSELF;
    
    [THNLoginManager useWechatLoginCompletion:^(BOOL isBind, NSString *openid, NSError *error) {
        if (!isBind) {
            [weakSelf thn_openBindPhoneControllerWithWechatOpenId:openid];
            
        } else {
            if ([THNLoginManager isFirstLogin]) {
                [weakSelf thn_openNewUserInfoController];
                
            } else {
                [SVProgressHUD thn_showSuccessWithStatus:@"登录成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLivingHallStatus object:nil];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            
            [THNAdvertManager checkIsNewUserBonus];
        }
    }];
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
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationBarView setNavigationBackButton];
        return;
    }
    
    if (self.canSkip) {
        WEAKSELF;
        [self.navigationBarView setNavigationRightButtonOfText:kTextSkip textHexColor:@"#666666"];
        [self.navigationBarView didNavigationRightButtonCompletion:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

#pragma mark - getters and setters
- (BOOL)canBack {
    return _canSkip ? _canSkip : YES;
}

- (void)setCanBack:(BOOL)canBack {
    self.navigationBarView.hidden = !canBack;
}

- (THNSignInView *)signInView {
    if (!_signInView) {
        _signInView = [[THNSignInView alloc] init];
        _signInView.delegate = self;
    }
    return _signInView;
}

@end
