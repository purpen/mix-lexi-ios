//
//  THNSaveTool.h
//  lexi
//
//  Created by HongpingRao on 2018/8/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNSaveTool : NSObject

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;

+ (void)setValue:(id)value forKey:(NSString *)defaultName;

+ (id)valueForKey:(NSString *)defaultName;

+ (void)removeObjectForKey:(NSString*)key;

+ (void)clearAll;

@end
