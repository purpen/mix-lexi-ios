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
static NSString *const kURLUserCenter       = @"/users/user_center";
static NSString *const kURLUserLikedWindow  = @"/shop_windows/user_likes";
static NSString *const kURLUserFollowStore  = @"/users/followed_stores";
static NSString *const kURLCouponBrand      = @"/market/core_user_coupons";
static NSString *const kURLCouponOfficial   = @"/market/user_official";
/// 接收数据参数
static NSString *const kKeyShopWindows  = @"shop_windows";
static NSString *const kKeyStores       = @"stores";
static NSString *const kKeyCoupons      = @"coupons";

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

+ (void)getUserBrandCouponWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [[THNUserManager sharedManager] requestUserBrandCouponWithParams:params completion:completion];
}

+ (void)getUserOfficialCouponWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [[THNUserManager sharedManager] requestUserOfficialCouponWithParams:params completion:completion];
}

+ (void)getUserFailCouponWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    
}

+ (void)getUserCouponDataWithType:(THNUserCouponType)type params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    switch (type) {
        case THNUserCouponTypeBrand: {
            [[THNUserManager sharedManager] requestUserBrandCouponWithParams:params completion:completion];
        }
            break;
            
        case THNUserCouponTypeOfficial: {
            [[THNUserManager sharedManager] requestUserOfficialCouponWithParams:params completion:completion];
        }
            break;
            
        default:
            break;
    }
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

/**
 请求自己的商家优惠券列表
 */
- (void)requestUserBrandCouponWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    [SVProgressHUD showInfoWithStatus:@""];
    THNRequest *request = [THNAPI postWithUrlString:kURLCouponBrand requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) return;
        THNLog(@"========== 个人的商家优惠券：%@", result.responseDict);
        completion((NSArray *)result.data[kKeyCoupons], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 请求自己的官方优惠券列表
 */
- (void)requestUserOfficialCouponWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    [SVProgressHUD showInfoWithStatus:@""];
    THNRequest *request = [THNAPI postWithUrlString:kURLCouponOfficial requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) return;
        THNLog(@"========== 个人的官方优惠券：%@", result.responseDict);
        completion((NSArray *)result.data[kKeyCoupons], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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
