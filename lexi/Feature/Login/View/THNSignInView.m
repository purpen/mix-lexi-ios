//
//  THNSignInView.m
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignInView.h"
#import <YYText/YYText.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNPasswordTextField.h"
#import "THNAuthCodeButton.h"
#import "THNDoneButton.h"

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
/// 动态登录的 key
static NSString *const kParamAreaCode       = @"areacode";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamPassword       = @"password";
static NSString *const kParamVerifyCode     = @"verify_code";

@interface THNSignInView () <UITextFieldDelegate>

/// 登录方式切换
@property (nonatomic, strong) UISegmentedControl *loginSegmented;
/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 手机区号
@property (nonatomic, strong) UIButton *zipCodeButton;
/// 手机号输入框
@property (nonatomic, strong) UITextField *phoneTextField;
/// 密码输入框
@property (nonatomic, strong) THNPasswordTextField *pwdTextField;
/// 验证码输入框
@property (nonatomic, strong) UITextField *authCodeTextField;
/// 获取验证码按钮
@property (nonatomic, strong) THNAuthCodeButton *authCodeButton;
/// 完成（登录）按钮
@property (nonatomic, strong) THNDoneButton *doneButton;
/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetButton;
/// 已有账号，去登录提示
@property (nonatomic, strong) YYLabel *signUpLabel;
/// 第三方登录提示
@property (nonatomic, strong) UILabel *thirdLoginLabel;
/// 错误提示
@property (nonatomic, strong) UILabel *errorHintLabel;
/// 微信登录
@property (nonatomic, strong) UIButton *wechatButton;
/// 保存加载控件
@property (nonatomic, strong) NSArray *controlArray;
/// 登录方式
@property (nonatomic, assign) THNLoginModeType loginModeType;
/// 获取的验证码
@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation THNSignInView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setVerifyCode:(NSString *)code {
    self.verifyCode = code;
}

- (void)thn_setAreaCode:(NSString *)code {
    [self.zipCodeButton setTitle:code forState:(UIControlStateNormal)];
}

- (void)thn_setErrorHintText:(NSString *)text {
    self.errorHintLabel.text = text;
    [self thn_showErrorHint:YES];
}

#pragma mark - private methods
/**
 登录
 */
- (void)thn_doneButtonAction {
    WEAKSELF;
    
    [weakSelf endEditing:YES];
    [weakSelf thn_showErrorHint:NO];
    
    if (![[weakSelf getPhoneNum] checkTel]) {
        [weakSelf thn_setErrorHintText:@"请输入正确的手机号"];
        return;
    }
    
    if (weakSelf.loginModeType == THNLoginModeTypePassword) {
        if (![weakSelf getPassword].length) {
            [weakSelf thn_setErrorHintText:@"请输入密码"];
            return;
        }
        
    } else if (weakSelf.loginModeType == THNLoginModeTypeVeriDynamic) {
        if (![weakSelf getVerifyCode].length) {
            [weakSelf thn_setErrorHintText:@"请输入验证码"];
            return;
        }
    }
    
    NSDictionary *paramDict = [weakSelf getRequestParamsWithType:weakSelf.loginModeType];
    
    if ([weakSelf.delegate respondsToSelector:@selector(thn_signInWithParam:loginModeType:)]) {
        [weakSelf.delegate thn_signInWithParam:paramDict
                                 loginModeType:weakSelf.loginModeType];
    }
}


#pragma mark - event response
- (void)authCodeButtonAction:(THNAuthCodeButton *)button {
    WEAKSELF;
    
    if (![[weakSelf getPhoneNum] checkTel]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if ([weakSelf.delegate respondsToSelector:@selector(thn_sendAuthCodeWithPhoneNum:zipCode:)]) {
        [weakSelf.delegate thn_sendAuthCodeWithPhoneNum:[weakSelf getPhoneNum]
                                                zipCode:[weakSelf getZipCode]];
    }
    
    [weakSelf.authCodeTextField becomeFirstResponder];
    [button thn_countdownStartTime:60 completion:nil];
}

- (void)zipCodeButtonAction:(UIButton *)button {
    [self thn_showErrorHint:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_showZipCodeList)]) {
        [self.delegate thn_showZipCodeList];
    }
}

- (void)wechatButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"微信登录"];
}

- (void)forgetButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_forgetPassword)]) {
        [self.delegate thn_forgetPassword];
    }
}

- (void)loginSegmentedControlAction:(UISegmentedControl *)segment {
    [self endEditing:YES];
    [self thn_showErrorHint:NO];
    
    [self thn_changeLoginPasswordMethod:!(BOOL)segment.selectedSegmentIndex];

    if (segment.selectedSegmentIndex == 1) {
        self.loginModeType = THNLoginModeTypeVeriDynamic;
        
        if ([self.pwdTextField isFirstResponder]) {
            [self.pwdTextField resignFirstResponder];
            [self.authCodeTextField becomeFirstResponder];
        }
        
        if (self.pwdTextField.text.length) {
            self.pwdTextField.text = @"";
        }
        
    } else {
        self.loginModeType = THNLoginModeTypePassword;
        
        if ([self.authCodeTextField isFirstResponder]) {
            [self.authCodeTextField resignFirstResponder];
            [self.pwdTextField becomeFirstResponder];
        }
        
        if (self.authCodeTextField.text.length) {
            self.authCodeTextField.text = @"";
        }
    }
}

/**
 切换密码登录
 */
- (void)thn_changeLoginPasswordMethod:(BOOL)change {
    [UIView animateWithDuration:0.3 animations:^{
        self.pwdTextField.alpha = change ? 1 : 0;
        self.authCodeTextField.alpha = change ? 0 : 1;
    }];
}

/**
 展示错误提示
 */
- (void)thn_showErrorHint:(BOOL)show {
    self.errorHintLabel.hidden = !show;
}

/**
 获取输入的手机号
 */
- (NSString *)getPhoneNum {
    return self.phoneTextField.text;
}

/**
 获取手机区号
 */
- (NSString *)getZipCode {
    return self.zipCodeButton.titleLabel.text;
}

/**
 获取短信验证码
 */
- (NSString *)getVerifyCode {
    return self.authCodeTextField.text;
}

/**
 获取密码
 */
- (NSString *)getPassword {
    return self.pwdTextField.text;
}

/**
 获取手机号后的附加参数

 @param type 登录类型
 @return 附加参数
 */
- (NSString *)getExtraParamWithLoginModeType:(THNLoginModeType)type {
    NSString *extraParam = nil;
    
    switch (type) {
        case THNLoginModeTypePassword:
            extraParam = [self getPassword];
            break;
            
        case THNLoginModeTypeVeriDynamic:
            extraParam = [self getVerifyCode];
    }
    
    return extraParam;
}

/**
 获取登录时 POST 的参数

 @param type 登录类型
 @return 请求参数
 */
- (NSDictionary *)getRequestParamsWithType:(THNLoginModeType)type {
    NSDictionary *paramDict = [NSDictionary dictionary];
    
    if (type == THNLoginModeTypeVeriDynamic) {
        paramDict = @{kParamEmail: [self getPhoneNum],
                      kParamAreaCode: [self getZipCode],
                      kParamVerifyCode: [self getExtraParamWithLoginModeType:THNLoginModeTypeVeriDynamic]};
        
    } else if (type == THNLoginModeTypePassword) {
        paramDict = @{kParamEmail: [self getPhoneNum],
                      kParamPassword: [self getExtraParamWithLoginModeType:THNLoginModeTypePassword]};
    }
    
    return paramDict;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.title = kTitleLabelText;
    self.loginModeType = THNLoginModeTypePassword;
    
    [self addSubview:self.loginSegmented];
    [self.containerView addSubview:self.phoneTextField];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.pwdTextField];
    [self addSubview:self.doneButton];
    [self addSubview:self.containerView];
    [self addSubview:self.forgetButton];
    [self addSubview:self.signUpLabel];
    [self addSubview:self.errorHintLabel];
    [self addSubview:self.thirdLoginLabel];
    [self addSubview:self.wechatButton];
    
    self.controlArray = @[self.phoneTextField, self.authCodeTextField];
    
    [self thn_changeLoginPasswordMethod:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.loginSegmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(kDeviceiPhoneX ? 164 : 144);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.loginSegmented.mas_bottom).with.offset(20);
        make.height.mas_equalTo(122);
    }];
    
    self.zipCodeButton.frame = CGRectMake(0, 0, 80, 46);
    
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
        make.top.equalTo(self.phoneTextField.mas_bottom).with.offset(30);
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
        make.top.equalTo(self.containerView.mas_bottom).with.offset(5);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.containerView.mas_bottom).with.offset(55);
        make.height.mas_equalTo(45);
    }];
    
    [self.signUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.doneButton.mas_bottom).with.offset(25);
        make.height.mas_equalTo(30);
    }];
    
    [self.errorHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.forgetButton);
    }];
    
    [self.thirdLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-70);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(self);
        make.top.equalTo(self.thirdLoginLabel.mas_bottom).with.offset(5);
    }];
    [self.wechatButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:20];
    
}

/**
 绘制分割线
 */
- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(48, SCREEN_HEIGHT - 85))
                          end:(CGPointMake(SCREEN_WIDTH - 48, SCREEN_HEIGHT - 85))
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9" alpha:1]];
    
    [UIView drawRectLineStart:(CGPointMake(100, CGRectGetMinY(self.loginSegmented.frame) + 10))
                          end:(CGPointMake(100, CGRectGetMaxY(self.loginSegmented.frame) - 10))
                        width:1.0
                        color:[UIColor colorWithHexString:@"#999999"]];
}

#pragma mark - getters and setters
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

- (THNPasswordTextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[THNPasswordTextField alloc] initWithPlaceholderText:kPwdPlaceholder];
    }
    return _pwdTextField;
}

- (THNAuthCodeButton *)authCodeButton {
    if (!_authCodeButton) {
        _authCodeButton = [[THNAuthCodeButton alloc] init];
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

- (THNDoneButton *)doneButton {
    if (!_doneButton) {
        WEAKSELF;
        _doneButton = [THNDoneButton thn_initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 75)
                                             withTitle:kDoneButtonTitle
                                            completion:^{
                                                [weakSelf thn_doneButtonAction];
                                            }];
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
        
        WEAKSELF;
        [attText yy_setTextHighlightRange:NSMakeRange(6, 4)
                                    color:[UIColor colorWithHexString:kColorMain]
                          backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                                tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                    if ([weakSelf.delegate respondsToSelector:@selector(thn_goToRegister)]) {
                                        [weakSelf.delegate thn_goToRegister];
                                    }
                                }];
        
        _signUpLabel.attributedText = attText;
    }
    return _signUpLabel;
}

- (UILabel *)errorHintLabel {
    if (!_errorHintLabel) {
        _errorHintLabel = [[UILabel alloc] init];
        _errorHintLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _errorHintLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _errorHintLabel.backgroundColor = [UIColor whiteColor];
        _errorHintLabel.hidden = YES;
    }
    return _errorHintLabel;
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
