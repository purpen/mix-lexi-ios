//
//  THNResponse.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNResponse : NSObject

/**
 响应体
 */
@property (nonatomic, strong) id            responseDict;

/**
 数据内容
 */
@property (nonatomic, strong) NSDictionary  *data;

/**
 请求状态
 */
@property (nonatomic, strong) NSDictionary  *status;
@property (nonatomic, assign) NSInteger     statusCode;
@property (nonatomic, assign) NSString      *statusMessage;

/**
 成功状态
 */
@property (nonatomic, assign) NSInteger     success;

/**
 请求是否成功
 */
- (BOOL)isSuccess;

/**
 是否有数据
 */
- (BOOL)hasData;

- (instancetype)initWithResponseObject:(id)responseObject;

@end
