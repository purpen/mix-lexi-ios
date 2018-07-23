//
//  THNSignInView.m
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignInView.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *const kTitleLabelText      = @"登录";
static NSString *const kZipCodeDefault      = @"+86";
static NSString *const kPhonePlaceholder    = @"请输入手机号码";
static NSString *const kPwdPlaceholder      = @"请输入密码";
static NSString *const kAuthPlaceholder     = @"请输入手机动态码";
static NSString *const kAuthCodeButtonTitle = @"获取动态码";
static NSString *const kDoneButtonTitle     = @"登录";
static NSString *const kForgetButtonTitle   = @"忘记密码？";
static NSString *const kSignUpText          = @"还没有账号？点击注册";
static NSString *const kThirdLoginText      = @"第三方登录";

@interface THNSignInView () <UITextFieldDelegate>

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 登录方式切换
@property (nonatomic, strong) UISegmentedControl *loginSegmented;
/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 手机区号
@property (nonatomic, strong) UIButton *zipCodeButton;
/// 手机号输入框
@property (nonatomic, strong) UITextField *phoneTextField;
/// 密码输入框
@property (nonatomic, strong) UITextField *pwdTextField;
/// 显示密码
@property (nonatomic, strong) UIButton *secureButton;
/// 验证码输入框
@property (nonatomic, strong) UITextField *authCodeTextField;
/// 获取验证码按钮
@property (nonatomic, strong) UIButton *authCodeButton;
/// 完成（登录）按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetButton;
/// 已有账号，去登录提示
@property (nonatomic, strong) YYLabel *signUpLabel;
/// 第三方登录提示
@property (nonatomic, strong) UILabel *thirdLoginLabel;
/// 微信登录
@property (nonatomic, strong) UIButton *wechatButton;
/// 记录加载控件
@property (nonatomic, strong) NSArray *controlArray;

@end

@implementation THNSignInView


- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"登录"];
}

- (void)authCodeButtonAction:(UIButton *)button {
    if ([self.phoneTextField.text checkTel]) {
        [self.authCodeTextField becomeFirstResponder];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }
}

- (void)zipCodeButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"选择区号"];
}

- (void)wechatButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"微信登录"];
}

- (void)forgetButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"忘记密码"];
}

- (void)secureButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    self.pwdTextField.secureTextEntry = !button.selected;
}

- (void)loginSegmentedControlAction:(UISegmentedControl *)segment {
    [self thn_changeLoginPasswordMethod:!(BOOL)segment.selectedSegmentIndex];

    if (segment.selectedSegmentIndex == 1) {
        if ([self.pwdTextField isFirstResponder]) {
            [self.pwdTextField resignFirstResponder];
            [self.authCodeTextField becomeFirstResponder];
        }
        
        if (self.pwdTextField.text.length) {
            self.pwdTextField.text = @"";
        }
        
    } else {
        if ([self.authCodeTextField isFirstResponder]) {
            [self.authCodeTextField resignFirstResponder];
            [self.pwdTextField becomeFirstResponder];
        }
        
        if (self.authCodeTextField.text.length) {
            self.authCodeTextField.text = @"";
        }
    }
}

#pragma mark - textField delegate
/// 直接设置 secureTextEntry 属性有内存泄漏的问题，使用代理进行设置
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.pwdTextField) {
        textField.secureTextEntry = YES;
    }
    
    return YES;
}

#pragma mark - private methods
/**
 切换密码登录
 */
- (void)thn_changeLoginPasswordMethod:(BOOL)change {
    [UIView animateWithDuration:0.3 animations:^{
        self.pwdTextField.alpha = change ? 1 : 0;
        self.authCodeTextField.alpha = change ? 0 : 1;
    }];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.loginSegmented];
    [self.containerView addSubview:self.phoneTextField];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.pwdTextField];
    [self addSubview:self.doneButton];
    [self addSubview:self.containerView];
    [self addSubview:self.forgetButton];
    [self addSubview:self.signUpLabel];
    [self addSubview:self.thirdLoginLabel];
    [self addSubview:self.wechatButton];
    
    self.controlArray = @[self.phoneTextField, self.authCodeTextField];
    
    [self thn_changeLoginPasswordMethod:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(kDeviceiPhoneX ? 104 : 84);
    }];
    
    [self.loginSegmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(30);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.loginSegmented.mas_bottom).with.offset(25);
        make.height.mas_equalTo(122);
    }];
    
    self.zipCodeButton.frame = CGRectMake(0, 0, 80, 46);
    self.authCodeButton.frame = CGRectMake(0, 0, 100, 46);
    self.secureButton.frame = CGRectMake(0, 0, 46, 46);
    
    [self.controlArray mas_distributeViewsAlongAxis:(MASAxisTypeVertical)
                                withFixedItemLength:46
                                        leadSpacing:0
                                        tailSpacing:0];
    [self.controlArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).with.offset(30);
        make.height.mas_equalTo(46);
    }];
    
    [self.phoneTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                      width:0.5
                                      color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.authCodeTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                         width:0.5
                                         color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.pwdTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                    width:0.5
                                    color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.containerView.mas_bottom).with.offset(10);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.containerView.mas_bottom).with.offset(58);
        make.height.mas_equalTo(46);
    }];
    
    [self.signUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.doneButton.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.thirdLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-85);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(self);
        make.top.equalTo(self.thirdLoginLabel.mas_bottom).with.offset(5);
    }];
    [self.wechatButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:20];
    
}

/**
 绘制 LOGO 分割线
 */
- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(48, SCREEN_HEIGHT - 100))
                          end:(CGPointMake(SCREEN_WIDTH - 48, SCREEN_HEIGHT - 100))
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9" alpha:1]];
    
    [UIView drawRectLineStart:(CGPointMake(100, 175))
                          end:(CGPointMake(100, 185))
                        width:1.0
                        color:[UIColor colorWithHexString:@"#999999"]];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightSemibold)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = kTitleLabelText;
    }
    return _titleLabel;
}

- (UISegmentedControl *)loginSegmented {
    if (!_loginSegmented) {
        _loginSegmented = [[UISegmentedControl alloc] initWithItems:@[@"密码登录", @"动态码登录"]];
        _loginSegmented.selectedSegmentIndex = 0;
        _loginSegmented.tintColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        [_loginSegmented setContentOffset:(CGSizeMake(-18, 0)) forSegmentAtIndex:0];
        [_loginSegmented setContentOffset:(CGSizeMake(-10, 0)) forSegmentAtIndex:1];
        [_loginSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"],
                                                  NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]}
                                       forState:(UIControlStateNormal)];
        [_loginSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kColorMain],
                                                  NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]}
                                       forState:(UIControlStateSelected)];
        
        [_loginSegmented addTarget:self action:@selector(loginSegmentedControlAction:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _loginSegmented;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIButton *)zipCodeButton {
    if (!_zipCodeButton) {
        _zipCodeButton = [[UIButton alloc] init];
        [_zipCodeButton setTitle:kZipCodeDefault forState:(UIControlStateNormal)];
        [_zipCodeButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_zipCodeButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -22, 0, 0))];
        _zipCodeButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        _zipCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_zipCodeButton setImage:[UIImage imageNamed:@"icon_down_gray"] forState:(UIControlStateNormal)];
        [_zipCodeButton setImageEdgeInsets:(UIEdgeInsetsMake(17, 48, 17, 20))];
        [_zipCodeButton addTarget:self action:@selector(zipCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _zipCodeButton;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.leftView = self.zipCodeButton;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.placeholder = kPhonePlaceholder;
        _phoneTextField.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
        _phoneTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneTextField;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.rightView = self.secureButton;
        _pwdTextField.rightViewMode = UITextFieldViewModeAlways;
        _pwdTextField.placeholder = kPwdPlaceholder;
        _pwdTextField.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
        _pwdTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}

- (UIButton *)secureButton {
    if (!_secureButton) {
        _secureButton = [[UIButton alloc] init];
        [_secureButton setImage:[UIImage imageNamed:@"icon_secure_no"] forState:(UIControlStateNormal)];
        [_secureButton setImage:[UIImage imageNamed:@"icon_secure_yes"] forState:(UIControlStateSelected)];
        [_secureButton setImageEdgeInsets:(UIEdgeInsetsMake(13, 26, 13, 0))];
        _secureButton.selected = NO;
        [_secureButton addTarget:self action:@selector(secureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _secureButton;
}

- (UIButton *)authCodeButton {
    if (!_authCodeButton) {
        _authCodeButton = [[UIButton alloc] init];
        [_authCodeButton setTitle:kAuthCodeButtonTitle forState:(UIControlStateNormal)];
        [_authCodeButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _authCodeButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        _authCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_authCodeButton addTarget:self action:@selector(authCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _authCodeButton;
}

- (UITextField *)authCodeTextField {
    if (!_authCodeTextField) {
        _authCodeTextField = [[UITextField alloc] init];
        _authCodeTextField.rightView = self.authCodeButton;
        _authCodeTextField.rightViewMode = UITextFieldViewModeAlways;
        _authCodeTextField.placeholder = kAuthPlaceholder;
        _authCodeTextField.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
        _authCodeTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _authCodeTextField;
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

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc] init];
        [_forgetButton setTitle:kForgetButtonTitle forState:(UIControlStateNormal)];
        [_forgetButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetButton addTarget:self action:@selector(forgetButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _forgetButton;
}

- (YYLabel *)signUpLabel {
    if (!_signUpLabel) {
        _signUpLabel = [[YYLabel alloc] init];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:kSignUpText];
        attText.yy_font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        attText.yy_color = [UIColor colorWithHexString:@"#333333"];
        attText.yy_alignment = NSTextAlignmentCenter;
        [attText yy_setTextHighlightRange:NSMakeRange(6, 4)
                                    color:[UIColor colorWithHexString:kColorMain]
                          backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                                tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                    [SVProgressHUD showInfoWithStatus:@"注册账号"];
                                }];
        
        _signUpLabel.attributedText = attText;
    }
    return _signUpLabel;
}

- (UILabel *)thirdLoginLabel {
    if (!_thirdLoginLabel) {
        _thirdLoginLabel = [[UILabel alloc] init];
        _thirdLoginLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _thirdLoginLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        _thirdLoginLabel.text = kThirdLoginText;
        _thirdLoginLabel.textAlignment = NSTextAlignmentCenter;
        _thirdLoginLabel.backgroundColor = [UIColor whiteColor];
    }
    return _thirdLoginLabel;
}

- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [[UIButton alloc] init];
        [_wechatButton setImage:[UIImage imageNamed:@"icon_wechat_white"] forState:(UIControlStateNormal)];
        [_wechatButton addTarget:self action:@selector(wechatButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _wechatButton.backgroundColor = [UIColor colorWithHexString:@"#3DBD7D"];
    }
    return _wechatButton;
}


@end