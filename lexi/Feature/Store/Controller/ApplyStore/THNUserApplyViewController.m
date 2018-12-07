//
//  THNUserApplyViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserApplyViewController.h"
#import "THNUserApplyView.h"
#import "THNZipCodeViewController.h"
#import "THNApplySuccessViewController.h"
#import "THNLoginManager.h"

static NSString *const kTitleApply          = @"申请生活馆";
/// 获取验证码 api
static NSString *const kURLVerifyCode       = @"/users/wx_bind_mobile_verify_code";
/// 开通生活馆 api
static NSString *const kURLApply            = @"/store/apply_life_store";
/// 获取请求结果参数
static NSString *const kResultData          = @"data";
static NSString *const kResultVerifyCode    = @"phone_verify_code";
/// 发送验证码 key
static NSString *const kParamAreaCode       = @"area_code";
static NSString *const kParamMobile         = @"mobile";

@interface THNUserApplyViewController () <THNUserApplyViewDelegate>

/// 申请资料填写视图
@property (nonatomic, strong) THNUserApplyView *userApplyView;

@end

@implementation THNUserApplyViewController

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
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self.userApplyView thn_setVerifyCode:result.data[kResultVerifyCode]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 开通生活馆
 */
- (void)networkApplyLifeStoreWithParam:(NSDictionary *)param {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLApply requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        [[THNLoginManager sharedManager] updateUserLivingHallStatus:YES
                                                       initSupplier:NO
                                                        initStoreId:result.data[@"store_rid"]];
        [self thn_openApplySuccessController];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_applyLifeStoreWithParam:(NSDictionary *)param {
    [self networkApplyLifeStoreWithParam:param];
}

- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode {
    NSDictionary *paramDict = @{kParamMobile : phoneNum,
                                kParamAreaCode: zipCode};
    
    [self networkGetVerifyCodeWithParam:paramDict];
}

- (void)thn_showZipCodeList {
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    zipCodeVC.selectAreaCodeBlock = ^(NSString *code) {
        [self.userApplyView thn_setAreaCode:code];
    };
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

#pragma mark - private methods
- (void)thn_openApplySuccessController {
    THNApplySuccessViewController *successVC = [[THNApplySuccessViewController alloc] init];
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.userApplyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleApply;
}

#pragma mark - getters and setters
- (THNUserApplyView *)userApplyView {
    if (!_userApplyView) {
        _userApplyView = [[THNUserApplyView alloc] init];
        _userApplyView.delegate = self;
    }
    return _userApplyView;
}

@end
