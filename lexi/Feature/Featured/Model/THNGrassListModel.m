//
//  THNGrassListModel.m
//  lexi
//
//  Created by HongpingRao on 2018/8/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGrassListModel.h"
#import <MJExtension/MJExtension.h>

@implementation THNGrassListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"des": @"description",
             };
}

@end
