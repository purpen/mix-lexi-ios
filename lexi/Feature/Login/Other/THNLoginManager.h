//
//  THNLoginManger.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNResponse.h"
#import "THNUserDataModel.h"

typedef NS_ENUM(NSUInteger, THNLoginModeType) {
    THNLoginModeTypePassword,   // 密码登录
    THNLoginModeTypeVeriDynamic // 动态码登录
};

@interface THNLoginManager : NSObject <NSCoding>

/**
 令牌(过期失效)
 */
@property (nonatomic, copy) NSString *token;

/**
 过期时间
 */
@property (nonatomic, copy) NSString *expirationTime;

/**
 登录时间
 */
@property (nonatomic, copy) NSString *loginTime;

/**
 是否是第一次登录（判断是否需要设置用户信息）
 0:不是、 1:是
 */
@property (nonatomic, assign) NSInteger firstLogin;

/**
 登录用户 ID
 */
@property (nonatomic, copy) NSString *userId;

/**
 店铺ID
 */
@property (nonatomic, copy) NSString *storeRid;

/**
 是否小B用户
 */
@property (nonatomic, assign) BOOL openingUser;

/**
 用户资料
 */
@property (nonatomic, strong) NSDictionary *userData;

+ (instancetype)sharedManager;

/**
 是否登录状态

 @return YES：已登录 / NO：未登录
 */
+ (BOOL)isLogin;

/**
 是否是第一次登录（判断是否需要设置用户信息）

 @return 0:不是、 1:是
 */
+ (BOOL)isFirstLogin;

/**
 获取用户信息
 */
- (void)getUserProfile:(void (^)(THNResponse *, NSError *))completion;

/**
 保存登录信息
 */
- (void)saveLoginInfo;

/**
 清除登录信息
 */
- (void)clearLoginInfo;

/**
 登录
 
 @param params 请求参数
 @param type 登录方式
 @param completion 完成操作
 */
+ (void)userLoginWithParams:(NSDictionary *)params
                   modeType:(THNLoginModeType)type
                 completion:(void(^)(THNResponse *result, NSError *error))completion;

/**
 注册

 @param params 请求参数
 @param completion 完成操作
 */
+ (void)userRegisterWithParams:(NSDictionary *)params
                    completion:(void (^)(NSError *error))completion;

/**
 退出登录
 */
+ (void)userLogoutCompletion:(void(^)(NSError *error))completion;

@end
