//
//  THNFindPasswordViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFindPasswordViewController.h"
#import "THNFindPassword.h"
#import "THNZipCodeViewController.h"
#import "THNNewPasswordViewController.h"

/// 发送忘记密码验证码 api
static NSString *const kURLVerifyCode       = @"/users/find_pwd_verify_code";
static NSString *const kParamMobile         = @"mobile";
static NSString *const kParamAreaCode       = @"area_code";
/// 忘记密码 api
static NSString *const kURLFindPassword     = @"/auth/find_pwd";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamAreaCode1      = @"areacode";
static NSString *const kParamVerifyCode     = @"verify_code";
/// 获取请求结果参数
static NSString *const kResultData          = @"data";
static NSString *const kResultVerifyCode    = @"phone_verify_code";

@interface THNFindPasswordViewController () <THNFindPasswordDelegate>

@property (nonatomic, strong) THNFindPassword *findPasswordView;
@property (nonatomic, strong) THNZipCodeViewController *zipCodeVC;
@property (nonatomic, strong) THNNewPasswordViewController *newPasswordVC;

@end

@implementation THNFindPasswordViewController

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
        NSLog(@"获取验证码 ======== %@", result.responseDict);
        if (![result hasData] || ![result isSuccess]) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        [weakSelf.findPasswordView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 忘记密码
 */
- (void)networkPostFindPasswordWith:(NSDictionary *)param completion:(void (^)(NSString *email))completion {
    [SVProgressHUD thn_showWithStatus:@"正在验证..."];
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI postWithUrlString:kURLFindPassword requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [weakSelf.findPasswordView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        [SVProgressHUD dismiss];
        if (completion) {
            completion(result.data[kParamEmail]);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_setPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamEmail : phoneNum,
                                kParamAreaCode1: zipCode,
                                kParamVerifyCode: code};
    
    [self networkPostFindPasswordWith:paramDict completion:^(NSString *email) {
        [SVProgressHUD dismiss];
        
        self.newPasswordVC.email = email;
        [self.navigationController pushViewController:self.newPasswordVC animated:YES];
    }];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    [self presentViewController:self.zipCodeVC animated:YES completion:nil];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.findPasswordView];
}

#pragma mark - getters and setters
- (THNFindPassword *)findPasswordView {
    if (!_findPasswordView) {
        _findPasswordView = [[THNFindPassword alloc] init];
        _findPasswordView.delegate = self;
    }
    return _findPasswordView;
}

- (THNZipCodeViewController *)zipCodeVC {
    if (!_zipCodeVC) {
        _zipCodeVC = [[THNZipCodeViewController alloc] init];
        
        WEAKSELF;
        _zipCodeVC.SelectAreaCode = ^(NSString *code) {
            [weakSelf.findPasswordView thn_setAreaCode:code];
            [weakSelf.zipCodeVC dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _zipCodeVC;
}

- (THNNewPasswordViewController *)newPasswordVC {
    if (!_newPasswordVC) {
        _newPasswordVC = [[THNNewPasswordViewController alloc] init];
    }
    return _newPasswordVC;
}

#pragma mark - dealloc
- (BOOL)willDealloc {
    [self.findPasswordView removeFromSuperview];
    
    return YES;
}

@end
