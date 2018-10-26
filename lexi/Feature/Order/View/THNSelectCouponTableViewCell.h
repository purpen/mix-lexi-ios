//
//  THNSelectCouponTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCouponModel;

/**
 优惠券类型
 
 - CouponTypeStore: 店铺优惠券 以coupon为key取值
 - CouponTypeOffical: 官方优惠券 直接取值
 */
typedef NS_ENUM(NSUInteger, CouponType) {
    CouponTypeStore,
    CouponTypeOffical
};


@interface THNSelectCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) THNCouponModel *couponModel;
@property (nonatomic, assign) CouponType couponType;
@property (nonatomic, assign) BOOL isSelect;
// 有效期
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodLabel;

@end
