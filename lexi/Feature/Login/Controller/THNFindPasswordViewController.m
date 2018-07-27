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
        [self.findPasswordView thn_setVerifyCode:resultData[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 忘记密码
 */
- (void)networkPostFindPasswordWith:(NSDictionary *)param {
    THNRequest *request = [THNAPI postWithUrlString:kURLFindPassword
                                  requestDictionary:param
                                             isSign:NO
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        if ([result[@"success"] isEqualToNumber:@0]) {
            [self.findPasswordView thn_setErrorHintText:result[@"status"][@"message"]];
            return;
        }
        
        if ([result[kResultData] isKindOfClass:[NSNull class]]) {
            return ;
        }
        
        NSLog(@"重置密码 ==== %@", result);
        THNNewPasswordViewController *newPasswordVC = [[THNNewPasswordViewController alloc] init];
        newPasswordVC.email = result[@"data"][kParamEmail];
        [self.navigationController pushViewController:newPasswordVC animated:YES];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_setPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamEmail : phoneNum,
                                kParamAreaCode1: zipCode,
                                kParamVerifyCode: code};
    
    [self networkPostFindPasswordWith:paramDict];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    WEAKSELF;
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    __weak THNZipCodeViewController *weakZipCodeVC = zipCodeVC;
    
    weakZipCodeVC.SelectAreaCode = ^(NSString *code) {
        [weakSelf.findPasswordView thn_setAreaCode:code];
        [weakZipCodeVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:zipCodeVC animated:YES completion:nil];
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

@end
