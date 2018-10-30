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
    if ([property.name isEqualToString:@"street_address"]) {
        if ([oldValue isKindOfClass:[NSNull class]]) {
            return @"";
        }
    }
    
    if ([property.name isEqualToString:@"mail"]) {
        if ([oldValue isKindOfClass:[NSNull class]]) {
            return @"";
        }
    }
    
    return oldValue;
}

@end
