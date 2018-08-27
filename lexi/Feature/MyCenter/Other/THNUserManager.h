//
//  THNUserManager.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNUserModel.h"

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

@end
