//
//  THNSetPasswordView.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetPasswordView.h"
#import "THNPasswordTextField.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *const kTitleLabelText          = @"设置密码";
static NSString *const kSubTitleLabelText       = @"8-16位字母和数字组合";
static NSString *const kPwdPlaceholder          = @"请输入密码";
static NSString *const kverifyPwdPlaceholder    = @"重复输入密码";
static NSString *const kDoneButtonTitle         = @"注册";

@interface THNSetPasswordView ()

/// 密码输入框
@property (nonatomic, strong) THNPasswordTextField *pwdTextField;
/// 验证密码输入框
@property (nonatomic, strong) THNPasswordTextField *verifyPwdTextField;
/// 完成（登录）按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 记录加载控件
@property (nonatomic, strong) NSArray *controlArray;

@end

@implementation THNSetPasswordView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if (![self.verifyPwdTextField.text isEqualToString:self.pwdTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    if (self.pwdTextField.text.length < 8 || self.verifyPwdTextField.text.length < 8) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@", kSubTitleLabelText]];
        return;
    }
    
    self.SetPasswordRegisterBlock();
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.title = kTitleLabelText;
    self.subTitle = kSubTitleLabelText;
    
    [self addSubview:self.pwdTextField];
    [self addSubview:self.verifyPwdTextField];
    [self addSubview:self.doneButton];
    
    self.controlArray = @[self.pwdTextField, self.verifyPwdTextField, self.doneButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leadSpacing = kDeviceiPhoneX ? 194 : 174;
    CGFloat tailSpacing = SCREEN_HEIGHT - leadSpacing - (46 + 25) * self.controlArray.count;
    [self.controlArray mas_distributeViewsAlongAxis:(MASAxisTypeVertical)
                                withFixedItemLength:46
                                        leadSpacing:leadSpacing
                                        tailSpacing:tailSpacing];
    [self.controlArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.pwdTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                    width:0.5
                                    color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.verifyPwdTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                          width:0.5
                                          color:[UIColor colorWithHexString:@"#DADADA"]];
}

#pragma mark - getters and setters
- (THNPasswordTextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[THNPasswordTextField alloc] init];
        _pwdTextField.kPlaceholderText = kPwdPlaceholder;
    }
    return _pwdTextField;
}

- (THNPasswordTextField *)verifyPwdTextField {
    if (!_verifyPwdTextField) {
        _verifyPwdTextField = [[THNPasswordTextField alloc] init];
        _verifyPwdTextField.kPlaceholderText = kverifyPwdPlaceholder;
    }
    return _verifyPwdTextField;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:kDoneButtonTitle forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _doneButton.layer.cornerRadius = 4;
        _doneButton.layer.shadowOffset = CGSizeMake(0, 10);
        _doneButton.layer.shadowColor = [UIColor colorWithHexString:kColorMain alpha:0.5].CGColor;
        _doneButton.layer.shadowOpacity = 0.2;
        _doneButton.layer.shadowRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
