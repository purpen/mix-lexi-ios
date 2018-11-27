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
    WEAKSELF;
    
    THNRequest *request = [THNAPI postWithUrlString:kURLVerifyCode requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
#ifdef DEBUG
        NSLog(@"登录验证码 ==== %@", result.responseDict);
#endif
        if (![result hasData] || ![result isSuccess]) {
            [SVProgressHUD thn_showErrorWithStatus:@"数据错误"];
            return ;
        }
        
        [weakSelf.signInView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 登录成功后的操作
 */
- (void)thn_loginSuccessWithModeType:(THNLoginModeType)type {
    WEAKSELF;
    
    if (type == THNLoginModeTypePassword) {
        [self thn_loginSuccessBack];
        
    } else if (type == THNLoginModeTypeVeriDynamic) {
        if ([THNLoginManager isFirstLogin]) {
            THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:newUserInfoVC animated:YES];
            
        } else {
            [self thn_loginSuccessBack];
        }
    }

    [THNAdvertManager checkIsNewUserBonus];
}

- (void)thn_loginSuccessBack {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [[THNLoginManager sharedManager] getUserProfile:^(THNResponse *result, NSError *error) {
        if (error) {
            [weakSelf.signInView thn_setErrorHintText:[error localizedDescription]];
            return ;
        }
        
        if (![result isSuccess]) {
            [weakSelf.signInView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLivingHallStatus object:nil];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
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
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNLoginManager userLoginWithParams:param modeType:type completion:^(THNResponse *result, NSError *error) {
        if (error) {
            [weakSelf.signInView thn_setErrorHintText:[weakSelf thn_getErrorMessage:error]];
            return ;
        }
        
        if (![result isSuccess]) {
            [weakSelf.signInView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        [weakSelf thn_loginSuccessWithModeType:type];
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
    signUpVC.canSkip = self.canSkip;
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

- (THNZipCodeViewController *)zipCodeVC {
    if (!_zipCodeVC) {
        _zipCodeVC = [[THNZipCodeViewController alloc] init];
        
        WEAKSELF;
        _zipCodeVC.SelectAreaCode = ^(NSString *code) {
            [weakSelf.signInView thn_setAreaCode:code];
            [weakSelf.zipCodeVC dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _zipCodeVC;
}

#pragma mark - dealloc
- (BOOL)willDealloc {
    [self.signInView removeFromSuperview];
    
    return YES;
}

@end
