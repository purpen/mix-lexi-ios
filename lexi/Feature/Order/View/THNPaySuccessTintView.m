//
//  THNPaySuccessTintView.m
//  lexi
//
//  Created by HongpingRao on 2018/11/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaySuccessTintView.h"
#import "THNMarco.h"

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
