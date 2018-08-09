//
//  THNLivingHallMuseumView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallMuseumView.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

@interface THNLivingHallMuseumView()

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *nameCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation THNLivingHallMuseumView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.saveButton drawCornerWithType:0 radius:4];
    [self.backGroundView drawCornerWithType:0 radius:4];
    [self layotuTextViewStyle:self.introductionTextView];
    [self layotuTextViewStyle:self.nameTextView];
}

- (void)layotuTextViewStyle:(UITextView *)textView {
    textView.layer.cornerRadius = 4;
    textView.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.alpha = 1;
}

+ (instancetype)show {
    THNLivingHallMuseumView *hallMuseumView = [THNLivingHallMuseumView viewFromXib];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    hallMuseumView.frame = window.bounds;
    [window addSubview:hallMuseumView];
    return hallMuseumView;
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)save:(id)sender {
    [self removeFromSuperview];
}

@end
