//
//  NSTimer+Addition.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

/**
 关闭定时器
 */
- (void)pauseTimer;

/**
 启动定时器
 */
- (void)resumeTimer;

/**
 添加一个定时器

 @param interval 时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
