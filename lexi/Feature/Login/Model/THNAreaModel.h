//
//  THNAreaModel.h
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "THNAreaCodeModel.h"

@interface THNAreaModel : NSObject

@property (nonatomic, strong) NSArray <THNAreaCodeModel *>*area_codes;
@property (nonatomic, assign) NSInteger count;

@end
