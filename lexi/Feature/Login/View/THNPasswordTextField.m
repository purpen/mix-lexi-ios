//
//  THNPasswordTextField.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPasswordTextField.h"
#import "UIColor+Extension.h"

@interface THNPasswordTextField () <UITextFieldDelegate>

/// 显示密码
@property (nonatomic, strong) UIButton *secureButton;

@end

@implementation THNPasswordTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rightView = self.secureButton;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
        self.textColor = [UIColor colorWithHexString:@"#333333"];
        self.delegate = self;
    }
    return self;
}

#pragma mark - event response
- (void)secureButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    self.secureTextEntry = !button.selected;
}

#pragma mark - textfield delegate
// 直接设置 secureTextEntry 属性有内存泄漏的问题，使用代理进行设置
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.secureTextEntry = !self.secureButton.selected;

    return YES;
}

#pragma mark - getters and setters
- (void)setKPlaceholderText:(NSString *)kPlaceholderText {
    self.placeholder = kPlaceholderText;
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

@end
