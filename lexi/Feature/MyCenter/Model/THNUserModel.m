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
    return @{
             @"user_id": @"ID"
             };
}

@end
