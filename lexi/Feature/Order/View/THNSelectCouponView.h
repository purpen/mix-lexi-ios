//
//  THNSelectCouponView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCouponBlock)(NSString *text);

@interface THNSelectCouponView : UIView

@property (nonatomic, strong) NSArray *coupons;

@property (nonatomic, copy) SelectCouponBlock selectCouponBlock;


@end
