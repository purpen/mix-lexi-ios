//
//  THNCouponView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCouponView.h"
#import "UIColor+Extension.h"
#import "THNLoginManager.h"
#import "THNCouponDetailView.h"
#import "UIView+Helper.h"

static CGFloat const redEnvelopeViewHeight = 26;
static CGFloat const fullReductionViewHeight = 15;
static CGFloat const couponViewHeight = 65;

@interface THNCouponView()

@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIView *redEnvelopeView;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redEnvelopeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullReductionViewHeighrConstraint;
@property (weak, nonatomic) IBOutlet UIButton *rightIndicationButton;
@property (nonatomic, strong) THNCouponDetailView *couponDetailView;
// 满减
@property (nonatomic, strong) NSArray *fullReductions;
// 已登录展示的优惠券
@property (nonatomic, strong) NSArray *loginCoupons;
// 未登录展示的优惠券    
@property (nonatomic, strong) NSArray *noLoginCoupons;
@property (nonatomic, strong) NSMutableString *mutableString;

@end

@implementation THNCouponView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.receiveButton.layer.borderWidth = 1;
    self.receiveButton.layer.borderColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
    self.receiveButton.layer.cornerRadius = 13;
}

- (CGFloat)layoutCouponView:(NSArray *)fullReductions
        withLoginCoupons:(NSArray *)loginCoupons
       withNologinCoupos:(NSArray *)noLoginCoupons {
    
    CGFloat height = 0.0;
    self.fullReductions = fullReductions;
    self.loginCoupons = loginCoupons;
    self.noLoginCoupons = noLoginCoupons;

    if ([THNLoginManager isLogin]) {
        self.redEnvelopeView.hidden = loginCoupons.count == 0;
    } else {
        self.redEnvelopeView.hidden = noLoginCoupons.count == 0;
    }
    
    self.fullReductionView.hidden = fullReductions.count == 0;
    
    if (self.redEnvelopeView.hidden && self.fullReductionView.hidden) {
        height = 0;
        self.fullReductionViewHeighrConstraint.constant = 0;
        self.redEnvelopeViewHeightConstraint.constant = 0;
    } else if (self.fullReductionView.hidden) {
        height = couponViewHeight - fullReductionViewHeight;
        self.fullReductionViewHeighrConstraint.constant = 0;
        self.rightIndicationButton.hidden = YES;
    } else if (self.redEnvelopeView.hidden) {
        height = couponViewHeight - redEnvelopeViewHeight;
        self.redEnvelopeViewHeightConstraint.constant = 0;
        self.rightIndicationButton.hidden = NO;
    } else if (!self.redEnvelopeView.hidden && !self.fullReductionView.hidden){
        self.fullReductionViewHeighrConstraint.constant = fullReductionViewHeight;
        self.redEnvelopeViewHeightConstraint.constant = redEnvelopeViewHeight;
        height = couponViewHeight;
        self.rightIndicationButton.hidden = YES;
    }
    
    
    for (NSDictionary *dict in fullReductions) {
         NSString *fullReductionStr = [NSString stringWithFormat:@"  %@",dict[@"type_text"]];
        [self.mutableString appendString:fullReductionStr];
    }
    
    self.fullReductionLabel.text = self.mutableString;
    
    return height;
}

// 点击领取
- (IBAction)receive:(id)sender {
    
    [self.couponDetailView layoutCouponDetailView:self.mutableString withLoginCoupons:self.loginCoupons withNologinCoupos:self.noLoginCoupons];
    [self showCouponDetailView];
}

// 查看满减
- (IBAction)look:(id)sender {
    [self.couponDetailView layoutFullReductionLabelText:self.mutableString];
    [self showCouponDetailView];
}

- (void)showCouponDetailView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.couponDetailView.frame = window.bounds;
    [window addSubview:self.couponDetailView];
}

#pragma mark - lazy
- (THNCouponDetailView *)couponDetailView {
    if (!_couponDetailView) {
        _couponDetailView = [THNCouponDetailView viewFromXib];
    }
    return _couponDetailView;
}

- (NSMutableString *)mutableString {
    if (!_mutableString) {
        _mutableString = [NSMutableString string];
    }
    return _mutableString;
}

@end
