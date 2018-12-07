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
 token (过期失效)
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
 是否大B用户
 */
@property (nonatomic, assign) BOOL supplier;

/**
 用户资料
 */
@property (nonatomic, strong) NSDictionary *userData;

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
+ (void)userRegisterWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion;

/**
 退出登录
 */
+ (void)userLogoutCompletion:(void(^)(NSError *error))completion;

/**
 获取用户信息
 */
- (void)getUserProfile:(void (^)(THNResponse *data, NSError *error))completion;

/**
 更新用户信息
 */
- (void)updateUserProfileWithParams:(NSDictionary *)params completion:(void (^)(THNResponse *date, NSError *error))completion;

/**
 使用微信登录注册
 */
+ (void)useWechatLoginCompletion:(void (^)(BOOL isBind, NSString *openId, NSError *error))completion;

/**
 更新生活馆信息

 @param openingUser 是否生活馆用户
 @param supplier 是否大B
 @param storeId 生活馆ID
 */
- (void)updateUserLivingHallStatus:(BOOL)openingUser initSupplier:(BOOL)supplier initStoreId:(NSString *)storeId;

/**
 直接打开登录视图
 */
- (void)openUserLoginController;

+ (instancetype)sharedManager;

@end
