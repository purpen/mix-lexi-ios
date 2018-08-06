//
//  THNSelectButtonView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectButtonView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNMarco.h"

@interface THNSelectButtonView()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation THNSelectButtonView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray {
    self = [super initWithFrame:frame];
    float btnWidth = 0;
    if (self) {
        for (int i = 0; i < titleArray.count; i ++) {
            NSString *btnName = titleArray[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor colorWithHexString:@"555555"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"5fe4b1"] forState:UIControlStateSelected];
            [btn setTitle:btnName forState:UIControlStateNormal];

            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
            CGSize btnSize = [btnName sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
            btn.viewWidth = btnSize.width + 34;
            btn.viewHeight = btnSize.height + 14;
            
            if (i == 0) {
                btn.viewX = 0;
                btnWidth += CGRectGetMaxX(btn.frame);
                btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
                btn.selected = YES;
            } else {
                btnWidth += CGRectGetMaxX(btn.frame);
                btn.viewX = btnWidth - btn.viewWidth;
            }
            
            btn.viewHeight = 30;
            btn.viewY = 20;
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self.buttons addObject:btn];
            
        }
        self.frame = frame;
    
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn == self.selectBtn) {
        return;
    }
    
    for (UIButton *button in self.buttons) {
        button.selected = NO;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
    
    btn.selected = YES;
    self.selectBtn.selected = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButtonsDidClickedAtIndex:)]) {
        [self.delegate selectButtonsDidClickedAtIndex:btn.tag];
    }
    
    self.selectBtn = btn;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
