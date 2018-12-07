//
//  THNBindPhoneView.m
//  lexi
//
//  Created by FLYang on 2018/12/7.
//  Copyright © 2018 lexi. All rights reserved.
//

#import "THNBindPhoneView.h"
#import <YYKit/YYKit.h>
#import "SVProgressHUD+Helper.h"
#import "THNAuthCodeButton.h"
#import "THNDoneButton.h"

/// text
static NSString *const kTitleLabelText      = @"立即绑定";
static NSString *const kZipCodeDefault      = @"+86";
static NSString *const kPhonePlaceholder    = @"请输入手机号码";
static NSString *const kAuthPlaceholder     = @"请输入手机动态码";
static NSString *const kDoneButtonTitle     = @"立即绑定";
static NSString *const kProtocolText        = @"绑定代表同意乐喜《服务条款》和《隐私条款》";
/// url
static NSString *const kUrlService = @"https://h5.lexivip.com/site/service_agreement";
static NSString *const kUrlPrivacy = @"https://h5.lexivip.com/site/privacy";

@interface THNBindPhoneView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *zipCodeButton;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *authCodeTextField;
@property (nonatomic, strong) THNAuthCodeButton *authCodeButton;
@property (nonatomic, strong) THNDoneButton *doneButton;
@property (nonatomic, strong) NSArray *controlArray;
@property (nonatomic, strong) UILabel *errorHintLabel;
@property (nonatomic, strong) YYLabel *protocolLabel;
@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation THNBindPhoneView

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
- (void)thn_doneButtonAction {
    [self endEditing:YES];
    [self thn_showErrorHint:NO];
    
    if (![self getPhoneNum].length) {
        [SVProgressHUD thn_showInfoWithStatus:kPhonePlaceholder];
        return;
    }
    
    if (![self getVerifyCode].length) {
        [self thn_setErrorHintText:kAuthPlaceholder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_bindPhoneWithPhoneNum:zipCode:verifyCode:)]) {
        [self.delegate thn_bindPhoneWithPhoneNum:[self getPhoneNum]
                                         zipCode:[self getZipCode]
                                      verifyCode:[self getVerifyCode]];
    }
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

- (void)thn_showErrorHint:(BOOL)show {
    self.errorHintLabel.hidden = !show;
}

#pragma mark - event response
- (void)authCodeButtonAction:(THNAuthCodeButton *)button {
    if (![self getPhoneNum].length) {
        [SVProgressHUD thn_showInfoWithStatus:kPhonePlaceholder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_bindSendAuthCodeWithPhoneNum:zipCode:)]) {
        [self.delegate thn_bindSendAuthCodeWithPhoneNum:[self getPhoneNum] zipCode:[self getZipCode]];
    }
    
    [self.authCodeTextField becomeFirstResponder];
    [button thn_countdownStartTime:60 completion:nil];
}

- (void)zipCodeButtonAction:(UIButton *)button {
    [self thn_showErrorHint:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_bindShowZipCodeList)]) {
        [self.delegate thn_bindShowZipCodeList];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.title = kTitleLabelText;
    
    [self.containerView addSubview:self.phoneTextField];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.doneButton];
    [self addSubview:self.containerView];
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
    
    [self.controlArray mas_distributeViewsAlongAxis:(MASAxisTypeVertical)
                                withFixedItemLength:46
                                        leadSpacing:0
                                        tailSpacing:0];
    [self.controlArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.errorHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 13));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.authCodeTextField.mas_bottom).with.offset(5);
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.phoneTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                      width:0.5
                                      color:[UIColor colorWithHexString:@"#DADADA"]];
    
    [self.authCodeTextField drawViewBorderType:(UIViewBorderLineTypeBottom)
                                         width:0.5
                                         color:[UIColor colorWithHexString:@"#DADADA"]];
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

- (YYLabel *)protocolLabel {
    if (!_protocolLabel) {
        _protocolLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:kProtocolText];
        attText.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        attText.color = [UIColor colorWithHexString:@"#B2B2B2"];
        attText.alignment = NSTextAlignmentCenter;
        
        WEAKSELF;
        [attText setTextHighlightRange:NSMakeRange(8, 6)
                                 color:[UIColor colorWithHexString:@"#2A2A2A"]
                       backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                 if ([weakSelf.delegate respondsToSelector:@selector(thn_bindCheckProtocolUrl:)]) {
                                     [weakSelf.delegate thn_bindCheckProtocolUrl:kUrlService];
                                 }
                             }];
        
        [attText setTextHighlightRange:NSMakeRange(15, 6)
                                 color:[UIColor colorWithHexString:@"#2A2A2A"]
                       backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                 if ([weakSelf.delegate respondsToSelector:@selector(thn_bindCheckProtocolUrl:)]) {
                                     [weakSelf.delegate thn_bindCheckProtocolUrl:kUrlPrivacy];
                                 }
                             }];
        
        _protocolLabel.attributedText = attText;
    }
    return _protocolLabel;
}

@end