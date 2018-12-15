//
//  THNLifeManager.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeManager.h"
#import <MJExtension/MJExtension.h>
#import "THNAPI.h"
#import "NSString+Helper.h"
#import "SVProgressHUD+Helper.h"
#import "THNTextConst.h"
#import "THNConst.h"
#import "THNMarco.h"

/// api
static NSString *const kURLLifeStore            = @"/store/life_store";
static NSString *const kURLOrdersCollect        = @"/stats/life_orders_collect";
static NSString *const kURLTransactionsRecord   = @"/stats/life_orders/transactions";
static NSString *const kURLOrdersSaleCollect    = @"/stats/life_orders_sale_collect";
static NSString *const kURLOrders               = @"/stats/life_orders/";
static NSString *const kURLCashCollect          = @"/stats/life_cash_collect";
static NSString *const kURLLifeOrder            = @"/orders/life_orders";
static NSString *const kURLCashRecent           = @"/stats/life_cash_recent";
static NSString *const kURLCash                 = @"/pay_account/life_cash_money";
static NSString *const kURLCashBill             = @"/stats/life_orders/statements";
static NSString *const kURLCashBillDetail       = @"/stats/life_orders/statement_items";
/// key
static NSString *const kKeyRid      = @"rid";
static NSString *const kKeyStoreRid = @"store_rid";
static NSString *const kKeyRecordId = @"record_id";
static NSString *const kKeyOpenId   = @"open_id";
static NSString *const kKeyItems    = @"items";

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

+ (void)getLifeOrdersSaleDetailCollectWithRid:(NSString *)rid storeRid:(NSString *)storeRid completion:(void (^)(NSArray *, NSError *))completion {
    NSDictionary *paramsDict = @{kKeyRid: rid,
                                 kKeyStoreRid: storeRid};
    
    [[THNLifeManager sharedManager] requestLifeOrdersSaleDetailCollectWithParams:paramsDict completion:completion];
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

+ (void)getLifeCashWithStoreRid:(NSString *)storeId openId:(NSString *)openId completion:(void (^)(NSError *))completion {
    NSDictionary *paramsDict = @{kKeyOpenId: openId,
                                 kKeyStoreRid: storeId};
    
    [[THNLifeManager sharedManager] requestLifeCashWithParams:paramsDict completion:completion];
}

#pragma mark - network
// 馆主信息
- (void)requestLifeStoreInfoWithRid:(NSString *)rid completion:(void (^)(THNLifeStoreModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLLifeStore requestDictionary:@{kKeyRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        THNLifeStoreModel *model = [THNLifeStoreModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 订单汇总
- (void)requestLifeOrdersCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeOrdersCollectModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLOrdersCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        THNLifeOrdersCollectModel *model = [THNLifeOrdersCollectModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 订单记录
- (void)requestLifeOrderRecordWithParams:(NSDictionary *)params completion:(void (^)(THNLifeOrderDataModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLLifeOrder requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"生活馆订单列表：%@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        THNLifeOrderDataModel *model = [THNLifeOrderDataModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 收益汇总
- (void)requestLifeOrdersSaleCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeSaleCollectModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLOrdersSaleCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        THNLifeSaleCollectModel *model = [THNLifeSaleCollectModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 收益详情
- (void)requestLifeOrdersSaleDetailCollectWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kURLOrders, params[kKeyRid]];
    THNRequest *request = [THNAPI getWithUrlString:urlStr requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        if (![result.data[kKeyItems] isKindOfClass:[NSNull class]]) {
            completion(result.data[kKeyItems], nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 交易记录
- (void)requestLifeTransactionsRecordWithParams:(NSDictionary *)params completion:(void (^)(THNTransactionsDataModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLTransactionsRecord requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        THNTransactionsDataModel *model = [THNTransactionsDataModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 提现
- (void)requestLifeCashWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLCash requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
    
        completion(nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(error);
    }];
}

// 提现汇总
- (void)requestLifeCashCollectWithRid:(NSString *)rid completion:(void (^)(THNLifeCashCollectModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCashCollect requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        THNLifeCashCollectModel *model = [THNLifeCashCollectModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 最近一笔提现
- (void)requestLifeCashRecentWithRid:(NSString *)rid completion:(void (^)(CGFloat , NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCashRecent requestDictionary:@{kKeyStoreRid: rid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        completion([result.data[@"actual_account_amount"] floatValue], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(-1.0, error);
    }];
}

// 对账单列表
- (void)requestLifeCashBillWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCashBill requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        if (![result.data[@"statements"] isKindOfClass:[NSNull class]]) {
            NSDictionary *dict = result.data[@"statements"];
            completion(dict, nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        completion(nil, error);
    }];
}

// 对账单详情
- (void)requestLifeCashBillDetailWithParams:(NSDictionary *)params completion:(void (^)(THNLifeCashBillModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCashBillDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        if (![result.data[@"life_cash_record_dict"] isKindOfClass:[NSNull class]]) {
            THNLifeCashBillModel *model = [THNLifeCashBillModel mj_objectWithKeyValues:result.data[@"life_cash_record_dict"]];
            completion(model, nil);
        }

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
