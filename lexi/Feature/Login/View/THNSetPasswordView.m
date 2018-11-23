//
//  THNSetPasswordView.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetPasswordView.h"
#import "THNPasswordTextField.h"
#import "SVProgressHUD+Helper.h"
#import "THNDoneButton.h"

static NSString *const kTitleNew                = @"设置密码";
static NSString *const kTitleFind               = @"设置新密码";
static NSString *const kSubTitleLabelText       = @"8-16位字母和数字组合";
static NSString *const kPwdPlaceholder          = @"请输入密码";
static NSString *const kVerifyPwdPlaceholder    = @"重复输入密码";
static NSString *const kDoneButtonTitle         = @"注册";
static NSString *const kDoneButtonSure          = @"确认";

@interface THNSetPasswordView () {
    THNSetPasswordType _setType;
}

/// 密码输入框
@property (nonatomic, strong) THNPasswordTextField *pwdTextField;
/// 验证密码输入框
@property (nonatomic, strong) THNPasswordTextField *verifyPwdTextField;
/// 完成（登录）按钮
@property (nonatomic, strong) THNDoneButton *doneButton;
/// 记录加载控件
@property (nonatomic, strong) NSArray *controlArray;

@end

@implementation THNSetPasswordView

- (instancetype)initWithType:(THNSetPasswordType)type {
    self = [super init];
    if (self) {
        _setType = type;
        self.title = type == THNSetPasswordTypeNew ? kTitleNew : kTitleFind;
        [self setupViewUI];
    }
    return self;
}

#pragma mark - private methods
- (void)thn_doneButtonAction {
    [self endEditing:YES];
    
    if (![self.verifyPwdTextField.text isEqualToString:self.pwdTextField.text]) {
        [SVProgressHUD thn_showInfoWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    if (self.pwdTextField.text.length < 8 || self.verifyPwdTextField.text.length < 8) {
        [SVProgressHUD thn_showInfoWithStatus:[NSString stringWithFormat:@"请输入%@", kSubTitleLabelText]];
        return;
    }
    
    self.SetPasswordRegisterBlock(self.pwdTextField.text, self.verifyPwdTextField.text);
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.subTitle = kSubTitleLabelText;
    self.controlArray = @[self.pwdTextField, self.verifyPwdTextField, self.doneButton];
    
    [self addSubview:self.pwdTextField];
    [self addSubview:self.verifyPwdTextField];
    [self addSubview:self.doneButton];
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
- (void)setViewTitle:(NSString *)viewTitle {
    self.title = viewTitle;
}

- (THNPasswordTextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[THNPasswordTextField alloc] initWithPlaceholderText:kPwdPlaceholder];
    }
    return _pwdTextField;
}

- (THNPasswordTextField *)verifyPwdTextField {
    if (!_verifyPwdTextField) {
        _verifyPwdTextField = [[THNPasswordTextField alloc] initWithPlaceholderText:kVerifyPwdPlaceholder];
    }
    return _verifyPwdTextField;
}

- (THNDoneButton *)doneButton {
    if (!_doneButton) {
        WEAKSELF;
        
        _doneButton = [[THNDoneButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 75)
                                                 withTitle:_setType == THNSetPasswordTypeNew ? kDoneButtonTitle : kDoneButtonSure
                                                completion:^{
                                                    [weakSelf thn_doneButtonAction];
                                                }];
    }
    return _doneButton;
}

@end
