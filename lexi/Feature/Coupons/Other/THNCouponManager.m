//
//  THNCouponManager.m
//  lexi
//
//  Created by FLYang on 2018/11/1.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponManager.h"
#import "THNAPI.h"
#import "THNMarco.h"
#import "SVProgressHUD+Helper.h"
#import "NSString+Helper.h"
#import "THNCouponOfficialModel.h"
#import "THNCouponSingleModel.h"
#import "THNCouponSharedModel.h"

static NSString *const kURLCouponsOfficial    = @"/market/official_coupons/recommend";
static NSString *const kURLCouponsBrand       = @"/market/coupon_center_shared";
static NSString *const kURLCouponsProduct     = @"/market/coupon_center_single";
static NSString *const kURLGetCoupon          = @"/market/coupons/grant";
static NSString *const kURLGetOfficialCoupon  = @"/market/official_coupons/grant";

/// key
static NSString *const kKeyRid            = @"rid";
static NSString *const kKeyStoreRid       = @"store_rid";
static NSString *const kKeyStoreCategory  = @"store_category";
static NSString *const kKeyOfficial       = @"official_coupons";
static NSString *const kKeyCoupons        = @"coupons";

@implementation THNCouponManager

+ (void)getCouponsCenterOfOfficialWithUserId:(NSString *)userId completion:(void (^)(NSArray *, NSError *))completion {
    NSString *rid = userId.length ? userId : @"";
    
    [[THNCouponManager sharedManager] requestCouponsCenterOfOfficialWithParams:@{kKeyRid: rid} completion:completion];
}

+ (void)getCouponsCenterOfBrandWithCategory:(NSString *)category params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    NSString *categoryId = category.length ? category : @"";
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:categoryId forKey:kKeyStoreCategory];
    
    [[THNCouponManager sharedManager] requestCouponsCenterOfBrandWithParams:[paramDict copy] completion:completion];
}

+ (void)getCouponsCenterOfProductWithCategory:(NSString *)category params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    NSString *categoryId = category.length ? category : @"";
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:categoryId forKey:kKeyStoreCategory];
    
    [[THNCouponManager sharedManager] requestCouponsCenterOfProductWithParams:[paramDict copy] completion:completion];
}

+ (void)getCouponsCenterOfNewsWithParams:(NSDictionary *)params {
    
}

+ (void)getOfficialCouponWithRid:(NSString *)rid completion:(void (^)(BOOL ))completion {
    [[THNCouponManager sharedManager] requestOfficialCouponWithParams:@{kKeyRid: rid} completion:completion];
}

+ (void)getCouponWithRid:(NSString *)rid storeId:(NSString *)storeId completion:(void (^)(BOOL ))completion {
    NSDictionary *params = @{kKeyRid: rid, kKeyStoreRid: storeId};
    [[THNCouponManager sharedManager] requestCouponWithParams:params completion:completion];
}

#pragma mark - network
- (void)requestCouponsCenterOfOfficialWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponsOfficial requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"===== 官方优惠券：%@", [NSString jsonStringWithObject:result.data]);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
    
        completion([self thn_transitionOfficialCouponModelData:result.data[kKeyOfficial]], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

- (void)requestCouponsCenterOfBrandWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponsBrand requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"===== 品牌券：%@", [NSString jsonStringWithObject:result.data]);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        completion([self thn_transitionBrandCouponModelData:result.data[kKeyCoupons]], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

- (void)requestCouponsCenterOfProductWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponsProduct requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"===== 商品券：%@", [NSString jsonStringWithObject:result.data]);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        completion([self thn_transitionProductCouponModelData:result.data[kKeyCoupons]], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

- (void)requestOfficialCouponWithParams:(NSDictionary *)params completion:(void (^)(BOOL ))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLGetOfficialCoupon requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"===== 领取官方券：%@", [NSString jsonStringWithObject:result.data]);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        completion(YES);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(NO);
    }];
}

- (void)requestCouponWithParams:(NSDictionary *)params completion:(void (^)(BOOL ))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLGetCoupon requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"===== 领取优惠券券：%@", [NSString jsonStringWithObject:result.responseDict]);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        completion(YES);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(NO);
    }];
}

#pragma mark - private methods
- (NSArray *)thn_transitionOfficialCouponModelData:(NSArray *)data {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        if (![dict isKindOfClass:[NSNull class]]) {
            THNCouponOfficialModel *model = [[THNCouponOfficialModel alloc] initWithDictionary:dict];
            [modelArr addObject:model];
        }
    }
    
    return modelArr.count ? [modelArr copy] : [NSArray array];
}

- (NSArray *)thn_transitionBrandCouponModelData:(NSArray *)data {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        if (![dict isKindOfClass:[NSNull class]]) {
            THNCouponSharedModel *model = [[THNCouponSharedModel alloc] initWithDictionary:dict];
            [modelArr addObject:model];
        }
    }
    
    return modelArr.count ? [modelArr copy] : [NSArray array];
}

- (NSArray *)thn_transitionProductCouponModelData:(NSArray *)data {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        if (![dict isKindOfClass:[NSNull class]]) {
            THNCouponSingleModel *model = [[THNCouponSingleModel alloc] initWithDictionary:dict];
            [modelArr addObject:model];
        }
    }
    
    return modelArr.count ? [modelArr copy] : [NSArray array];
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
