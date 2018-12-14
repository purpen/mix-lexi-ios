//
//  THNBindPhoneViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/7.
//  Copyright © 2018 lexi. All rights reserved.
//

#import "THNBindPhoneViewController.h"
#import "THNBindPhoneView.h"
#import "THNZipCodeViewController.h"
#import "THNWebKitViewViewController.h"
#import "THNNewUserInfoViewController.h"
#import "THNLoginManager.h"
#import "THNAdvertManager.h"

/// url
static NSString *const kURlDynamicLogin = @"/auth/app_dynamic_login";
static NSString *const kURLVerifyCode   = @"/users/dynamic_login_verify_code";
/// key
static NSString *const kKeyVerifyCode   = @"phone_verify_code";
static NSString *const kKeyMobile       = @"mobile";
static NSString *const kKeyAreaCode     = @"area_code";
static NSString *const kKeyOpenId       = @"openid";
static NSString *const kParamEmail      = @"email";
static NSString *const kParamAreaCode1  = @"areacode";
static NSString *const kParamVerifyCode = @"verify_code";

@interface THNBindPhoneViewController () <THNBindPhoneViewDelegate>

@property (nonatomic, strong) THNBindPhoneView *bindView;

@end

@implementation THNBindPhoneViewController

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
        NSLog(@"绑定-验证码：%@", result.responseDict);
#endif
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self.bindView thn_setVerifyCode:result.data[kKeyVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 微信绑定授权登录
 */
- (void)requestDynamicLoginWithParams:(NSDictionary *)params {
    if (!self.wechatOpenId.length) {
        [SVProgressHUD thn_showInfoWithStatus:@"微信授权失败"];
        return;
    }
    
    [SVProgressHUD thn_show];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:self.wechatOpenId forKey:kKeyOpenId];
    
    [THNLoginManager userLoginWithParams:[paramDict copy]
                                modeType:(THNLoginModeTypeVeriDynamic)
                              completion:^(THNResponse *result, NSError *error) {
                                  if (error) {
                                      [self.bindView thn_setErrorHintText:[self thn_getErrorMessage:error]];
                                      return ;
                                  }
                                  
                                  if (![result isSuccess]) {
                                      [self.bindView thn_setErrorHintText:result.statusMessage];
                                      return;
                                  }
                                  
                                  [self thn_loginSuccess];
                              }];
}

/**
 登录成功后的操作
 */
- (void)thn_loginSuccess {
    if ([THNLoginManager isFirstLogin]) {
        [self thn_openNewUserInfoController];
        
    } else {
        [self thn_loginSuccessBack];
    }
}

- (void)thn_loginSuccessBack {
    [SVProgressHUD thn_show];
    
    [THNAdvertManager checkIsNewUserBonus];
    
    [[THNLoginManager sharedManager] getUserProfile:^(THNResponse *result, NSError *error) {
        if (error) {
            [self.bindView thn_setErrorHintText:[error localizedDescription]];
            return ;
        }
        
        if (![result isSuccess]) {
            [self.bindView thn_setErrorHintText:result.statusMessage];
            return;
        }
        
        [SVProgressHUD thn_showSuccessWithStatus:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLivingHallStatus object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - custom delegate
- (void)thn_bindPhoneWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code {
    NSDictionary *paramDict = @{kParamAreaCode1 : zipCode,
                                kParamEmail     : phoneNum,
                                kParamVerifyCode: code};
    
    [self requestDynamicLoginWithParams:paramDict];
}

- (void)thn_bindSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kKeyMobile  : phoneNum,
                                kKeyAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_bindShowZipCodeList {
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    zipCodeVC.selectAreaCodeBlock = ^(NSString *code) {
        [self.bindView thn_setAreaCode:code];
    };
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

#pragma mark - private methods
- (void)thn_bindCheckProtocolUrl:(NSString *)url {
    THNWebKitViewViewController *webVC = [[THNWebKitViewViewController alloc] init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 新用户去设置个人信息
 */
- (void)thn_openNewUserInfoController {
    THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
    [self.navigationController pushViewController:newUserInfoVC animated:YES];
}

/**
 获取错误信息提示
 */
- (NSString *)thn_getErrorMessage:(NSError *)error {
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return body[@"status"][@"message"];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.bindView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    
}

#pragma mark - getters and setters
- (THNBindPhoneView *)bindView {
    if (!_bindView) {
        _bindView = [[THNBindPhoneView alloc] init];
        _bindView.delegate = self;
    }
    return _bindView;
}

@end
