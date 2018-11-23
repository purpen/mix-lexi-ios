//
//  THNLoginView.m
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginView.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

static NSString *const kSkipButtonTitle     = @"跳过";
static NSString *const kHeaderLabelText     = @"欢迎来到乐喜";
static NSString *const kSubheadLabelText    = @"全球原创设计品位购物平台";
static NSString *const kSignInButtonTitle   = @"登录";
static NSString *const kSignUpButtonTitle   = @"注册";
static NSString *const kWechatButtonTitle   = @"微信登录";

@interface THNLoginView ()

/// 背景视图
@property (nonatomic, strong) UIImageView *backgroundImageView;
/// 跳过按钮
@property (nonatomic, strong) UIButton *skipButton;
/// logo
@property (nonatomic, strong) UIImageView *logoImageView;
/// 标题(欢迎语)
@property (nonatomic, strong) UILabel *headerLabel;
/// 副标题(slogan)
@property (nonatomic, strong) UILabel *subheadLabel;
/// 登录
@property (nonatomic, strong) UIButton *signInButton;
/// 微信登录
@property (nonatomic, strong) UIButton *wechatButton;
/// 注册
@property (nonatomic, strong) UIButton *signUpButton;

@end

@implementation THNLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)skipButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_loginViewDidSelectSkipButton:)]) {
        [self.delegate thn_loginViewDidSelectSkipButton:button];
    }
}

- (void)signUpButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_loginViewDidSelectSignUpButton:)]) {
        [self.delegate thn_loginViewDidSelectSignUpButton:button];
    }
}

- (void)wechatButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_loginViewDidSelectWechatButton:)]) {
        [self.delegate thn_loginViewDidSelectWechatButton:button];
    }
}

- (void)signInButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_loginViewDidSelectSignInButton:)]) {
        [self.delegate thn_loginViewDidSelectSignInButton:button];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.skipButton];
    [self addSubview:self.logoImageView];
    [self addSubview:self.headerLabel];
    [self addSubview:self.subheadLabel];
    [self addSubview:self.signInButton];
    [self addSubview:self.wechatButton];
    [self addSubview:self.signUpButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(kDeviceiPhoneX ? 54 : 36);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.equalTo(self.skipButton.mas_bottom).with.offset(35);
        make.centerX.equalTo(self);
    }];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 30));
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset(30);
        make.centerX.equalTo(self);
    }];
    
    [self.subheadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 18));
        make.top.equalTo(self.headerLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 45));
        make.bottom.mas_equalTo(-50);
        make.centerX.equalTo(self);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 45));
        make.bottom.equalTo(self.signInButton.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 45));
//        make.bottom.equalTo(self.wechatButton.mas_top).with.offset(-20);
        make.bottom.equalTo(self.signInButton.mas_top).with.offset(-20);
        make.centerX.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.wechatButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    [self.signUpButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

#pragma mark - getters and setters
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        NSString *imageNameStr = kDeviceiPhoneX ? @"login_background_image_x.png" : @"login_background_image.png";
        _backgroundImageView.image = [UIImage imageWithContentsOfFile:\
                                      [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageNameStr]];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] init];
        [_skipButton setTitle:kSkipButtonTitle forState:(UIControlStateNormal)];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_skipButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -20, 0, 0))];
        _skipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        [_skipButton setImage:[UIImage imageNamed:@"icon_arrow_white"] forState:(UIControlStateNormal)];
        [_skipButton setImageEdgeInsets:(UIEdgeInsetsMake(17, 38, 17, 0))];
        [_skipButton addTarget:self action:@selector(skipButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _skipButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"icon_logo_default"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.text = kHeaderLabelText;
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightBold)];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}

- (UILabel *)subheadLabel {
    if (!_subheadLabel) {
        _subheadLabel = [[UILabel alloc] init];
        _subheadLabel.text = kSubheadLabelText;
        _subheadLabel.textColor = [UIColor whiteColor];
        _subheadLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightLight)];
        _subheadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subheadLabel;
}

- (UIButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [[UIButton alloc] init];
        [_signInButton setTitle:kSignInButtonTitle forState:(UIControlStateNormal)];
        [_signInButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _signInButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)];
        [_signInButton addTarget:self action:@selector(signInButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _signInButton;
}

- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [[UIButton alloc] init];
        [_wechatButton setTitle:kWechatButtonTitle forState:(UIControlStateNormal)];
        [_wechatButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _wechatButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        [_wechatButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _wechatButton.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
        [_wechatButton setImage:[UIImage imageNamed:@"icon_wechat_white"] forState:(UIControlStateNormal)];
        [_wechatButton setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _wechatButton.layer.borderWidth = 1.0;
        _wechatButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_wechatButton addTarget:self action:@selector(wechatButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _wechatButton.hidden = YES;
    }
    return _wechatButton;
}

- (UIButton *)signUpButton {
    if (!_signUpButton) {
        _signUpButton = [[UIButton alloc] init];
        [_signUpButton setTitle:kSignUpButtonTitle forState:(UIControlStateNormal)];
        [_signUpButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _signUpButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        _signUpButton.backgroundColor = [UIColor whiteColor];
        [_signUpButton addTarget:self action:@selector(signUpButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _signUpButton;
}

@end
