//
//  THNGoodsManager.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+EnumManagement.h"
#import "THNGoodsModel.h"
#import "THNStoreModel.h"
#import "THNSkuModel.h"
#import "THNFreightModel.h"
#import "THNCartModel.h"

@interface THNGoodsManager : NSObject

/**
 获取商品全部数据

 @param goodsId 商品 id
 @param completion 完成回调
 */
+ (void)getProductAllDetailWithId:(NSString *)goodsId completion:(void (^)(THNGoodsModel *model, NSError *error))completion;

/**
 获取商品 SKU 信息

 @param goodsId 商品 id
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getProductSkusInfoWithId:(NSString *)goodsId
                          params:(NSDictionary *)params
                      completion:(void (^)(THNSkuModel *model, NSError *error))completion;

/**
 获取相似的商品

 @param goodsId 商品 id
 @param completion 完成回调
 */
+ (void)getSimilarGoodsWithGoodsId:(NSString *)goodsId completion:(void (^)(NSArray *goodsData, NSError *error))completion;

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
 获取各栏目的商品数据
 
 @param type 栏目类型
 @param params 请求参数
 @param completion 完成回调
 */
+ (void)getColumnProductsWithListType:(THNGoodsListViewType)type
                               params:(NSDictionary *)params
                           completion:(void (^)(NSArray *goodsData, NSInteger count, NSError *error))completion;

/**
 获取各栏目的浏览记录

 @param type 栏目类型
 @param params 请求参数
 @param completion 完成回调
 */
+ (void)getColumnRecordWithListType:(THNGoodsListViewType)type
                             params:(NSDictionary *)params
                         completion:(void (^)(NSArray *usersData, NSInteger count, NSError *error))completion;

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
 获取官方平台店铺信息

 @param storeId 店铺 id
 @param completion 完成回调
 */
+ (void)getOfficialStoreInfoWithId:(NSString *)storeId completion:(void (^)(THNStoreModel *model, NSError *error))completion;

/**
 获取分类列表

 @param pid 父 id (获取全部时为 0)
 @param completion 完成回调
 */
+ (void)getCategoryDataWithPid:(NSInteger)pid
                    completion:(void (^)(NSArray *categoryData, NSError *error))completion;

/**
 获取运费模版信息

 @param rid 模版 id
 @param goodsId 商品
 @param storeId 店铺
 @param completion 完成回调
 */
+ (void)getFreightTemplateDataWithRid:(NSString *)rid
                              goodsId:(NSString *)goodsId
                              storeId:(NSString *)storeId
                           completion:(void (^)(THNFreightModel *model, NSError *error))completion;

/**
 获取喜欢商品的用户列表

 @param goodsId 商品 id
 @param params 附加参数
 @param completion 完成回调
 */
+ (void)getLikeGoodsUserDataWithGoodsId:(NSString *)goodsId
                                 params:(NSDictionary *)params
                             completion:(void (^)(NSArray *userData, NSError *error))completion;

/**
 商品添加到心愿单
 
 @param rids 商品 sku id
 @param completion 完成回调
 */
+ (void)postAddGoodsToWishListWithRids:(NSArray *)rids completion:(void (^)(NSError *error))completion;

/**
 商品添加到购物车

 @param params sku 信息
 @param completion 完成回调
 */
+ (void)postAddGoodsToCartWithSkuParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion;

/**
 获取购物车的商品
 
 @param completion 完成回调
 */
+ (void)getCartGoodsCompletion:(void (^)(NSArray *cartData, NSError *error))completion;

/**
 获取购物车的商品数量
 
 @param completion 完成回调
 */
+ (void)getCartGoodsCountCompletion:(void (^)(NSInteger goodsCount, NSError *error))completion;

/**
 删除购物车的商品
 
 @param skuRids 商品 sku id
 @param completion 完成回调
 */
+ (void)postRemoveCartGoodsWithSkuRids:(NSArray *)skuRids completion:(void (^)(NSError *error))completion;

/**
 更新购物车商品数量

 @param skuId id
 @param count 数量
 @param completion 完成回调
 */
+ (void)putCartGoodsCountWithSkuId:(NSString *)skuId count:(NSInteger)count completion:(void (^)(NSError *error))completion;

@end
