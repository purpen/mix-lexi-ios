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

@interface THNSetPasswordViewController () <THNSetPasswordViewDelegate>

@property (nonatomic, strong) THNSetPasswordView *setPasswordView;

@end

@implementation THNSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
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
    if (!self.email.length || !self.areacode.length || !password.length || !affirmPassword.length) {
        return;
    }
    
    NSDictionary *paramDict = @{kParamEmail: self.email,
                                kParamAreaCode: self.areacode,
                                kParamPassword: password,
                                kParamAffirmPassword: affirmPassword};
    
    [THNLoginManager userRegisterWithParams:paramDict completion:^(NSError *error) {
        if (error) return;
        
        [self thn_setNewUserInfoController];
    }];
}

- (void)thn_setNewUserInfoController {
    THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
    [self.navigationController pushViewController:newUserInfoVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.setPasswordView];
}

#pragma mark - getters and setters
- (THNSetPasswordView *)setPasswordView {
    if (!_setPasswordView) {
        _setPasswordView = [[THNSetPasswordView alloc] initWithType:(THNSetPasswordTypeNew)];
        _setPasswordView.delegate = self;
    }
    return _setPasswordView;
}

@end
