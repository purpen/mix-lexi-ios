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
 获取商品数据
 
 @param type 类型
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getProductsWithType:(THNProductsType)type
                     params:(NSDictionary *)params
                 completion:(void (^)(NSArray *goodsData, NSError *error))completion;

@end
