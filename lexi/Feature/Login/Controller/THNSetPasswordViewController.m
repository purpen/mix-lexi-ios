//
//  THNSetPasswordViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetPasswordViewController.h"
#import "THNNewUserInfoViewController.h"
#import "THNSetPasswordView.h"
#import "THNLoginManager.h"

/// 设置密码 api
static NSString *const kParamEmail          = @"email";
static NSString *const kParamAreaCode       = @"areacode";
static NSString *const kParamPassword       = @"password";
static NSString *const kParamAffirmPassword = @"affirm_password";

@interface THNSetPasswordViewController ()

@property (nonatomic, strong) THNSetPasswordView *setPasswordView;

@end

@implementation THNSetPasswordViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - private methods
/**
 获取密码参数
 */
- (void)thn_getPasswordParam:(NSString *)password affirmPassword:(NSString *)affirmPassword {
    WEAKSELF;
    if (!weakSelf.email.length || !weakSelf.areacode.length || !password.length || !affirmPassword.length) {
        [SVProgressHUD showErrorWithStatus:@"获取注册信息失败"];
        return;
    }
    
    NSDictionary *paramDict = @{kParamEmail: weakSelf.email,
                                kParamAreaCode: weakSelf.areacode,
                                kParamPassword: password,
                                kParamAffirmPassword: affirmPassword};
    
    [THNLoginManager userRegisterWithParams:paramDict completion:^(NSError *error) {
        if (error) return;
        
        THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController:newUserInfoVC animated:YES];
    }];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.setPasswordView];
}

#pragma mark - getters and setters
- (THNSetPasswordView *)setPasswordView {
    if (!_setPasswordView) {
        _setPasswordView = [[THNSetPasswordView alloc] initWithType:(THNSetPasswordTypeNew)];
        
        WEAKSELF;
        _setPasswordView.SetPasswordRegisterBlock = ^(NSString *password, NSString *affirmPassword) {
            [weakSelf thn_getPasswordParam:password affirmPassword:affirmPassword];
        };
    }
    return _setPasswordView;
}

@end
