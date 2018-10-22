//
//  THNOrderDetailPayView.m
//  mixcash
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailPayView.h"
#import "THNOrderDetailModel.h"
#import "NSString+Helper.h"

@interface THNOrderDetailPayView()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payMethodImageView;
// 小计
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
// 配送请求方式
@property (weak, nonatomic) IBOutlet UILabel *deliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
// 首单优惠
@property (weak, nonatomic) IBOutlet UILabel *firstOfferLabel;
// 满减
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;
// 优惠券
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
// 订单详情顶部订单号以及支付方式的View
@property (weak, nonatomic) IBOutlet UIView *orderDetailTopView;
@property (weak, nonatomic) IBOutlet UIView *fitstOfferView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstOfferViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullReductionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDetailTopViewHeightConstraint;


@end

@implementation THNOrderDetailPayView

- (CGFloat)setOrderDetailPayView:(THNOrderDetailModel *)detailModel {
    
    if (!detailModel.outside_target_id) {
        self.orderDetailTopView.hidden = YES;
        self.orderDetailTopViewHeightConstraint.constant = 0;
    } else {
        self.orderNumberLabel.text = detailModel.outside_target_id;
        self.payMethodLabel.text = @"微信在线支付";
        self.payMethodImageView.image = [UIImage imageNamed:@"icon_order_wechat"];
        self.orderDetailTopView.hidden = NO;
        self.orderDetailTopViewHeightConstraint.constant = 138;
    }
    
    self.subtotalLabel.text = [NSString formatFloat:detailModel.total_amount];
    self.totalMoneyLabel.text = [NSString formatFloat:detailModel.user_pay_amount];
    
    if (detailModel.freight == 0) {
        self.deliveryMethodLabel.text  = @"包邮";
    } else {
        self.deliveryMethodLabel.text = [NSString formatFloat:detailModel.freight];
    }
    
    if (detailModel.first_discount == 0) {
        self.fitstOfferView.hidden = YES;
        self.firstOfferViewHeightConstraint.constant = 0;
    } else {
        self.fitstOfferView.hidden = NO;
        self.firstOfferViewHeightConstraint.constant = 30;
        self.firstOfferLabel.text = [NSString formatFloat:detailModel.first_discount];
    }
    
    if (detailModel.coupon_amount == 0) {
        self.couponView.hidden = YES;
        self.couponViewHeightConstraint.constant = 0;
    } else {
        self.couponView.hidden = NO;
        self.couponViewHeightConstraint.constant = 30;
         self.couponLabel.text = [NSString formatFloat:detailModel.coupon_amount];
    }
    
    if (detailModel.reach_minus == 0) {
        self.fullReductionView.hidden = YES;
        self.fullReductionViewHeightConstraint.constant = 0;
    } else {
        self.fullReductionView.hidden = NO;
        self.fullReductionViewHeightConstraint.constant = 30;
        self.fullReductionLabel.text = [NSString formatFloat:detailModel.reach_minus];
    }
    
    return 122 + self.firstOfferViewHeightConstraint.constant + self.fullReductionViewHeightConstraint.constant + self.couponViewHeightConstraint.constant +  self.orderDetailTopViewHeightConstraint.constant;
}

- (void)setTotalCouponAmount:(CGFloat)totalCouponAmount {
    self.couponLabel.text = [NSString formatFloat:totalCouponAmount];
}

@end
