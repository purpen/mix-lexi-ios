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

@end

@implementation THNSelectOfficalCouponView

- (void)setOfficalCoupons:(NSArray *)officalCoupons {
    _officalCoupons = officalCoupons;
    
    // 没有选择金额，展示最大金额
    if (self.selectCouponText.length == 0) {
        if (self.officalCoupons.count > 0) {
            self.couponLabel.text = [NSString stringWithFormat:@"已抵%.2f",[self.officalCoupons[0][@"amount"] floatValue]];
            self.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];
        } else {
            self.couponLabel.text = @"无可用优惠券";
            self.couponLabel.textColor = [UIColor colorWithHexString:@"999999"];
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
    self.selectCouponView.couponType = CouponTypeOffical;
    self.selectCouponView.coupons = self.officalCoupons;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text, THNCouponModel *couponModel) {
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
