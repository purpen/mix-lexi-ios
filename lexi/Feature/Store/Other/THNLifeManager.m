//
//  THNLifeManager.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeManager.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNAPI.h"
#import "NSString+Helper.h"
#import "THNTextConst.h"
#import "THNConst.h"
#import "THNMarco.h"

/// api
static NSString *const kURLLifeStore            = @"/store/life_store";
static NSString *const kURLOrdersCollect        = @"/stats/life_orders_collect";
static NSString *const kURLOrdersSaleCollect    = @"/stats/life_orders_sale_collect";
static NSString *const kURLCashCollect          = @"/stats/life_cash_collect";
/// key
static NSString *const kKeyRid      = @"rid";
static NSString *const kKeyStoreRid = @"store_rid";

@implementation THNLifeManager

#pragma mark - public methods
+ (void)getLifeStoreInfoWithRid:(NSString *)rid completion:(void (^)(THNLifeStoreModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeStoreInfoWithRid:rid completion:completion];
}

+ (void)getLifeOrdersCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeOrdersCollectModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeOrdersCollectWithRid:rid completion:completion];
}

+ (void)getLifeOrdersSaleCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeSaleCollectModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeOrdersSaleCollectWithRid:rid completion:completion];
}

+ (void)getLifeCashCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeCashCollectModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeCashCollectWithRid:rid completion:completion];
}

#pragma mark - network
// 馆主信息
- (void)requestLifeStoreInfoWithRid:(NSString *)rid completion:(void (^)(THNLifeStoreModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLLifeStore requestDictionary:@{kKeyRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRegisterError];
            return ;
        }
        
        THNLifeStoreModel *model = [THNLifeStoreModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆信息：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 订单汇总
- (void)requestLifeOrdersCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeOrdersCollectModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLOrdersCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRegisterError];
            return ;
        }
        
        THNLifeOrdersCollectModel *model = [THNLifeOrdersCollectModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆订单汇总：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 收益汇总
- (void)requestLifeOrdersSaleCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeSaleCollectModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLOrdersSaleCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRegisterError];
            return ;
        }
        
        THNLifeSaleCollectModel *model = [THNLifeSaleCollectModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆收益汇总：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 提现汇总
- (void)requestLifeCashCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeCashCollectModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCashCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRegisterError];
            return ;
        }
        
        THNLifeCashCollectModel *model = [THNLifeCashCollectModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆提现汇总：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
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
