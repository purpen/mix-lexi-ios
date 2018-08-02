//
//  NSDictionary+Helper.m
//  lexi
//
//  Created by FLYang on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "NSDictionary+Helper.h"
#import <objc/runtime.h>

@implementation NSDictionary (Helper)

#pragma mark - 根据对象转换为字典
+ (NSDictionary *)getObject:(id)obj {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for (int idx = 0; idx < propsCount; idx ++) {
        objc_property_t prop = props[idx];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [obj valueForKey:propName];
        if (!value) {
            value = [NSNull null];
            
        } else {
            value = [self getObjectInternal:value];
        }
        
        [mutableDict setObject:value forKey:propName];
    }
    
    return mutableDict;
}

+ (id)getObjectInternal:(id)obj {
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *objArr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objArr.count];
        
        for (int idx = 0; idx < objArr.count; idx ++) {
            [arr setObject:[self getObjectInternal:[objArr objectAtIndex:idx]] atIndexedSubscript:idx];
        }
        
        return arr;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objDict = obj;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[objDict count]];
        
        for (NSString *key in objDict.allKeys) {
            [dict setObject:[self getObjectInternal:[objDict objectForKey:key]] forKey:key];
        }
        
        return dict;
    }
    
    return [self getObject:obj];
}

@end
