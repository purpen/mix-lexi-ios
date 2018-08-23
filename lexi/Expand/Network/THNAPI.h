//
//  THNAPI.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNRequest.h"

@interface THNAPI : THNRequest

/**
 <app key>管理后台申请应用，用户登录后，请求返回
 */
- (NSString *)appKey;

/**
 token 授权时使用
 */
- (NSString *)appToken;

/**
 access_token，sign 加密使用
 */
- (NSString *)appSecret;

/**
 当前时间戳
 */
- (NSString *)timestamp;

/**
 随机字符串
 */
- (NSString *)nonceStr;

/**
 GET 请求类

 @param urlString base api url
 @param requestDictionary 请求参数
 @param delegate 代理方法
 @return Request obj
 */
+ (instancetype)getWithUrlString:(NSString *)urlString
               requestDictionary:(NSDictionary *)requestDictionary
                        delegate:(id)delegate;

/**
 POST 请求类
 
 @param urlString base api url
 @param requestDictionary 请求参数
 @param delegate 代理方法
 @return Request obj
 */
+ (instancetype)postWithUrlString:(NSString *)urlString
                requestDictionary:(NSDictionary *)requestDictionary
                         delegate:(id)delegate;

/**
 上传文件的请求(POST请求)
 
 @param urlString base api url
 @param requestDictionary 请求参数
 @param delegate 代理方法
 @return Request obj
 */
+ (instancetype)uploadWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                           delegate:(id)delegate;

/**
 删除的请求(DELETE 请求)
 
 @param urlString base api url
 @param requestDictionary 请求参数
 @param delegate 代理方法
 @return Request obj
 */
+ (instancetype)deleteWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                           delegate:(id)delegate;

@end
