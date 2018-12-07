//
//  THNAreaModel.m
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAreaModel.h"

@implementation THNAreaModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"area_codes": [THNAreaCodeModel class]};
}

@end
