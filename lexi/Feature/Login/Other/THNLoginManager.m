//
//  THNLoginManger.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginManager.h"
#import <MJExtension/MJExtension.h>
#import "THNAPI.h"
#import "NSString+Helper.h"
#import "SVProgressHUD+Helper.h"
#import "THNTextConst.h"
#import "THNConst.h"
#import "THNMarco.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

/// api 拼接地址
static NSString *const kURLUserLogin    = @"/auth/login";
static NSString *const kURLDynamicLogin = @"/auth/app_dynamic_login";
static NSString *const kURLAppRegister  = @"/auth/set_password";
static NSString *const kURLLogout       = @"/auth/logout";
static NSString *const kURLUserProfile  = @"/users/profile";
static NSString *const kURLUsers        = @"/users";
/// 请求数据 key
static NSString *const kRequestData         = @"data";
static NSString *const kRequestExpiration   = @"expiration";
static NSString *const kRequestFirstLogin   = @"is_first_login";
static NSString *const kRequestToken        = @"token";
static NSString *const kRequestStoreRid     = @"store_rid";
static NSString *const kRequestIsSmallB     = @"is_small_b";
static NSString *const kRequestProfile      = @"profile";
static NSString *const kRequestUserId       = @"uid";
static NSString *const kRequestSupplier     = @"is_supplier";

@implementation THNLoginManager

MJCodingImplementation

#pragma mark - method
+ (void)userLoginWithParams:(NSDictionary *)params modeType:(THNLoginModeType)type completion:(void (^)(THNResponse *, NSError *))completion {
    [[THNLoginManager sharedManager] requestUserLogin:params modeType:type completion:completion];
}

+ (void)userRegisterWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [[THNLoginManager sharedManager] requestUserRegister:params completion:completion];
}

+ (void)userLogoutCompletion:(void (^)(NSError *))completion {
    [[THNLoginManager sharedManager] requestLogoutCompletion:completion];
}

#pragma mark - request
/**
 用户登录
 */
- (void)requestUserLogin:(NSDictionary *)params
                modeType:(THNLoginModeType)type
              completion:(void (^)(THNResponse *, NSError *))completion {
    
    NSString *postUrl = [self thn_getLoginUrlWithType:type];
    THNRequest *request = [THNAPI postWithUrlString:postUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        self.token = result.data[kRequestToken];
        self.expirationTime = result.data[kRequestExpiration];
        self.firstLogin = [result.data[kRequestFirstLogin] integerValue];

        completion(result, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 注册
 */
- (void)requestUserRegister:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLAppRegister requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:kTextRegisterError];
            return ;
        }
        
        self.token = NULL_TO_NIL(result.data[kRequestToken]);
        self.expirationTime = NULL_TO_NIL(result.data[kRequestExpiration]);
        self.openingUser = NO;
        
        [self saveLoginInfo];
        completion(nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:kTextRegisterError];
        completion(error);
    }];
}

/**
 登出账号
 */
- (void)requestLogoutCompletion:(void (^)(NSError *))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLLogout requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [self clearLoginInfo];
        completion(nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(error);
    }];
}

/**
 获取用户信息
 */
- (void)getUserProfile:(void (^)(THNResponse *data, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUserProfile requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        self.storeRid = result.data[kRequestStoreRid];
        self.openingUser = [result.data[kRequestIsSmallB] boolValue];
        self.supplier = [result.data[kRequestSupplier] boolValue];
        self.userData = result.data[kRequestProfile];
        self.userId = result.data[kRequestProfile][kRequestUserId];
        
        [self saveLoginInfo];
        
        if (completion) {
            completion(result, nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:kTextRequestError];
        
        if (completion) {
            completion(nil, error);
        }
    }];
}


- (void)updateUserLivingHallStatus:(BOOL)openingUser initSupplier:(BOOL)supplier initStoreId:(NSString *)storeId {
    self.openingUser = openingUser;
    self.storeRid = storeId;
    self.supplier = supplier;
    [self saveLoginInfo];
}

/**
 更新用户信息
 */
- (void)updateUserProfileWithParams:(NSDictionary *)params completion:(void (^)(THNResponse *data, NSError *error))completion {
    THNRequest *request = [THNAPI putWithUrlString:kURLUsers requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        self.userData = result.data;
        
        [self saveLoginInfo];
        completion(result, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

/**
 是否登录
 */
+ (BOOL)isLogin {
    if (![THNLoginManager sharedManager].token) {
        return NO;
    }
    
    // 授权过期
    if (![THNLoginManager sharedManager].expirationTime || [[THNLoginManager sharedManager] isExpiration]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isFirstLogin {
    if ([THNLoginManager sharedManager].firstLogin == 1) {
        return YES;
    }
    
    return NO;
}

/**
 保存登录信息
 */
- (void)saveLoginInfo {
    [self saveLoginTime];
    [NSKeyedArchiver archiveRootObject:self toFile:[[self class] archiveFilePath]];
}

/**
 清除登录信息
 */
- (void)clearLoginInfo {
    //  客户端清空缓存的 token
    self.token = nil;
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[[self class] archiveFilePath]]) {
        [defaultManager removeItemAtPath:[[self class] archiveFilePath] error:nil];
    }
}

/**
 保存登录时间
 */
- (void)saveLoginTime {
    self.loginTime = [NSString getTimestamp];
}

/**
 token 是否过期
 */
- (BOOL)isExpiration {
    // 登录至今的间隔时间
    NSTimeInterval intervalTime = [NSString comparisonStartTimestamp:[THNLoginManager sharedManager].loginTime
                                                        endTimestamp:[NSString getTimestamp]];
    // 过期时间
    NSTimeInterval expirationTime = (NSTimeInterval)[[THNLoginManager sharedManager].expirationTime floatValue];
    
    BOOL expiration = expirationTime - intervalTime == 0 ? YES : NO;
    
    return expiration;
}

/**
 存档文件路径
 */
+ (NSString *)archiveFilePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:NSStringFromClass(self)];
}

#pragma mark - private methods
/**
 根据登录类型获取 api url地址

 @param type 登录类型
 @return url 拼接地址
 */
- (NSString *)thn_getLoginUrlWithType:(THNLoginModeType)type {
    NSString *postUrl = nil;
    
    switch (type) {
        case THNLoginModeTypePassword:
            postUrl = kURLUserLogin;
            break;
            
        case THNLoginModeTypeVeriDynamic:
            postUrl = kURLDynamicLogin;
            break;
    }
    
    return postUrl;
}

/**
 打开登录视图
 */
- (void)openUserLoginController {
    dispatch_async(dispatch_get_main_queue(), ^{
        THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
        THNBaseNavigationController *loginNavController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNavController
                                                                                     animated:YES
                                                                                   completion:nil];
    });
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveFilePath]];
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
