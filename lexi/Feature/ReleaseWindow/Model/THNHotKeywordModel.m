//
//  THNHotKeywordModel.m
//  lexi
//
//  Created by HongpingRao on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNHotKeywordModel.h"
#import <MJExtension/MJExtension.h>

@implementation THNHotKeywordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"keyWordID": @"id"
             };
}

@end
