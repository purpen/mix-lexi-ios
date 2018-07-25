//
//  THNLoginManger.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNLoginManager : NSObject <NSCoding>

/**
 是否登录状态
 */
//@property (nonatomic, assign) BOOL   isLogin;

/**
 令牌(过期失效)
 */
@property (nonatomic, copy) NSString *token;

/**
 API 接口用户授权
 */
@property (nonatomic, copy) NSString *accessToken;

/**
 商家店铺 id
 */
@property (nonatomic, copy) NSString *storeRid;

/**
 API 接口验证序号(公钥)
 */
@property (nonatomic, copy) NSString *appKey;

/**
 过期时间
 */
@property (nonatomic, copy) NSString *expirationTime;

/**
 登录时间
 */
@property (nonatomic, copy) NSString *loginTime;

+ (instancetype)sharedManager;

/**
 是否登录状态

 @return YEX：已登录 / NO：未登录
 */
+ (BOOL)isLogin;

/**
 保存登录信息
 */
- (void)saveLoginInfo;

/**
 清除登录信息
 */
- (void)clearLoginInfo;

/**
 商家登录后台

 @param params 请求参数
 @param completion 完成操作
 */
- (void)businessLoginWithParams:(NSDictionary *)params
                     completion:(void(^)(NSError *error))completion;

/**
 商家退出登录
 */
- (void)businessLogoutCompletion:(void(^)(NSError *error))completion;

@end
