//
//  THNFindPasswordViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFindPasswordViewController.h"
#import "THNFindPasswordView.h"
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

@property (nonatomic, strong) THNFindPasswordView *findPasswordView;

@end

@implementation THNFindPasswordViewController

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
        NSLog(@"找回密码-验证码：%@", result.responseDict);
#endif
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self.findPasswordView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 忘记密码
 */
- (void)networkPostFindPasswordWith:(NSDictionary *)param {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLFindPassword requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [self.findPasswordView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        [self thn_openNewPasswordControllerWithEmail:result.data[kParamEmail]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_findPwdSetPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamEmail : phoneNum,
                                kParamAreaCode1: zipCode,
                                kParamVerifyCode: code};
    
    [self networkPostFindPasswordWith:paramDict];
}

- (void)thn_findPwdSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_findPwdShowZipCodeList {
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    zipCodeVC.selectAreaCodeBlock = ^(NSString *code) {
        [self.findPasswordView thn_setAreaCode:code];
    };
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

#pragma mark - private methods
- (void)thn_openNewPasswordControllerWithEmail:(NSString *)email {
    THNNewPasswordViewController *newPwdVC = [[THNNewPasswordViewController alloc] init];
    newPwdVC.email = email;
    [self.navigationController pushViewController:newPwdVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.findPasswordView];
}

#pragma mark - getters and setters
- (THNFindPasswordView *)findPasswordView {
    if (!_findPasswordView) {
        _findPasswordView = [[THNFindPasswordView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _findPasswordView.delegate = self;
    }
    return _findPasswordView;
}

@end
