//
//  THNUserManager.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNUserModel.h"

typedef NS_ENUM(NSInteger, THNProductsType) {
    THNProductsTypeLikedGoods = 0,  // 喜欢的商品
    THNProductsTypeBrowses,         // 最近查看
    THNProductsTypeWishList,        // 心愿单
};

@interface THNUserManager : NSObject

/**
 获取自己的个人中心信息
 */
+ (void)getUserCenterCompletion:(void (^)(THNUserModel *model, NSError *error))completion;

/**
 获取商品数据

 @param type 类型
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getProductsWithType:(THNProductsType)type
                     params:(NSDictionary *)params
                 completion:(void (^)(NSArray *goodsData, NSError *error))completion;

/**
 获取自己喜欢的商品
 */
+ (void)getUserLikedGoodsWithParams:(NSDictionary *)params
                         completion:(void (^)(NSArray *goodsData, NSError *error))completion;

/**
 获取自己喜欢的橱窗
 */
+ (void)getUserLikedWindowWithParams:(NSDictionary *)params
                          completion:(void (^)(NSArray *windowData, NSError *error))completion;

/**
 获取自己浏览的记录
 */
+ (void)getUserBrowsesWithParams:(NSDictionary *)params
                      completion:(void (^)(NSArray *browsesData, NSError *error))completion;

/**
 获取自己的心愿单
 */
+ (void)getUserWishListWithParams:(NSDictionary *)params
                       completion:(void (^)(NSArray *wishListData, NSError *error))completion;

@end
