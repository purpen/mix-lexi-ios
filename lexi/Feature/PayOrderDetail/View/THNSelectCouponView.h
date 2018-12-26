//
//  THNSelectCouponView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNSelectCouponTableViewCell.h"

@class THNCouponModel;

UIKIT_EXTERN NSString *const kNotSelectDesTitle;

typedef void(^SelectCouponBlock)(NSString *text, THNCouponModel *couponModel);
typedef void(^DoNotUseCouponBlock)(NSString *text);

@interface THNSelectCouponView : UIView

@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, assign) CouponType couponType;
@property (nonatomic, copy) SelectCouponBlock selectCouponBlock;
@property (nonatomic, copy) DoNotUseCouponBlock notUseCounponBlock;

@end
