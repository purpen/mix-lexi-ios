//
//  THNLifeManager.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNLifeStoreModel.h"
#import "THNLifeOrdersCollectModel.h"
#import "THNLifeSaleCollectModel.h"
#import "THNLifeCashCollectModel.h"
#import "THNTransactionsDataModel.h"
#import "THNLifeOrderDataModel.h"

@interface THNLifeManager : NSObject

// 馆主信息
+ (void)getLifeStoreInfoWithRid:(NSString *)rid
                     completion:(void (^)(THNLifeStoreModel *model, NSError *error))completion;

// 订单汇总
+ (void)getLifeOrdersCollectWithRid:(NSString *)rid
                         completion:(void (^)(THNLifeOrdersCollectModel *model, NSError *error))completion;

// 交易记录
+ (void)getLifeTransactionsRecordWithRid:(NSString *)rid
                                  params:(NSDictionary *)params
                              completion:(void (^)(THNTransactionsDataModel *model, NSError *error))completion;

// 订单记录
+ (void)getLifeOrderRecordWithRid:(NSString *)rid
                           params:(NSDictionary *)params
                       completion:(void (^)(THNLifeOrderDataModel *model, NSError *error))completion;

// 收益汇总
+ (void)getLifeOrdersSaleCollectWithRid:(NSString *)rid
                             completion:(void (^)(THNLifeSaleCollectModel *model, NSError *error))completion;

// 提现汇总
+ (void)getLifeCashCollectWithRid:(NSString *)rid
                       completion:(void (^)(THNLifeCashCollectModel *model, NSError *error))completion;

// 对账单列表
+ (void)getLifeCashBillWithRid:(NSString *)rid
                        params:(NSDictionary *)params
                    completion:(void (^)(NSError *error))completion;

// 最近一笔提现金额
+ (void)getLifeCashRecentWithRid:(NSString *)rid
                      completion:(void (^)(CGFloat price, NSError *error))completion;

@end

