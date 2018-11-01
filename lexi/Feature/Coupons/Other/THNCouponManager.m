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
#import "THNCouponModel.h"

static NSString *kURLCouponsOfficial    = @"/market/official_coupons/recommend";
static NSString *kURLCouponsBrand       = @"/market/coupon_center_shared";
static NSString *kURLCouponsProduct     = @"/market/coupon_center_single";
/// key
static NSString *kKeyRid            = @"rid";
static NSString *kKeyStoreCategory  = @"store_category";
static NSString *kKeyOfficial       = @"official_coupons";

@implementation THNCouponManager

+ (void)getCouponsCenterOfOfficialWithUserId:(NSString *)userId completion:(void (^)(NSArray *, NSError *))completion {
    NSString *rid = userId.length ? userId : @"";
    
    [[THNCouponManager sharedManager] requestCouponsCenterOfOfficialWithParams:@{kKeyRid: rid} completion:completion];
}

+ (void)getCouponsCenterOfBrandWithCategory:(NSString *)category params:(NSDictionary *)params {
    NSString *categoryId = category.length ? category : @"";
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:categoryId forKey:kKeyRid];
    
    [[THNCouponManager sharedManager] requestCouponsCenterOfBrandWithParams:[paramDict copy]];
}

+ (void)getCouponsCenterOfProductWithCategory:(NSString *)category params:(NSDictionary *)params {
    NSString *categoryId = category.length ? category : @"";
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:categoryId forKey:kKeyRid];
    
    [[THNCouponManager sharedManager] requestCouponsCenterOfProductWithParams:[paramDict copy]];
}

+ (void)getCouponsCenterOfNewsWithParams:(NSDictionary *)params {
    
}

#pragma mark - network
- (void)requestCouponsCenterOfOfficialWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponsOfficial requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"===== 官方优惠券：%@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
    
        completion([self thn_transitionCouponModelData:result.data[kKeyOfficial]], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

- (void)requestCouponsCenterOfBrandWithParams:(NSDictionary *)params {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponsBrand requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"===== 品牌券：%@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestCouponsCenterOfProductWithParams:(NSDictionary *)params {
    THNRequest *request = [THNAPI getWithUrlString:kURLCouponsProduct requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"===== 商品券：%@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
- (NSArray *)thn_transitionCouponModelData:(NSArray *)data {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        if (![dict isKindOfClass:[NSNull class]]) {
            THNCouponModel *model = [THNCouponModel mj_objectWithKeyValues:dict];
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
