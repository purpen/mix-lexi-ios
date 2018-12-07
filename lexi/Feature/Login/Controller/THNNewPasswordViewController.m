//
//  THNNewPasswordViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewPasswordViewController.h"
#import "THNSetPasswordView.h"
#import "THNLoginManager.h"
#import "THNAdvertManager.h"

/// 设置密码 api
static NSString *const kURLModifyPwd        = @"/auth/modify_pwd";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamAreaCode       = @"areacode";
static NSString *const kParamPassword       = @"password";
static NSString *const kParamAffirmPassword = @"affirm_password";

@interface THNNewPasswordViewController () <THNSetPasswordViewDelegate>

@property (nonatomic, strong) THNSetPasswordView *setPasswordView;

@end

@implementation THNNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network  
/**
 设置新密码
 */
- (void)networdPostNewPasswordWithParam:(NSDictionary *)param {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLModifyPwd requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self thn_signInWithParam:param];
     
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_setPasswordToRegister:(NSString *)password affirmPassword:(NSString *)affirmPassword {
    [self thn_getPasswordParam:password affirmPassword:affirmPassword];
}

#pragma mark - private methods
/**
 获取密码参数
 */
- (void)thn_getPasswordParam:(NSString *)password affirmPassword:(NSString *)affirmPassword {
    if (!self.email.length || !password.length || !affirmPassword.length) {
        return;
    }
    
    NSDictionary *paramDict = @{kParamEmail: self.email,
                                kParamPassword: password,
                                kParamAffirmPassword: affirmPassword};
    
    [self networdPostNewPasswordWithParam:paramDict];
}

/**
 修改完密码直接登录
 */
- (void)thn_signInWithParam:(NSDictionary *)param {
    [SVProgressHUD thn_show];
    
    [THNLoginManager userLoginWithParams:param
                                modeType:THNLoginModeTypePassword
                              completion:^(THNResponse *result, NSError *error) {
                                  if (![result isSuccess]) {
                                      [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
                                      return ;
                                  }
                                  
                                  [SVProgressHUD thn_showSuccessWithStatus:@"登录成功"];
                                  [THNAdvertManager checkIsNewUserBonus];
                                  [self dismissViewControllerAnimated:YES completion:nil];
                              }];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.setPasswordView];
}

#pragma mark - getters and setters
- (THNSetPasswordView *)setPasswordView {
    if (!_setPasswordView) {
        _setPasswordView = [[THNSetPasswordView alloc] initWithType:(THNSetPasswordTypeFind)];
        _setPasswordView.delegate = self;
    }
    return _setPasswordView;
}

@end
