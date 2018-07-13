//
//  NSString+Helper.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

/**
 判断是否为正确的邮箱

 @return 返回YES为正确的邮箱，NO为不是邮箱
 */
- (BOOL)isValidateEmail;

/**
 判断是否为正确的手机号

 @return 返回YES为手机号，NO为不是手机号
 */
- (BOOL)checkTel;

/**
 清空字符串中的空白字符

 @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;

/**
 是否空字符串

 @return 如果字符串为nil或者长度为0返回YES
 */
- (BOOL)isEmptyString;

/**
 返回沙盒中的文件路径

 @return 返回当前字符串对应在沙盒中的完整文件路径
 */
+ (NSString *)stringWithDocumentsPath:(NSString *)path;

/**
 写入系统偏好

 @param key 写入键值
 */
- (void)saveToNSDefaultsWithKey:(NSString *)key;

/**
 根据数字返回性别
 */
+ (NSString*)getSexByNum:(NSNumber*)num;

/**
 转换时间戳格式
 
 @param time 时间戳
 @return 字符串时间
 */
+ (NSString *)convertTimestamp:(NSInteger)time;

/**
 获取当前的时间戳
 */
+ (NSString *)getTimestamp;

/**
 时间戳对比

 @param startTime 开始时间
 @param endTime 结束时间
 @return 间隔时间
 */
+ (NSTimeInterval)comparisonStartTimestamp:(NSString *)startTime endTimestamp:(NSString *)endTime;

/**
 数据转json格式

 @param object 数据对象
 @return json字符串
 */
+ (NSString *)jsonStringWithObject:(id)object;

/**
 随机生成指定长度的字符串

 @param len 长度
 @return 随机字符串
 */
+ (NSString *)randomStringWithLength:(NSInteger)len;

@end
