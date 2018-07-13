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

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

/// 请求 URL 拼接地址
static NSString *const kUrlBusinessLogin    = @"/auth/business_login";
static NSString *const kUrlExchangeToken    = @"/auth/exchange_token";
static NSString *const kUrlLogout           = @"/auth/logout";

/// 请求数据 key
static NSString *const kRequestData         = @"data";
static NSString *const kRequestExpiration   = @"expiration";
static NSString *const kRequestStoreRid     = @"store_rid";
static NSString *const kRequestToken        = @"token";
static NSString *const kRequestAccessToken  = @"access_token";
static NSString *const kRequestAppKey       = @"app_key";

@implementation THNLoginManager

MJCodingImplementation

#pragma mark - request
/**
 商家登录后台
 */
- (void)requestBusinessLogin:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [SVProgressHUD showWithStatus:kTextLoginSigning];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    THNRequest *request = [THNAPI postWithUrlString:kUrlBusinessLogin requestDictionary:params isSign:NO delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSDictionary *resultData = NULL_TO_NIL(result[kRequestData]);
        
        if (!resultData) {
            [SVProgressHUD showErrorWithStatus:kTextLoginError];
            return;
        }
        
        self.token = NULL_TO_NIL(resultData[kRequestToken]);
        self.storeRid = NULL_TO_NIL(resultData[kRequestStoreRid]);
        self.expirationTime = NULL_TO_NIL(resultData[kRequestExpiration]);
        self.appKey = @"";
        self.accessToken = @"";
        
        [self saveLoginTime];
        
        [self requestExchangeToken:@{@"store_rid": self.storeRid} completion:completion];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:kTextLoginError];
        
        completion(error);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

/**
 商家换取授权 Token
 */
- (void)requestExchangeToken:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    THNRequest *request = [THNAPI postWithUrlString:kUrlExchangeToken requestDictionary:params isSign:NO delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSDictionary *resultData = NULL_TO_NIL(result[kRequestData]);
        
        if (!resultData) {
            [SVProgressHUD showErrorWithStatus:kTextLoginError];
            return;
        }
        
        self.appKey = NULL_TO_NIL(resultData[kRequestAppKey]);
        self.accessToken = NULL_TO_NIL(resultData[kRequestAccessToken]);
        
        [self saveLoginInfo];
        
        completion(nil);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:kTextLoginError];
        
        completion(error);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

/**
 登出账号
 */
- (void)requestLogoutCompletion:(void (^)(NSError *))completion {
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogout requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, id result) {
        [self clearLoginInfo];
        
        [SVProgressHUD dismiss];
        
        completion(nil);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:kTextLogoutError];
        
        completion(error);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

#pragma mark - method
- (void)businessLogoutCompletion:(void (^)(NSError *))completion {
    [self requestLogoutCompletion:completion];
}

- (void)businessLoginWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [[THNLoginManager sharedManager] requestBusinessLogin:params completion:completion];
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

/**
 保存登录信息
 */
- (void)saveLoginInfo {
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
