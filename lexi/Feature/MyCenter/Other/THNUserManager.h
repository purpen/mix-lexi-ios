//
//  THNUserManager.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNUserModel.h"
#import "NSObject+EnumManagement.h"

@interface THNUserManager : NSObject

/**
 获取自己的个人中心信息
 */
+ (void)getUserCenterCompletion:(void (^)(THNUserModel *model, NSError *error))completion;

/**
 获取用户关注的设计馆
 */
+ (void)getUserFollowStoreWithParams:(NSDictionary *)param
                          completion:(void (^)(NSArray *storesData, NSError *error))completion;

/**
 获取自己喜欢的橱窗
 */
+ (void)getUserLikedWindowWithParams:(NSDictionary *)params
                          completion:(void (^)(NSArray *windowData, NSError *error))completion;

/**
 获取自己的优惠券
 */
+ (void)getUserCouponDataWithType:(THNUserCouponType)type
                           params:(NSDictionary *)params
                       completion:(void (^)(NSArray *couponData, NSError *error))completion;

/**
 获取自己的商家优惠券列表
 */
+ (void)getUserBrandCouponWithParams:(NSDictionary *)params
                          completion:(void (^)(NSArray *couponData, NSError *error))completion;

/**
 获取自己的官方优惠券列表
 */
+ (void)getUserOfficialCouponWithParams:(NSDictionary *)params
                             completion:(void (^)(NSArray *couponData, NSError *error))completion;

/**
 获取自己的失效优惠券列表
 */
+ (void)getUserFailCouponWithParams:(NSDictionary *)params
                         completion:(void (^)(NSArray *couponData, NSError *error))completion;

@end
