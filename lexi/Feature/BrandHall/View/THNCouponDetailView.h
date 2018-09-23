//
//  THNCouponDetailView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNCouponDetailView : UIView

- (void)layoutCouponDetailView:(NSMutableString *)text
        withLoginCoupons:(NSArray *)loginCoupons
       withNologinCoupos:(NSArray *)noLoginCoupons;

- (void)layoutFullReductionLabelText:(NSMutableString*)text;

@end
