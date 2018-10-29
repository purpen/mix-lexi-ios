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
#import "SVProgressHUD+Helper.h"
#import "NSString+Helper.h"

/// api 拼接地址
static NSString *const kURLUserCenter           = @"/users/user_center";
static NSString *const kURLOtherUserCenter      = @"/users/get_other_user_center";
static NSString *const kURLUserLikedWindow      = @"/shop_windows/user_likes";
static NSString *const kURLOtherUserLikedWindow = @"/shop_windows/other_user_likes";
static NSString *const kURLUserFollowStore      = @"/users/followed_stores";
static NSString *const kURLOtherUserFollowStore = @"/users/other_followed_stores";
static NSString *const kURLCouponBrand          = @"/market/core_user_coupons";
static NSString *const kURLCouponOfficial       = @"/market/user_official";
static NSString *const kURLCouponFail           = @"/market/user_expired";
/// 接收数据参数
static NSString *const kKeyShopWindows  = @"shop_windows";
static NSString *const kKeyStores       = @"stores";
static NSString *const kKeyCoupons      = @"coupons";
static NSString *const kKeyUid          = @"uid";

@implementation THNUserManager

#pragma mark - public methods
+ (void)getUserCenterWithUserId:(NSString *)userId Completion:(void (^)(THNUserModel *, NSError *))completion  {
    NSDictionary *paramDict = userId.length ? @{kKeyUid: userId} : @{};
    [[THNUserManager sharedManager] requestUserCenterWithParams:paramDict Completion:completion];
}

+ (void)getUserLikedWindowWithParams:(NSDictionary *)params completion:(void (^)(THNWindowModel *, NSError *))completion {
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
            
        case THNUserCouponTypeFail: {
            [[THNUserManager sharedManager] requestUserFailCouponWithParams:params completion:completion];
        }
            break;
    }
}

#pragma mark - request
/**
 请求个人中心
 */
- (void)requestUserCenterWithParams:(NSDictionary *)params Completion:(void (^)(THNUserModel *, NSError *))completion {
    BOOL isOtherUser = [[params allKeys] containsObject:kKeyUid];
    NSString *urlStr = isOtherUser ? kURLOtherUserCenter : kURLUserCenter;
    
    THNRequest *request = [THNAPI getWithUrlString:urlStr requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"======= 个人中心：%@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        };
        
        THNUserModel *model = [THNUserModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

/**
 请求已喜欢橱窗列表
 */
- (void)requestUserLikedWindowWithParams:(NSDictionary *)params completion:(void (^)(THNWindowModel *, NSError *))completion {
    BOOL isOtherUser = [[params allKeys] containsObject:kKeyUid];
    NSString *urlStr = isOtherUser ? kURLOtherUserLikedWindow : kURLUserLikedWindow;
    
    THNRequest *request = [THNAPI getWithUrlString:urlStr requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"======== 喜欢的橱窗列表：%@", [NSString jsonStringWithObject:result.data]);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        };
        
        THNWindowModel *model = [[THNWindowModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

/**
 请求关注的店铺列表
 */
- (void)requestUserFollowStoreWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    BOOL isOtherUser = [[param allKeys] containsObject:kKeyUid];
    NSString *urlStr = isOtherUser ? kURLOtherUserFollowStore : kURLUserFollowStore;
    
    THNRequest *request = [THNAPI getWithUrlString:urlStr requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"===== 关注的店铺：%@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        };
        
        completion((NSArray *)result.data[kKeyStores], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

/**
 请求自己的商家优惠券列表
 */
- (void)requestUserBrandCouponWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLCouponBrand requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        };
        
        completion((NSArray *)result.data[kKeyCoupons], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

/**
 请求自己的官方优惠券列表
 */
- (void)requestUserOfficialCouponWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponOfficial requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        };
        
        completion((NSArray *)result.data[kKeyCoupons], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

/**
 请求自己的失效优惠券列表
 */
- (void)requestUserFailCouponWithParams:(NSDictionary *)param completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponFail requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        };

        completion((NSArray *)result.data[kKeyCoupons], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
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
