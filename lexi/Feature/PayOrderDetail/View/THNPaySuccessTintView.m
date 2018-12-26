//
//  THNPaySuccessTintView.m
//  lexi
//
//  Created by HongpingRao on 2018/11/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaySuccessTintView.h"
#import "THNMarco.h"
#import "UIView+Helper.h"

@interface THNPaySuccessTintView()

@property (weak, nonatomic) IBOutlet UIButton *lookOrderButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeButtonTopConstraint;

@end

@implementation THNPaySuccessTintView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lookOrderButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.lookOrderButton.layer.borderWidth = 1;
    self.lookOrderButton.layer.cornerRadius = 4;
    self.closeButtonTopConstraint.constant = kDeviceiPhoneX ? 15 + 44 : 15 + 22;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(1.12, 1.11);
    gl.endPoint = CGPointMake(0.02, 0.06);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:32/255.0 green:230/255.0 blue:172/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:95/255.0 green:228/255.0 blue:177/255.0 alpha:1].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.layer insertSublayer:gl atIndex:0];
}

- (IBAction)closeButton:(id)sender {
    if (self.paySuccessCloseBlock) {
        self.paySuccessCloseBlock();
    }
}

- (IBAction)lookOrder:(id)sender {
    if (self.paySuccessTintViewBlcok) {
        self.paySuccessTintViewBlcok();
    }
}

@end
