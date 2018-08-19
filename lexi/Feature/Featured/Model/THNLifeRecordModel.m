//
//  THNGrassListModel.m
//  lexi
//
//  Created by HongpingRao on 2018/8/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLifeRecordModel.h"
#import <MJExtension/MJExtension.h>

@implementation THNLifeRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"des":@"description"};
    
}

@end
