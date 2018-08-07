//
//  THNUserApplyView.m
//  lexi
//
//  Created by FLYang on 2018/8/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserApplyView.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>
#import "THNAuthCodeButton.h"

static NSString *const kDoneButtonTitle     = @"开通生活馆";
static NSString *const kTextTitle           = @"乐喜生活馆";
static NSString *const kTextSlogan          = @"做自己热爱的事，顺便赚取收入";
static NSString *const kTextVerify          = @"获取验证码";
static NSString *const kPlaceholderName     = @"输入您的真实姓名";
static NSString *const kPlaceholderWork     = @"你的职业";
static NSString *const kPlaceholderPhone    = @"输入手机号";
static NSString *const kPlaceholderVerify   = @"输入验证码";
static NSString *const kDefaultArea         = @"+86";
static NSInteger const kTextFieldTag        = 183;
/// key
static NSString *const kParamAreaCode       = @"areacode";
static NSString *const kParamMobile         = @"mobile";
static NSString *const kParamName           = @"name";
static NSString *const kParamWork           = @"profession";
static NSString *const kParamVerifyCode     = @"verify_code";

@interface THNUserApplyView ()

/// 头图背景
@property (nonatomic, strong) UIImageView *headerImageView;
/// LOGO
@property (nonatomic, strong) UIImageView *logoImageView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// slogan
@property (nonatomic, strong) UILabel *sloganLabel;
/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 记录输入框
@property (nonatomic, strong) NSMutableArray *textFieldArray;
/// 错误提示
@property (nonatomic, strong) UILabel *errorHintLabel;
/// 区号按钮
@property (nonatomic, strong) UIButton *areaButton;
/// 获取验证码按钮
@property (nonatomic, strong) THNAuthCodeButton *authCodeButton;
/// 获取验证码视图
@property (nonatomic, strong) UIView *authCodeView;
/// 获取的验证码
@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation THNUserApplyView

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

#pragma mark - public methods
- (void)thn_setVerifyCode:(NSString *)code {
    self.verifyCode = code;
}

- (void)thn_setAreaCode:(NSString *)code {
    [self.areaButton setTitle:code forState:(UIControlStateNormal)];
}

- (void)thn_setErrorHintText:(NSString *)text {
    self.errorHintLabel.text = text;
    [self thn_showErrorHint:YES];
}

#pragma mark - event response
- (void)thn_doneButtonAction:(UIButton *)button {
    WEAKSELF;
    
    [weakSelf endEditing:YES];
    [weakSelf thn_showErrorHint:NO];
    
    if (![weakSelf getName].length) {
        [weakSelf thn_setErrorHintText:@"请输入您的真实姓名"];
        return;
    }
    
    if (![[weakSelf getPhoneNum] checkTel]) {
        [weakSelf thn_setErrorHintText:@"请输入正确的手机号"];
        return;
    }
    
    if (![weakSelf getVerifyCode].length) {
        [weakSelf thn_setErrorHintText:@"请输入验证码"];
        return;
    }
    
    if ([weakSelf.delegate respondsToSelector:@selector(thn_applyLifeStoreWithParam:)]) {
        [weakSelf.delegate thn_applyLifeStoreWithParam:@{kParamName: [weakSelf getName],
                                                         kParamWork: [weakSelf getWork],
                                                         kParamMobile: [weakSelf getPhoneNum],
                                                         kParamAreaCode: [weakSelf getZipCode],
                                                         kParamVerifyCode: [weakSelf getVerifyCode]}];
    }
}

- (void)areaButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_showZipCodeList)]) {
        [self.delegate thn_showZipCodeList];
    }
}

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
    
    [button thn_countdownStartTime:60 completion:nil];
}

#pragma mark - private methods
// 展示错误提示
- (void)thn_showErrorHint:(BOOL)show {
    self.errorHintLabel.hidden = !show;
}

// 获取指定的输入框
- (UITextField *)getTextFieldWithTag:(NSInteger)tag {
    for (UITextField *textField in self.textFieldArray) {
        if (textField.tag == kTextFieldTag + tag) {
            return textField;
        }
    }
    return nil;
}

// 获取输入的姓名
- (NSString *)getName {
    return [self getTextFieldWithTag:0].text;
}

// 获取输入的职业
- (NSString *)getWork {
    return [self getTextFieldWithTag:1].text;
}

// 获取输入的手机号
- (NSString *)getPhoneNum {
    return [self getTextFieldWithTag:2].text;
}

// 获取短信验证码
- (NSString *)getVerifyCode {
    return [self getTextFieldWithTag:3].text;
}

// 获取手机区号
- (NSString *)getZipCode {
    return self.areaButton.titleLabel.text;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.logoImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sloganLabel];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.doneButton];
    [self.containerView addSubview:self.errorHintLabel];
    
    [self thn_creatTextFieldWithPlaceholderTexts:@[kPlaceholderName,
                                                   kPlaceholderWork,
                                                   kPlaceholderPhone,
                                                   kPlaceholderVerify]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(226 * (SCREEN_WIDTH / 375));
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(self.headerImageView.mas_top).with.offset(42);
        make.centerX.equalTo(self.headerImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 20));
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset(13);
        make.centerX.equalTo(self.headerImageView);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 15));
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.headerImageView);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.sloganLabel.mas_bottom).with.offset(kDeviceiPhone5 ? 20 : 30);
        make.height.mas_equalTo(360);
    }];
    [self.containerView drwaShadow];
    
    [self.errorHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-95);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(kDeviceiPhone5 ? -50 : -20);
    }];
    [self.doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    
    self.areaButton.frame = CGRectMake(0, 0, 70, 44);
    
    [self.textFieldArray mas_distributeViewsAlongAxis:(MASAxisTypeVertical)
                                  withFixedItemLength:44
                                          leadSpacing:20
                                          tailSpacing:120];
    
    [self.textFieldArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageWithContentsOfFile: \
                                  [[NSBundle mainBundle] pathForResource:@"apply_header_image@2x" ofType:@".png"]];
    }
    return _headerImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"icon_logo_default"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightMedium)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextTitle;
    }
    return _titleLabel;
}

- (UILabel *)sloganLabel {
    if (!_sloganLabel) {
        _sloganLabel = [[UILabel alloc] init];
        _sloganLabel.textColor = [UIColor whiteColor];
        _sloganLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _sloganLabel.textAlignment = NSTextAlignmentCenter;
        _sloganLabel.text = kTextSlogan;
    }
    return _sloganLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:kDoneButtonTitle forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton addTarget:self action:@selector(thn_doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
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

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

// 创建输入框
- (void)thn_creatTextFieldWithPlaceholderTexts:(NSArray *)texts {
    for (NSUInteger idx = 0; idx < texts.count; idx ++) {
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = texts[idx];
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = [UIColor colorWithHexString:@"#333333"];
        textField.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        textField.layer.borderWidth = 0.5f;
        textField.layer.cornerRadius = 4.0f;
        textField.tag = kTextFieldTag + idx;
        
        if (idx == 2) {
            textField.rightView = self.authCodeView;
            textField.leftView = self.areaButton;
            textField.keyboardType = UIKeyboardTypePhonePad;
        } else {
            textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        }

        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        [self.containerView addSubview:textField];
        [self.textFieldArray addObject:textField];
    }
}

- (UIButton *)areaButton {
    if (!_areaButton) {
        _areaButton = [[UIButton alloc] init];
        [_areaButton setTitle:kDefaultArea forState:(UIControlStateNormal)];
        [_areaButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_areaButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -15, 0, 0))];
        _areaButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _areaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_areaButton setImage:[UIImage imageNamed:@"icon_down_gray"] forState:(UIControlStateNormal)];
        [_areaButton setImageEdgeInsets:(UIEdgeInsetsMake(17, 48, 17, 12))];
        [_areaButton addTarget:self action:@selector(areaButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _areaButton;
}

- (THNAuthCodeButton *)authCodeButton {
    if (!_authCodeButton) {
        _authCodeButton = [[THNAuthCodeButton alloc] initWithType:(THNAuthCodeButtonTypeCircle)];
        [_authCodeButton addTarget:self action:@selector(authCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _authCodeButton;
}

- (UIView *)authCodeView {
    if (!_authCodeView) {
        _authCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
        [_authCodeView addSubview:self.authCodeButton];
    }
    return _authCodeView;
}

- (NSMutableArray *)textFieldArray {
    if (!_textFieldArray) {
        _textFieldArray = [NSMutableArray array];
    }
    return _textFieldArray;
}

@end
