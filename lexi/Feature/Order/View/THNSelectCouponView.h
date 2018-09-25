//
//  THNSelectCouponView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNSelectCouponTableViewCell.h"


typedef void(^SelectCouponBlock)(NSString *text, CGFloat couponAcount, NSString *code);

@interface THNSelectCouponView : UIView

@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, assign) CouponType couponType;

@property (nonatomic, copy) SelectCouponBlock selectCouponBlock;


@end
