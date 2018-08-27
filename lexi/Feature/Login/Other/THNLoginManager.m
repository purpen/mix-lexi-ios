//
//  THNLoginManger.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginManager.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNAPI.h"
#import "NSString+Helper.h"
#import "THNTextConst.h"
#import "THNConst.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

/// api 拼接地址
static NSString *const kURLUserLogin    = @"/auth/login";
static NSString *const kURLDynamicLogin = @"/auth/app_dynamic_login";
static NSString *const kURLAppRegister  = @"/auth/set_password";
static NSString *const kURLLogout       = @"/auth/logout";
static NSString *const kURLUserProfile  = @"/users/profile";
/// 请求数据 key
static NSString *const kRequestData         = @"data";
static NSString *const kRequestExpiration   = @"expiration";
static NSString *const kRequestFirstLogin   = @"is_first_login";
static NSString *const kRequestToken        = @"token";
static NSString *const kRequestStoreRid     = @"store_rid";
static NSString *const kRequestIsSmallB     = @"is_small_b";

@implementation THNLoginManager

MJCodingImplementation

#pragma mark - request
/**
 用户登录
 */
- (void)requestUserLogin:(NSDictionary *)params
                modeType:(THNLoginModeType)type
              completion:(void (^)(THNResponse *, NSError *))completion {
    
    [SVProgressHUD showWithStatus:kTextLoginSigning];
    
    NSString *postUrl = [self thn_getLoginUrlWithType:type];
    
    THNRequest *request = [THNAPI postWithUrlString:postUrl requestDictionary:params delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) {
            [SVProgressHUD dismiss];
            return ;
        }
        
        self.token = result.data[kRequestToken];
        self.expirationTime = result.data[kRequestExpiration];
        self.firstLogin = [result.data[kRequestFirstLogin] integerValue];

        [SVProgressHUD showSuccessWithStatus:kTextLoginSuccess];
        
        completion(result, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        
        completion(nil, error);
    }];
}

/**
 获取用户信息
 */
- (void)getUserProfile:(void (^)(THNResponse *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUserProfile requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.storeRid = result.data[kRequestStoreRid];
        self.openingUser = result.data[kRequestIsSmallB];
        [self saveLoginInfo];
        completion(result, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 注册
 */
- (void)requestUserRegister:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [SVProgressHUD show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLAppRegister requestDictionary:params delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRegisterError];
            return ;
        }
        
        self.token = NULL_TO_NIL(result.data[kRequestToken]);
        self.expirationTime = NULL_TO_NIL(result.data[kRequestExpiration]);
        
        [self saveLoginInfo];
        [SVProgressHUD dismiss];
        
        completion(nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:kTextRegisterError];
        
        completion(error);
    }];
}

/**
 登出账号
 */
- (void)requestLogoutCompletion:(void (^)(NSError *))completion {
    [SVProgressHUD show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLLogout requestDictionary:nil delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self clearLoginInfo];
        
        [SVProgressHUD dismiss];
        
        completion(nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:kTextLogoutError];
        
        completion(error);
    }];
}

#pragma mark - method
+ (void)userLoginWithParams:(NSDictionary *)params
                   modeType:(THNLoginModeType)type
                 completion:(void (^)(THNResponse *, NSError *))completion {
    
    [[THNLoginManager sharedManager] requestUserLogin:params
                                             modeType:type
                                           completion:completion];
}

+ (void)userRegisterWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [[THNLoginManager sharedManager] requestUserRegister:params completion:completion];
}

+ (void)userLogoutCompletion:(void (^)(NSError *))completion {
    [[THNLoginManager sharedManager] requestLogoutCompletion:completion];
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
