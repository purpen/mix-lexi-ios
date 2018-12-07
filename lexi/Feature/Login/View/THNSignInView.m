//
//  THNSignInView.m
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignInView.h"
#import <YYKit/YYKit.h>
#import "SVProgressHUD+Helper.h"
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
static NSString *const kLoginPwd            = @"密码登录";
static NSString *const kLoginAuth           = @"动态码登录";
/// 动态登录的 key
static NSString *const kParamAreaCode       = @"areacode";
static NSString *const kParamEmail          = @"email";
static NSString *const kParamPassword       = @"password";
static NSString *const kParamVerifyCode     = @"verify_code";

@interface THNSignInView () <UITextFieldDelegate>

@property (nonatomic, strong) UISegmentedControl *loginSegmented;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *zipCodeButton;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) THNPasswordTextField *pwdTextField;
@property (nonatomic, strong) UITextField *authCodeTextField;
@property (nonatomic, strong) THNAuthCodeButton *authCodeButton;
@property (nonatomic, strong) THNDoneButton *doneButton;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) YYLabel *signUpLabel;
@property (nonatomic, strong) UILabel *thirdLoginLabel;
@property (nonatomic, strong) UILabel *errorHintLabel;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) NSArray *controlArray;
@property (nonatomic, assign) THNLoginModeType loginModeType;
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

#pragma mark - event response
- (void)thn_doneButtonAction {
    [self endEditing:YES];
    [self thn_showErrorHint:NO];
    
    if (![self getPhoneNum].length) {
        [self thn_setErrorHintText:kPhonePlaceholder];
        return;
    }
    
    if (self.loginModeType == THNLoginModeTypePassword) {
        if (![self getPassword].length) {
            [self thn_setErrorHintText:kPwdPlaceholder];
            return;
        }
        
    } else if (self.loginModeType == THNLoginModeTypeVeriDynamic) {
        if (![self getVerifyCode].length) {
            [self thn_setErrorHintText:kAuthPlaceholder];
            return;
        }
    }
    
    NSDictionary *paramDict = [self getRequestParamsWithType:self.loginModeType];
    
    if ([self.delegate respondsToSelector:@selector(thn_signInWithParam:loginModeType:)]) {
        [self.delegate thn_signInWithParam:paramDict loginModeType:self.loginModeType];
    }
}

- (void)authCodeButtonAction:(THNAuthCodeButton *)button {
    if (![self getPhoneNum].length) {
        [SVProgressHUD thn_showInfoWithStatus:kPhonePlaceholder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_signInSendAuthCodeWithPhoneNum:zipCode:)]) {
        [self.delegate thn_signInSendAuthCodeWithPhoneNum:[self getPhoneNum]
                                                  zipCode:[self getZipCode]];
    }
    
    [button thn_countdownStartTime:60 completion:nil];
}

- (void)zipCodeButtonAction:(UIButton *)button {
    [self thn_showErrorHint:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_signInShowZipCodeList)]) {
        [self.delegate thn_signInShowZipCodeList];
    }
}

- (void)wechatButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_signInUseWechatLogin)]) {
        [self.delegate thn_signInUseWechatLogin];
    }
}

- (void)forgetButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_signInForgetPassword)]) {
        [self.delegate thn_signInForgetPassword];
    }
}

- (void)loginSegmentedControlAction:(UISegmentedControl *)segment {
    [self endEditing:YES];
    [self thn_showErrorHint:NO];
    [self thn_changeLoginPasswordMethod:!(BOOL)segment.selectedSegmentIndex];
    
    self.loginModeType = (THNLoginModeType)segment.selectedSegmentIndex;
}

- (void)thn_changeLoginPasswordMethod:(BOOL)change {
    self.pwdTextField.text = @"";
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pwdTextField.alpha = change ? 1 : 0;
        self.authCodeTextField.alpha = change ? 0 : 1;
    }];
}

- (void)thn_showErrorHint:(BOOL)show {
    self.errorHintLabel.hidden = !show;
}

- (NSString *)getPhoneNum {
    return self.phoneTextField.text;
}

- (NSString *)getZipCode {
    return self.zipCodeButton.titleLabel.text;
}

- (NSString *)getVerifyCode {
    return self.authCodeTextField.text;
}

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
    self.controlArray = @[self.phoneTextField, self.authCodeTextField];
    
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
    
    [self.phoneTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                      width:0.5
                                      color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.authCodeTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                         width:0.5
                                         color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.pwdTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                    width:0.5
                                    color:[UIColor colorWithHexString:@"#DADADA"]];
    
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
        _loginSegmented = [[UISegmentedControl alloc] initWithItems:@[kLoginPwd, kLoginAuth]];
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
        _zipCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 46)];
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
        
        _doneButton = [[THNDoneButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 75)
                                                     title:kDoneButtonTitle
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
        attText.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        attText.color = [UIColor colorWithHexString:@"#333333"];
        attText.alignment = NSTextAlignmentCenter;
        
        WEAKSELF;
        [attText setTextHighlightRange:NSMakeRange(6, 4)
                                    color:[UIColor colorWithHexString:kColorMain]
                          backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                                tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                    if ([weakSelf.delegate respondsToSelector:@selector(thn_signInToRegister)]) {
                                        [weakSelf.delegate thn_signInToRegister];
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
