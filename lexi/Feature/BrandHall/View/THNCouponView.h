//
//  THNCouponView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^CouponViewHeightBlock)(CGFloat couponViewHeight);

@interface THNCouponView : UIView

- (void)layoutCouponView:(NSArray *)fullReductions
        withLoginCoupons:(NSArray *)loginCoupons
       withNologinCoupos:(NSArray *)noLoginCoupons
               withHeightBlock:(CouponViewHeightBlock)couponViewHeightBlock;

@end
