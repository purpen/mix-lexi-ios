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
@property (nonatomic, strong) NSString *selectCouponText;
// 最大的优惠券金额
@property (nonatomic, assign) CGFloat maxCouponCount;

@end

@implementation THNSelectOfficalCouponView

- (void)setOfficalCoupons:(NSArray *)officalCoupons {
    _officalCoupons = officalCoupons;
    
    // 没有选择金额，展示最大金额
    if (self.selectCouponText.length == 0) {
        if (self.officalCoupons.count > 0) {
             self.maxCouponCount = [self.officalCoupons[0][@"amount"] floatValue];
            self.couponLabel.text = [NSString stringWithFormat:@"已抵扣%.2f",self.maxCouponCount];
        } else {
            self.couponLabel.text = @"当前没有优惠券";
        }
    } else {
        self.couponLabel.text = self.selectCouponText;
    }
   
}

- (IBAction)selectCouponButton:(id)sender {
    
    if (self.officalCoupons.count == 0) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.selectCouponView.frame = window.bounds;
    self.selectCouponView.maxCouponCount = self.maxCouponCount;
    self.selectCouponView.couponType = CouponTypeOffical;
    self.selectCouponView.coupons = self.officalCoupons;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text, CGFloat couponAcount, NSString *code) {
        weakSelf.selectCouponText = text;
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
