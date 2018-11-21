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
#import "UIColor+Extension.h"
#import "THNCouponModel.h"

@interface THNSelectOfficalCouponView()

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (nonatomic, strong) THNSelectCouponView *selectCouponView;
@property (nonatomic, strong) NSString *selectCouponText;
@property (weak, nonatomic) IBOutlet UIButton *selectCouponButton;

@end

@implementation THNSelectOfficalCouponView

- (void)setOfficalCoupons:(NSArray *)officalCoupons {
    _officalCoupons = officalCoupons;
    
    switch (self.couponStyleType) {
        case ShowCouponStyleTypeAmount:
            if (self.officalCoupons.count > 0) {
                self.couponLabel.text = [NSString stringWithFormat:@"已抵%.2f",[self.officalCoupons[0][@"amount"] floatValue]];
            }
            self.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];
            self.selectCouponButton.enabled = YES;
            break;
        case ShowCouponStyleTypeUnavailable:
            self.couponLabel.text = @"不可使用";
            self.couponLabel.textColor = [UIColor colorWithHexString:@"999999"];
            self.selectCouponButton.enabled = NO;
            break;
        case ShowCouponStyleTypeNotavailable:
            self.couponLabel.text = @"无可用优惠券";
            self.couponLabel.textColor = [UIColor colorWithHexString:@"999999"];
            self.selectCouponButton.enabled = NO;
            break;
        case ShowCouponStyleTypeQuantityAvailable:
            self.couponLabel.text =  [NSString stringWithFormat:@"%ld个优惠券可用", officalCoupons.count];
            self.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];
            self.selectCouponButton.enabled = YES;
            break;
    }
}

- (IBAction)selectCouponButton:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.selectCouponView.frame = window.bounds;
    self.selectCouponView.couponType = CouponTypeOffical;
    self.selectCouponView.coupons = self.officalCoupons;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text, THNCouponModel *couponModel) {
        weakSelf.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];
        weakSelf.selectCouponText = text;
        weakSelf.updateCouponAcountBlcok(couponModel.amount, couponModel.code);
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
