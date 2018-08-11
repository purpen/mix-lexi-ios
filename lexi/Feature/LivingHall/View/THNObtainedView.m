//
//  THNObtainedView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNObtainedView.h"
#import "UIView+Helper.h"

@interface THNObtainedView()

@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation THNObtainedView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backGroundView drawCornerWithType:0 radius:4];
}

- (IBAction)delete:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}



@end
