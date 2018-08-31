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

@end

@implementation THNCouponView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.receiveButton.layer.borderWidth = 1;
    self.receiveButton.layer.borderColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
    self.receiveButton.layer.cornerRadius = 13;
}

- (void)layoutCouponView:(NSArray *)fullReductions 
        withLoginCoupons:(NSArray *)loginCoupons
       withNologinCoupos:(NSArray *)noLoginCoupons
         withHeightBlock:(CouponViewHeightBlock)couponViewHeightBlock {
    
    CGFloat height = 0.0;
    
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
        self.rightIndicationButton.hidden = NO;
    } else if (self.redEnvelopeView.hidden) {
        height = couponViewHeight - redEnvelopeViewHeight;
        self.redEnvelopeViewHeightConstraint.constant = 0;
        self.rightIndicationButton.hidden = YES;
    } else if (!self.redEnvelopeView.hidden && !self.fullReductionView.hidden){
        self.fullReductionViewHeighrConstraint.constant = fullReductionViewHeight;
        self.redEnvelopeViewHeightConstraint.constant = redEnvelopeViewHeight;
        height = couponViewHeight;
        self.rightIndicationButton.hidden = YES;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
   
    for (NSDictionary *dict in fullReductions) {
         NSString *fullReductionStr = [NSString stringWithFormat:@"  %@",dict[@"type_text"]];
        [mutableString appendString:fullReductionStr];
    }
    
    self.fullReductionLabel.text = mutableString;
    
    couponViewHeightBlock(height);
}

- (IBAction)receive:(id)sender {
    
}

- (IBAction)look:(id)sender {
    
}

@end
