
//
//  THNFindPasswordView.m
//  lexi
//
//  Created by FLYang on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFindPasswordView.h"
#import "THNAuthCodeButton.h"
#import "THNDoneButton.h"
#import "SVProgressHUD+Helper.h"
#import <Masonry/Masonry.h>

static NSString *const kTitleLabelText      = @"找回密码";
static NSString *const kZipCodeDefault      = @"+86";
static NSString *const kPhonePlaceholder    = @"请输入手机号码";
static NSString *const kAuthPlaceholder     = @"请输入手机动态码";
static NSString *const kDoneButtonTitle     = @"设置密码";

@interface THNFindPasswordView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *zipCodeButton;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *authCodeTextField;
@property (nonatomic, strong) THNAuthCodeButton *authCodeButton;
@property (nonatomic, strong) THNDoneButton *doneButton;
@property (nonatomic, strong) UILabel *errorHintLabel;
@property (nonatomic, strong) NSArray *controlArray;
@property (nonatomic, strong) NSString *verifyCode;;

@end

@implementation THNFindPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    
    if (!self.phoneTextField.text.length) {
        [SVProgressHUD thn_showInfoWithStatus:kPhonePlaceholder];
        return;
    }
    
    if (![self getVerifyCode].length) {
        [self thn_setErrorHintText:kAuthPlaceholder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_findPwdSetPasswordWithPhoneNum:zipCode:verifyCode:)]) {
        [self.delegate thn_findPwdSetPasswordWithPhoneNum:[self getPhoneNum]
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
    
    WEAKSELF;
    if ([weakSelf.delegate respondsToSelector:@selector(thn_findPwdSendAuthCodeWithPhoneNum:zipCode:)]) {
        [weakSelf.delegate thn_findPwdSendAuthCodeWithPhoneNum:[weakSelf getPhoneNum]
                                                zipCode:[weakSelf getZipCode]];
    }
    
    [self.authCodeTextField becomeFirstResponder];
    [button thn_countdownStartTime:60 completion:nil];
}

- (void)zipCodeButtonAction:(UIButton *)button {
    [self thn_showErrorHint:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_findPwdShowZipCodeList)]) {
        [self.delegate thn_findPwdShowZipCodeList];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.title = kTitleLabelText;
    self.controlArray = @[self.phoneTextField, self.authCodeTextField, self.doneButton];
    
    [self.containerView addSubview:self.phoneTextField];
    [self.containerView addSubview:self.authCodeTextField];
    [self.containerView addSubview:self.doneButton];
    [self addSubview:self.containerView];
    [self addSubview:self.errorHintLabel];
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

@end
