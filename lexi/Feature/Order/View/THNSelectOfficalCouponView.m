//
//  THNSelectOfficalCouponView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectOfficalCouponView.h"
#import "THNSelectCouponView.h"
#import "UIView+Helper.h"

@interface THNSelectOfficalCouponView()

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (nonatomic, strong) THNSelectCouponView *selectCouponView;

@end

@implementation THNSelectOfficalCouponView

- (void)setOfficalCoupons:(NSArray *)officalCoupons {
    _officalCoupons = officalCoupons;
    if (self.officalCoupons.count > 0) {
        self.couponLabel.text = [NSString stringWithFormat:@"已抵扣%.2f",[self.officalCoupons[0][@"amount"] floatValue]];
    } else {
        self.couponLabel.text = @"当前没有优惠券";
    }
}

- (IBAction)selectCouponButton:(id)sender {
    
    if (self.officalCoupons.count == 0) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.selectCouponView.frame = window.bounds;
    self.selectCouponView.couponType = CouponTypeOffical;
    self.selectCouponView.coupons = self.officalCoupons;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text, CGFloat couponAcount, NSString *code) {
        CGFloat couponSpread = couponAcount - [[weakSelf.couponLabel.text substringFromIndex:3] floatValue];
        weakSelf.updateCouponAcountBlcok(couponSpread, code);
        weakSelf.couponLabel.text = text;
    };
    
    [window addSubview:self.selectCouponView];
}

#pragma mark - lazy
- (THNSelectCouponView *)selectCouponView {
    if (!_selectCouponView) {
        _selectCouponView = [THNSelectCouponView viewFromXib];
    }
    return _selectCouponView;
}


@end
