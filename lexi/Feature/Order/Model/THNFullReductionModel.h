//
//  THNFullReductionModel.h
//  lexi
//
//  Created by rhp on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNFullReductionModel : NSObject

// 面值
@property (nonatomic, assign) CGFloat amount;
// 满足金额
@property (nonatomic, assign) CGFloat reach_amount;
// 最小金额
@property (nonatomic, assign) CGFloat min_amount;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
// 是否领取 0、未领取 1、已领取
@property (nonatomic, assign) NSInteger status;
// 类型 1、同享券 2、单享券 3、满减
@property (nonatomic, assign) NSInteger type;
// 有效天数
@property (nonatomic, strong) NSString *days;
// 描述
@property (nonatomic, strong) NSString *type_text;
// 优惠券code
@property (nonatomic, strong) NSString *code;

@end
