//
//  THNGoodsManager.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, THNProductsType) {
    THNProductsTypeLikedGoods = 0,  // 喜欢的商品
    THNProductsTypeBrowses,         // 最近查看
    THNProductsTypeWishList,        // 心愿单
    THNProductsTypeStore            // 设计馆商品
};

@interface THNGoodsManager : NSObject

/**
 获取个人中心商品数据
 
 @param type 类型
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getUserCenterProductsWithType:(THNProductsType)type
                               params:(NSDictionary *)params
                           completion:(void (^)(NSArray *goodsData, NSError *error))completion;

/**
 获取分类商品数据

 @param categoryId 分类 id
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getCategoryProductsWithId:(NSInteger)categoryId
                           params:(NSDictionary *)params
                       completion:(void (^)(NSArray *goodsData, NSInteger count, NSError *error))completion;

/**
 根据筛选条件获取商品

 @param params 筛选条件
 @param completion 完成回调
 */
+ (void)getScreenProductsWithParams:(NSDictionary *)params
                         completion:(void (^)(NSDictionary *data, NSError *error))completion;

/**
 获取分类列表

 @param pid 父 id (获取全部时为 0)
 @param completion 完成回调
 */
+ (void)getCategoryDataWithPid:(NSInteger)pid
                    completion:(void (^)(NSArray *categoryData, NSError *error))completion;

@end
