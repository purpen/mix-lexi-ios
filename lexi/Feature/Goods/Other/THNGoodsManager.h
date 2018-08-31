//
//  THNGoodsManager.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+EnumManagement.h"

@interface THNGoodsManager : NSObject

/**
 获取个人中心商品数据
 
 @param type 类型
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getUserCenterProductsWithType:(THNUserCenterGoodsType)type
                               params:(NSDictionary *)params
                           completion:(void (^)(NSArray *goodsData, NSInteger count, NSError *error))completion;

/**
 获取分类商品数据

 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getCategoryProductsWithParams:(NSDictionary *)params
                           completion:(void (^)(NSArray *goodsData, NSInteger count, NSError *error))completion;

/**
 获取商品数量

 @param type 商品类型
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getProductCountWithType:(THNGoodsListViewType)type
                         params:(NSDictionary *)params
                     completion:(void (^)(NSInteger count, NSError *error))completion;

/**
 获取分类列表

 @param pid 父 id (获取全部时为 0)
 @param completion 完成回调
 */
+ (void)getCategoryDataWithPid:(NSInteger)pid
                    completion:(void (^)(NSArray *categoryData, NSError *error))completion;

@end
