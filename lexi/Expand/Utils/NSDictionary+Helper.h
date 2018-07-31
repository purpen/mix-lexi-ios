//
//  NSDictionary+Helper.h
//  lexi
//
//  Created by FLYang on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

/**
 根据对象转换为字典

 @param obj 对象
 @return 转换后的字典
 */
+ (NSDictionary *)getObject:(id)obj;

@end
