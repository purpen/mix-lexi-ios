//
//  THNCategoriesModel.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCategoriesModel.h"
#import <MJExtension/MJExtension.h>

@implementation THNCategoriesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"category_id": @"id",
             };
}

@end
