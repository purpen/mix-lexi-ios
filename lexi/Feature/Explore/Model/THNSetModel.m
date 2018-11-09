//
//  THNSetModel.m
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetModel.h"
#import <MJExtension/MJExtension.h>

@implementation THNSetModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"collectionID":@"id"};
}
@end
