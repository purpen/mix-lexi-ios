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
static NSString *const kURLTransactionsRecord   = @"/stats/life_orders/transactions";
static NSString *const kURLOrdersSaleCollect    = @"/stats/life_orders_sale_collect";
static NSString *const kURLCashCollect          = @"/stats/life_cash_collect";
static NSString *const kURLLifeOrder            = @"/orders/life_orders";
static NSString *const kURLCashRecent           = @"/stats/life_cash_recent";
static NSString *const kURLCashBill             = @"/stats/life_orders/statements";
static NSString *const kURLCashBillDetail       = @"/stats/life_orders/statement_items";
/// key
static NSString *const kKeyRid      = @"rid";
static NSString *const kKeyStoreRid = @"store_rid";
static NSString *const kKeyRecordId = @"record_id";

@implementation THNLifeManager

#pragma mark - public methods
+ (void)getLifeStoreInfoWithRid:(NSString *)rid completion:(void (^)(THNLifeStoreModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeStoreInfoWithRid:rid completion:completion];
}

+ (void)getLifeOrdersCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeOrdersCollectModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeOrdersCollectWithRid:rid completion:completion];
}

+ (void)getLifeTransactionsRecordWithRid:(NSString *)rid params:(NSDictionary *)params completion:(void (^)(THNTransactionsDataModel *, NSError *))completion {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:rid forKey:kKeyStoreRid];
    
    [[THNLifeManager sharedManager] requestLifeTransactionsRecordWithParams:paramDict completion:completion];
}

+ (void)getLifeOrderRecordWithRid:(NSString *)rid params:(NSDictionary *)params completion:(void (^)(THNLifeOrderDataModel *, NSError *))completion {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:rid forKey:kKeyStoreRid];
    
    [[THNLifeManager sharedManager] requestLifeOrderRecordWithParams:paramDict completion:completion];
}

+ (void)getLifeOrdersSaleCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeSaleCollectModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeOrdersSaleCollectWithRid:rid completion:completion];
}

+ (void)getLifeCashCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeCashCollectModel *, NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeCashCollectWithRid:rid completion:completion];
}

+ (void)getLifeCashRecentWithRid:(NSString *)rid completion:(void (^)(CGFloat , NSError *))completion {
    [[THNLifeManager sharedManager] requestLifeCashRecentWithRid:rid completion:completion];
}

+ (void)getLifeCashBillWithRid:(NSString *)rid params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:rid forKey:kKeyStoreRid];
    
    [[THNLifeManager sharedManager] requestLifeCashBillWithParams:paramDict completion:completion];
}

+ (void)getLifeCashBillDetailWithRid:(NSString *)rid recordId:(NSString *)recordId completion:(void (^)(THNLifeCashBillModel *, NSError *))completion {
    
    [[THNLifeManager sharedManager] requestLifeCashBillDetailWithParams:@{kKeyStoreRid: rid, kKeyRecordId: recordId}
                                                             completion:completion];
}

#pragma mark - network
// 馆主信息
- (void)requestLifeStoreInfoWithRid:(NSString *)rid completion:(void (^)(THNLifeStoreModel *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLLifeStore requestDictionary:@{kKeyRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
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
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLOrdersCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        
        THNLifeOrdersCollectModel *model = [THNLifeOrdersCollectModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆订单汇总：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 订单记录
- (void)requestLifeOrderRecordWithParams:(NSDictionary *)params completion:(void (^)(THNLifeOrderDataModel *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLLifeOrder requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        THNLog(@"==== 生活馆订单记录：%@", [NSString jsonStringWithObject:result.responseDict]);
        THNLifeOrderDataModel *model = [THNLifeOrderDataModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 收益汇总
- (void)requestLifeOrdersSaleCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeSaleCollectModel *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLOrdersSaleCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        
        THNLifeSaleCollectModel *model = [THNLifeSaleCollectModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆收益汇总：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 交易记录
- (void)requestLifeTransactionsRecordWithParams:(NSDictionary *)params completion:(void (^)(THNTransactionsDataModel *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLTransactionsRecord requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        THNLog(@"==== 生活馆交易记录：%@", [NSString jsonStringWithObject:result.responseDict]);
        THNTransactionsDataModel *model = [THNTransactionsDataModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 提现汇总
- (void)requestLifeCashCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeCashCollectModel *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLCashCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        
        THNLifeCashCollectModel *model = [THNLifeCashCollectModel mj_objectWithKeyValues:result.data];
        THNLog(@"==== 生活馆提现汇总：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 最近一笔提现
- (void)requestLifeCashRecentWithRid:(NSString *)rid completion:(void (^)(CGFloat , NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLCashRecent requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        THNLog(@"==== 生活馆最近一笔提现：%@", [NSString jsonStringWithObject:result.responseDict]);
        completion([result.data[@"actual_account_amount"] floatValue], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(-1.0, error);
    }];
}

// 对账单列表
- (void)requestLifeCashBillWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLCashBill requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        THNLog(@"==== 对账单列表：%@", [NSString jsonStringWithObject:result.responseDict]);
        if (![result.data[@"statements"] isKindOfClass:[NSNull class]]) {
            NSDictionary *dict = result.data[@"statements"];
            completion(dict, nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

// 对账单详情
- (void)requestLifeCashBillDetailWithParams:(NSDictionary *)params completion:(void (^)(THNLifeCashBillModel *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLCashBillDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (![result hasData]) {
            [SVProgressHUD showErrorWithStatus:kTextRequestInfo];
            return ;
        }
        THNLog(@"==== 对账单详情：%@", [NSString jsonStringWithObject:result.responseDict]);
        if (![result.data[@"life_cash_record_dict"] isKindOfClass:[NSNull class]]) {
            THNLifeCashBillModel *model = [THNLifeCashBillModel mj_objectWithKeyValues:result.data[@"life_cash_record_dict"]];
            completion(model, nil);
        }

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
