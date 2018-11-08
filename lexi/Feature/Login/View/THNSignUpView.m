//
//  THNSignUpView.m
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignUpView.h"
#import <YYKit/YYKit.h>
#import "SVProgressHUD+Helper.h"
#import "THNAuthCodeButton.h"
#import "THNDoneButton.h"
#import "THNWebKitViewViewController.h"

static NSString *const kTitleLabelText      = @"注册";
static NSString *const kZipCodeDefault      = @"+86";
static NSString *const kPhonePlaceholder    = @"请输入手机号码";
static NSString *const kAuthPlaceholder     = @"请输入手机动态码";
static NSString *const kDoneButtonTitle     = @"下一步设置密码";
static NSString *const kSignInText          = @"已有账号？点击登录";
static NSString *const kProtocolText        = @"注册代表同意乐喜《服务条款》和《隐私条款》";
///
static NSString *const kUrlService = @"https://h5.lexivip.com/site/service_agreement";
static NSString *const kUrlPrivacy = @"https://h5.lexivip.com/site/privacy";

@interface THNSignUpView () {
    NSString *_verifyCode;
}

/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 手机区号
@property (nonatomic, strong) UIButton *zipCodeButton;
/// 手机号输入框
@property (nonatomic, strong) UITextField *phoneTextField;
/// 验证码输入框
@property (nonatomic, strong) UITextField *authCodeTextField;
/// 获取验证码按钮
@property (nonatomic, strong) THNAuthCodeButton *authCodeButton;
/// 完成（下一步）按钮
@property (nonatomic, strong) THNDoneButton *doneButton;
/// 记录加载控件
@property (nonatomic, strong) NSArray *controlArray;
/// 错误提示
@property (nonatomic, strong) UILabel *errorHintLabel;
/// 已有账号，去登录提示
@property (nonatomic, strong) YYLabel *signInLabel;
/// 用户协议提示
@property (nonatomic, strong) YYLabel *protocolLabel;

@end

@implementation THNSignUpView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setVerifyCode:(NSString *)code {
    _verifyCode = code;
}

- (void)thn_setAreaCode:(NSString *)code {
    [self.zipCodeButton setTitle:code forState:(UIControlStateNormal)];
}

- (void)thn_setErrorHintText:(NSString *)text {
    self.errorHintLabel.text = text;
    [self thn_showErrorHint:YES];
}

#pragma mark - private methods
- (void)thn_doneButtonAction {
    [self endEditing:YES];
    [self thn_showErrorHint:NO];
    
    if (![[self getPhoneNum] checkTel]) {
        [SVProgressHUD thn_showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (![self getVerifyCode].length) {
        [self thn_setErrorHintText:@"请输入验证码"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_signUpSetPasswordWithPhoneNum:zipCode:verifyCode:)]) {
        [self.delegate thn_signUpSetPasswordWithPhoneNum:[self getPhoneNum]
                                                 zipCode:[self getZipCode]
                                              verifyCode:[self getVerifyCode]];
    }
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
 展示错误提示
 */
- (void)thn_showErrorHint:(BOOL)show {
    self.errorHintLabel.hidden = !show;
}

#pragma mark - event response
- (void)authCodeButtonAction:(THNAuthCodeButton *)button {
    if (![[self getPhoneNum] checkTel]) {
        [SVProgressHUD thn_showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    WEAKSELF;
    if ([weakSelf.delegate respondsToSelector:@selector(thn_sendAuthCodeWithPhoneNum:zipCode:)]) {
        [weakSelf.delegate thn_sendAuthCodeWithPhoneNum:[weakSelf getPhoneNum]
                                                zipCode:[weakSelf getZipCode]];
    }

    [self.authCodeTextField becomeFirstResponder];
    [button thn_countdownStartTime:60 completion:nil];
}

- (void)zipCodeButtonAction:(UIButton *)button {
    [self thn_showErrorHint:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_showZipCodeList)]) {
        [self.delegate thn_showZipCodeList];
    }
}

- (void)thn_openWebViewControllerWithUrl:(NSString *)url {
    THNWebKitViewViewController *webVC = [[THNWebKitViewViewController alloc] init];
    webVC.url = url;
    [self.currentVC.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.title = kTitleLabelText;
    
    [self.containerView addSubview:self.phoneTextField];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.doneButton];
    [self addSubview:self.containerView];
    [self addSubview:self.signInLabel];
    [self addSubview:self.errorHintLabel];
    [self addSubview:self.protocolLabel];
    
    self.controlArray = @[self.phoneTextField, self.authCodeTextField, self.doneButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(kDeviceiPhoneX ? 164 : 144);
        make.height.mas_equalTo(198);
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

    [self.phoneTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                      width:0.5
                                      color:[UIColor colorWithHexString:@"#DADADA"]];

    [self.authCodeTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                         width:0.5
                                         color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.errorHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 13));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.authCodeTextField.mas_bottom).with.offset(5);
    }];
    
    [self.signInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.containerView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
    
}

#pragma mark - getters and setters
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
        _doneButton = [[THNDoneButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 75)
                                                 withTitle:kDoneButtonTitle
                                                completion:^{
                                                    [self thn_doneButtonAction];
                                                }];
    }
    return _doneButton;
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

- (YYLabel *)signInLabel {
    if (!_signInLabel) {
        _signInLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:kSignInText];
        attText.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        attText.color = [UIColor colorWithHexString:@"#333333"];
        attText.alignment = NSTextAlignmentCenter;
        
        WEAKSELF;
        [attText setTextHighlightRange:NSMakeRange(5, 4)
                                 color:[UIColor colorWithHexString:kColorMain]
                       backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                 if ([weakSelf.delegate respondsToSelector:@selector(thn_directLogin)]) {
                                     [weakSelf.delegate thn_directLogin];
                                 }
                             }];
        
        _signInLabel.attributedText = attText;
    }
    return _signInLabel;
}

- (YYLabel *)protocolLabel {
    if (!_protocolLabel) {
        WEAKSELF;
        
        _protocolLabel = [[YYLabel alloc] init];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:kProtocolText];
        attText.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        attText.color = [UIColor colorWithHexString:@"#B2B2B2"];
        attText.alignment = NSTextAlignmentCenter;
        [attText setTextHighlightRange:NSMakeRange(8, 6)
                                    color:[UIColor colorWithHexString:@"#2A2A2A"]
                          backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                                tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                    [weakSelf thn_openWebViewControllerWithUrl:kUrlService];
                                }];
        
        [attText setTextHighlightRange:NSMakeRange(15, 6)
                                    color:[UIColor colorWithHexString:@"#2A2A2A"]
                          backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                                tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                    [weakSelf thn_openWebViewControllerWithUrl:kUrlPrivacy];
                                }];
        
        _protocolLabel.attributedText = attText;
    }
    return _protocolLabel;
}

@end
