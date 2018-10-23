//
//  THNPasswordTextField.m
//  lexi
//
//  Created by FLYang on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPasswordTextField.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

@interface THNPasswordTextField () <UITextFieldDelegate>

/// 输入框
@property (nonatomic, strong) UITextField *contentTextField;
/// 显示密码的按钮
@property (nonatomic, strong) UIButton *secureButton;

@end

@implementation THNPasswordTextField


- (instancetype)initWithPlaceholderText:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.contentTextField.placeholder = placeholder;
        [self setViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)secureButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    self.contentTextField.secureTextEntry = !button.selected;
}

#pragma mark - textfield delegate
// 直接设置 secureTextEntry 属性有内存泄漏的问题，使用代理进行设置
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.contentTextField) {
        self.contentTextField.secureTextEntry = !self.secureButton.selected;
        return YES;
    }
    
    return YES;
}

#pragma mark - setup UI
- (void)setText:(NSString *)text {
    self.contentTextField.text = text;
}

- (NSString *)text {
    return self.contentTextField.text;
}

- (void)setViewUI {
    [self addSubview:self.contentTextField];
    [_contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
}

#pragma mark - getters and setters

- (UITextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.rightView = self.secureButton;
        _contentTextField.rightViewMode = UITextFieldViewModeAlways;
        _contentTextField.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
        _contentTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _contentTextField.minimumFontSize = 18;
        _contentTextField.delegate = self;
    }
    return _contentTextField;
}

- (UIButton *)secureButton {
    if (!_secureButton) {
        _secureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        [_secureButton setImage:[UIImage imageNamed:@"icon_secure_yes"] forState:(UIControlStateNormal)];
        [_secureButton setImage:[UIImage imageNamed:@"icon_secure_no"] forState:(UIControlStateSelected)];
        [_secureButton setImageEdgeInsets:(UIEdgeInsetsMake(13, 26, 13, 0))];
        _secureButton.selected = NO;
        [_secureButton addTarget:self action:@selector(secureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _secureButton;
}

- (BOOL)willDealloc {
    self.contentTextField.secureTextEntry = NO;
    
    return YES;
}

@end
