//
//  THNCouponView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCouponView.h"
#import "UIColor+Extension.h"

@interface THNCouponView()

@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIView *redEnvelopeView;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;

@end

@implementation THNCouponView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.receiveButton.layer.borderWidth = 1;
    self.receiveButton.layer.borderColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
    self.receiveButton.layer.cornerRadius = 13;
}

- (IBAction)receive:(id)sender {
    
}

@end
