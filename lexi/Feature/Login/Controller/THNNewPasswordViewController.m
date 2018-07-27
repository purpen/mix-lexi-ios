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
- (void)networdPostNewPasswordWithParam:(NSDictionary *)param {
    NSLog(@"------- %@", param);
    [SVProgressHUD show];
    THNRequest *request = [THNAPI postWithUrlString:kURLModifyPwd
                                  requestDictionary:param
                                             isSign:YES
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSLog(@"重置密码成功：%@", result);
    
        if ([result[@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
     
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 获取密码参数
 */
- (void)thn_getPasswordParam:(NSString *)password affirmPassword:(NSString *)affirmPassword {
    if (!self.email.length || !password.length || !affirmPassword.length) {
        [SVProgressHUD showErrorWithStatus:@"获取注册信息失败"];
        return;
    }
    
    NSDictionary *paramDict = @{kParamEmail: self.email,
                                kParamPassword: password,
                                kParamAffirmPassword: affirmPassword};
    
    [self networdPostNewPasswordWithParam:paramDict];
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

@end
