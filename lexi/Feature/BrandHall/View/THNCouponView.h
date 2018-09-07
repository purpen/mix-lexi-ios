//
//  THNCouponView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CouponViewHeightBlock)(CGFloat couponViewHeight);

@interface THNCouponView : UIView

/**
 设置CouponView各种状态下的布局

 @param fullReductions 满减
 @param loginCoupons 已登录的优惠劵
 @param noLoginCoupons 未登录的优惠赚
 */


/**
  设置CouponView各种状态下的布局

 @param fullReductions 满减
 @param loginCoupons 已登录的优惠劵
 @param noLoginCoupons 未登录的优惠赚
 @return  CouponView各种状态下的高度
 */
- (CGFloat)layoutCouponView:(NSArray *)fullReductions
        withLoginCoupons:(NSArray *)loginCoupons
       withNologinCoupos:(NSArray *)noLoginCoupons;

@end
