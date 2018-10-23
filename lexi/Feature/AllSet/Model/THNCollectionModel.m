//
//  THNCollectionModel.m
//  lexi
//
//  Created by rhp on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCollectionModel.h"
#import <MJExtension/MJExtension.h>

@implementation THNCollectionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"collectionID": @"id"
             };
}

@end
