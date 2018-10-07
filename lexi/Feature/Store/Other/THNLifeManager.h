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

@interface THNLifeManager : NSObject

+ (void)getLifeStoreInfoWithRid:(NSString *)rid
                     completion:(void (^)(THNLifeStoreModel *model, NSError *error))completion;

+ (void)getLifeOrdersCollectWithRid:(NSString *)rid
                         completion:(void (^)(THNLifeOrdersCollectModel *model, NSError *error))completion;

+ (void)getLifeOrdersSaleCollectWithRid:(NSString *)rid
                         completion:(void (^)(THNLifeSaleCollectModel *model, NSError *error))completion;

+ (void)getLifeCashCollectWithRid:(NSString *)rid
                         completion:(void (^)(THNLifeCashCollectModel *model, NSError *error))completion;

@end

