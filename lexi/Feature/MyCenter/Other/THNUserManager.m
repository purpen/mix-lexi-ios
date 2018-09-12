//
//  THNUserManager.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserManager.h"
#import "THNAPI.h"
#import "THNMarco.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+Helper.h"

/// api 拼接地址
static NSString *const kURLUserCenter      = @"/users/user_center";
static NSString *const kURLUserLikedWindow = @"/shop_windows/user_likes";
static NSString *const kURLUserFollowStore = @"/users/followed_stores";
/// 接收数据参数
static NSString *const kKeyShopWindows  = @"shop_windows";
static NSString *const kKeyStores       = @"stores";

@implementation THNUserManager

#pragma mark - public methods
+ (void)getUserCenterCompletion:(void (^)(THNUserModel *, NSError *))completion {
    [[THNUserManager sharedManager] requestUserCenterCompletion:completion];
}

+ (void)getUserLikedWindowWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [[THNUserManager sharedManager] requestUserLikedWindowWithParams:params completion:completion];
}

+ (void)getUserFollowStoreWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    [[THNUserManager sharedManager] requestUserFollowStoreWithParams:param completion:completion];
}

#pragma mark - request
/**
 请求个人中心
 */
- (void)requestUserCenterCompletion:(void (^)(THNUserModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUserCenter requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        THNUserModel *model = [THNUserModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 请求已喜欢橱窗列表
 */
- (void)requestUserLikedWindowWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUserLikedWindow requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        completion((NSArray *)result.data[kKeyShopWindows], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 请求关注的店铺列表
 */
- (void)requestUserFollowStoreWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUserFollowStore requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;

        completion((NSArray *)result.data[kKeyStores], nil);
    
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
