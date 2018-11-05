//
//  THNCouponManager.h
//  lexi
//
//  Created by FLYang on 2018/11/1.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNCouponManager : NSObject

/**
 领券中心-获取官方优惠券

 @param userId 用户编号，app没登录不填，登录后填写
 */
+ (void)getCouponsCenterOfOfficialWithUserId:(NSString *)userId
                                  completion:(void (^)(NSArray *data, NSError *error))completion;

/**
 领券中心-品牌优惠券(同享券)
 
 @param category 分类id (0=推荐)
 @param params 附加参数
 */
+ (void)getCouponsCenterOfBrandWithCategory:(NSString *)category
                                     params:(NSDictionary *)params
                                 completion:(void (^)(NSArray *data, NSError *error))completion;

/**
 领券中心-商品优惠券(单享券)
 
 @param category 分类id (0=推荐)
 @param params 附加参数
 */
+ (void)getCouponsCenterOfProductWithCategory:(NSString *)category
                                       params:(NSDictionary *)params
                                   completion:(void (^)(NSArray *data, NSError *error))completion;

/**
 领券中心-新闻动态

 @param params 附加参数
 */
+ (void)getCouponsCenterOfNewsWithParams:(NSDictionary *)params;

/**
 用户领取官方优惠券
 
 @param rid 优惠券 code
 @param completion 领取结果回调
 */
+ (void)getOfficialCouponWithRid:(NSString *)rid
                      completion:(void (^)(BOOL success))completion;

/**
 用户领取优惠券
 
 @param rid 优惠券code
 @param storeId 店铺rid
 @param completion 领取结果回调
 */
+ (void)getCouponWithRid:(NSString *)rid
                 storeId:(NSString *)storeId
              completion:(void (^)(BOOL success))completion;

@end
