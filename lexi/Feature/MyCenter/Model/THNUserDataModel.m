//
//  THNUserDataModel.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNUserDataModel.h"
#import "NSString+Helper.h"

@implementation THNUserDataModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if ([oldValue isEqual:[NSNull null]]) {
            return @"";
        }
    }

    return oldValue;
}

@end
