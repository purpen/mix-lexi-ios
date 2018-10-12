//
//  THNGrassListModel.m
//  lexi
//
//  Created by HongpingRao on 2018/8/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGrassListModel.h"
#import <MJExtension/MJExtension.h>

NSString *const creatorStoryTitle = @"创作人故事";
NSString *const lifeRememberTitle = @"生活记事";
NSString *const handTeachTitle = @"手作教学";

@implementation THNGrassListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"des": @"description",
             };
}

@end
