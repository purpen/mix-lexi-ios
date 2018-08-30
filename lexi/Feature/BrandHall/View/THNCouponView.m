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

@interface THNCouponView()

@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIView *redEnvelopeView;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;

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
    
    CGFloat couponViewHeight = 0.0;
    
    if ([THNLoginManager isLogin]) {
        self.redEnvelopeView.hidden = noLoginCoupons.count == 0;
    } else {
        self.redEnvelopeView.hidden = loginCoupons.count == 0;
    }
    
    self.fullReductionView.hidden = fullReductions.count == 0;
    
    if (self.redEnvelopeView.hidden) {
        couponViewHeight = 39;
    } else if (self.fullReductionView.hidden) {
        couponViewHeight = 50;
    } else if (self.redEnvelopeView.hidden && self.fullReductionView.hidden) {
        couponViewHeight = 0;
    } else {
        couponViewHeight = 65;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
   
    for (NSDictionary *dict in fullReductions) {
         NSString *fullReductionStr = [NSString stringWithFormat:@"  %@",dict[@"type_text"]];
        [mutableString appendString:fullReductionStr];
    }
    
    self.fullReductionLabel.text = mutableString;
    
    couponViewHeightBlock(couponViewHeight);
}

- (IBAction)receive:(id)sender {
    
}

@end
