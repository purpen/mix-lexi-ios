//
//  THNSetPasswordViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetPasswordViewController.h"
#import "THNSetPasswordView.h"
#import "THNNewUserInfoViewController.h"

/// 设置密码 api
static NSString *const kURLSetPassword      = @"/auth/set_password";
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

#pragma mark - network
- (void)networkPostSetPassword:(NSDictionary *)param {
    NSLog(@"设置密码的参数：===== %@", param);
    THNRequest *request = [THNAPI postWithUrlString:kURLSetPassword
                                  requestDictionary:param
                                             isSign:NO
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSLog(@"设置密码 === %@", result);
        THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
        [self.navigationController pushViewController:newUserInfoVC animated:YES];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 获取密码参数
 */
- (void)thn_getPasswordParam:(NSString *)password affirmPassword:(NSString *)affirmPassword {
    if (!self.email.length || !self.areacode.length || !password.length || !affirmPassword.length) {
        [SVProgressHUD showErrorWithStatus:@"获取注册信息失败"];
        return;
    }
    
    NSDictionary *paramDict = @{kParamEmail: self.email,
                                kParamAreaCode: self.areacode,
                                kParamPassword: password,
                                kParamAffirmPassword: affirmPassword};
    
    [self networkPostSetPassword:paramDict];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.setPasswordView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.setPasswordView endEditing:YES];
}

#pragma mark - getters and setters
- (THNSetPasswordView *)setPasswordView {
    if (!_setPasswordView) {
        _setPasswordView = [[THNSetPasswordView alloc] init];
        
        WEAKSELF;
        
        _setPasswordView.SetPasswordRegisterBlock = ^(NSString *password, NSString *affirmPassword) {
            [weakSelf thn_getPasswordParam:password affirmPassword:affirmPassword];
        };
    }
    return _setPasswordView;
}

@end
