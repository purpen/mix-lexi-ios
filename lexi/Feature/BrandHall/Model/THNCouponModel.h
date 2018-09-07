//
//  THNCouponModel.h
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNCouponModel : NSObject
// 面值
@property (nonatomic, assign) CGFloat amount;
// 优惠券使用最小金额
@property (nonatomic, assign) CGFloat min_amount;
 // 是否领取 0、未领取 1、已领取
@property (nonatomic, assign) NSInteger status;
// 描述文字
@property (nonatomic, strong) NSString *type_text;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSString *start_date;
// 优惠券code
@property (nonatomic, strong) NSString *code;


@end
