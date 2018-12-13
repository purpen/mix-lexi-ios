//
//  THNUserModel.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserModel.h"

@implementation THNUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"user_id": @"ID"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if ([oldValue isEqual:[NSNull null]]) {
            return @"";
        }
    }
    
    return oldValue;
}

@end
