//
//  THNStoreModel.m
//  lexi
//
//  Created by FLYang on 2018/8/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNStoreModel.h"

@implementation THNStoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"describe": @"description"
             };
}

@end
