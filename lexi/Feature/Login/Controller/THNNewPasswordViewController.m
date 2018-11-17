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

/// 设置密码 api
static NSString *const kURLModifyPwd        = @"/auth/modify_pwd";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamAreaCode       = @"areacode";
static NSString *const kParamPassword       = @"password";
static NSString *const kParamAffirmPassword = @"affirm_password";

@interface THNNewPasswordViewController ()

@property (nonatomic, strong) THNSetPasswordView *setPasswordView;

@end

@implementation THNNewPasswordViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)networdPostNewPasswordWithParam:(NSDictionary *)param completion:(void (^)(void))completion {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLModifyPwd requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showSuccessWithStatus:result.statusMessage];
            return ;
        }
    
        [SVProgressHUD dismiss];
        if (completion) {
            completion();
        }
     
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 获取密码参数
 */
- (void)thn_getPasswordParam:(NSString *)password affirmPassword:(NSString *)affirmPassword {
    WEAKSELF;
    
    if (!self.email.length || !password.length || !affirmPassword.length) {
        [SVProgressHUD thn_showErrorWithStatus:@"获取注册信息失败"];
        return;
    }
    
    NSDictionary *paramDict = @{kParamEmail: self.email,
                                kParamPassword: password,
                                kParamAffirmPassword: affirmPassword};
    
    [self networdPostNewPasswordWithParam:paramDict completion:^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)thn_signInWithParam:(NSDictionary *)param {
    [SVProgressHUD thn_show];
    
    [THNLoginManager userLoginWithParams:param modeType:THNLoginModeTypePassword completion:^(THNResponse *result, NSError *error) {
        if (error && ![result isSuccess]) {
            [SVProgressHUD thn_showErrorWithStatus:@"登录失败"];
            return ;
        }
    
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
        
        WEAKSELF;
        _setPasswordView.SetPasswordRegisterBlock = ^(NSString *password, NSString *affirmPassword) {
            [weakSelf thn_getPasswordParam:password affirmPassword:affirmPassword];
        };
    }
    return _setPasswordView;
}

#pragma mark - dealloc
- (BOOL)willDealloc {
    [self.setPasswordView removeFromSuperview];
    
    return YES;
}

@end
