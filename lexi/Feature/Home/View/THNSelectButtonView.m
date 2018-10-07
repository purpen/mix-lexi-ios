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
@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *triangleButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) ButtonType buttonType;

@end

@implementation THNSelectButtonView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray initWithButtonType:(ButtonType)type {
    if (self = [super initWithFrame:frame]) {
        
        float btnWidth = 0;
        UIButton *btn;
        self.buttonType = type;
        
        for (int i = 0; i < titleArray.count; i ++) {
            
            switch (type) {
                case ButtonTypeDefault:
                    btn = self.defaultButton;
                    break;
                default:
                    btn = self.triangleButton;
                    break;
            }
        
            NSString *btnName = titleArray[i];
            [btn setTitle:btnName forState:UIControlStateNormal];
            CGSize btnSize = [btnName sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
            
           
            if (type == ButtonTypeLine) {
                btn.viewWidth = self.viewWidth / titleArray.count;
                btn.viewHeight = btnSize.height + 14;
                btn.viewY = 5;
            } else {
                btn.viewWidth = btnSize.width + 34;
                btn.viewHeight = btnSize.height + 14;
                btn.viewY = 20;
            }
            
            if (i == 0) {
                
                if (type == ButtonTypeDefault) {
                    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
                } else {
                    [self addSubview:self.lineView];
                    self.lineView.viewX = (btn.viewWidth - btnSize.width) / 2;
                    self.lineView.viewWidth = btnSize.width;
                }
                
                btn.selected = YES;
                btnWidth += CGRectGetMaxX(btn.frame);
                
            } else {
                btnWidth += CGRectGetMaxX(btn.frame);
                btn.viewX = btnWidth - btn.viewWidth;
            }
            
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self.buttons addObject:btn];
        }
    }
    
    self.frame = frame;
    return self;
}

- (void)setDefaultShowIndex:(NSInteger)defaultShowIndex {
    
    if (defaultShowIndex == 0) {
        return;
    }
    UIButton *firstBtn = self.buttons[0];
    firstBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    firstBtn.selected = NO;
    UIButton *defaultBtn = self.buttons[defaultShowIndex];
    defaultBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    defaultBtn.selected = YES;
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn == self.selectBtn) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButtonsDidClickedAtIndex:)]) {
        [self.delegate selectButtonsDidClickedAtIndex:btn.tag];
    }
    
    
    
    for (UIButton *button in self.buttons) {
        
        if (self.buttonType == ButtonTypeDefault) {
             button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        }
        
        button.selected = NO;
       
    }
    
    btn.selected = YES;
    self.selectBtn.selected = NO;
    self.selectBtn = btn;
    
    if (self.buttonType == ButtonTypeLine) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.viewX = btn.viewX + (btn.viewWidth - btn.titleLabel.viewWidth) / 2;
            self.lineView.viewWidth = btn.titleLabel.viewWidth;
        }];
        
    } else {
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIButton *)defaultButton {
    _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_defaultButton setTitleColor:[UIColor colorWithHexString:@"555555"] forState:UIControlStateNormal];
    [_defaultButton setTitleColor:[UIColor colorWithHexString:@"5fe4b1"] forState:UIControlStateSelected];
    _defaultButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    return _defaultButton;
}

- (UIButton *)triangleButton {
    _triangleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_triangleButton setTitleColor:[UIColor colorWithHexString:@"A9B1B8"] forState:UIControlStateNormal];
    [_triangleButton setTitleColor:[UIColor colorWithHexString:@"5FE4B1"] forState:UIControlStateSelected];
    _triangleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    return _triangleButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.viewHeight = 2;
        _lineView.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        _lineView.viewY = self.viewHeight - 2;
    }
    return _lineView;
}

@end
