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
 错误内容
 */
@property (nonatomic, strong) NSError       *error;

/**
 错误提示信息
 */
@property (nonatomic, copy) NSString        *errorMessage;

/**
 状态码
 */
@property (nonatomic, assign) NSInteger     statusCode;

/**
 响应头
 */
@property (nonatomic, strong) NSDictionary  *headers;

/**
 响应体
 */
@property (nonatomic, strong) id            responseObject;

@end
