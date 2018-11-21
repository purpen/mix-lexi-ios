//
//  THNSelectOfficalCouponView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNCouponModel.h"

typedef void(^UpdateCouponAmountBlcok)(CGFloat couponSpread, NSString*code);

@interface THNSelectOfficalCouponView : UIView

@property (nonatomic, strong) NSArray *officalCoupons;
@property (nonatomic, copy) UpdateCouponAmountBlcok updateCouponAcountBlcok;
@property (nonatomic, assign) ShowCouponStyleType couponStyleType;

@end
