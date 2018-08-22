//
//  THNApplySuccessView.m
//  lexi
//
//  Created by FLYang on 2018/8/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNApplySuccessView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
#import "UIView+Helper.h"
#import "THNMarco.h"
#import "THNConst.h"

static NSString *const kTextSuccess         = @"恭喜开通乐喜生活馆";
static NSString *const kTextUser            = @"你当前的身份为";
static NSString *const kTextStatus          = @"实习馆主";
static NSString *const kTextHint            = @"30 天内需成功销售 3 单，即可成为正式馆主，如未达指标，则自动撤销馆主身份，关闭生活馆。";
static NSString *const kTextWechat          = @"获得快速销售秘诀，关注微信公众号：乐喜生活馆";
static NSString *const kDoneButtonTitle     = @"进入生活馆";

@interface THNApplySuccessView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) YYLabel *hintLabel;
@property (nonatomic, strong) YYLabel *wechatLabel;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation THNApplySuccessView

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
- (void)thn_doneButtonAction:(UIButton *)button {
    self.ApplySuccessBlock();
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.successLabel];
    [self addSubview:self.userLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.hintLabel];
    [self addSubview:self.wechatLabel];
    [self addSubview:self.doneButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(277, 45));
        make.top.mas_equalTo(kDeviceiPhoneX ? 140 : 120);
        make.centerX.equalTo(self);
    }];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 45));
        make.centerX.centerY.equalTo(self.headerImageView);
    }];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 15));
        make.top.equalTo(self.successLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.headerImageView);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 28));
        make.top.equalTo(self.userLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.headerImageView);
    }];
    [self.statusLabel drawCornerWithType:(UILayoutCornerRadiusAll) radius:14];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(30);
        make.height.mas_equalTo(50);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(15);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.wechatLabel.mas_bottom).with.offset(90);
        make.height.mas_equalTo(40);
    }];
    [self.doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"apply_success"];
    }
    return _headerImageView;
}

- (UILabel *)successLabel {
    if (!_successLabel) {
        _successLabel = [[UILabel alloc] init];
        _successLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightMedium)];
        _successLabel.textColor = [UIColor colorWithHexString:@"#d2aa7a"];
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.text = kTextSuccess;
    }
    return _successLabel;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] init];
        _userLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _userLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _userLabel.textAlignment = NSTextAlignmentCenter;
        _userLabel.text = kTextUser;
    }
    return _userLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.backgroundColor = [UIColor colorWithHexString:@"#2785fa"];
        _statusLabel.text = kTextStatus;
    }
    return _statusLabel;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:kTextHint];
        attText.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        attText.color = [UIColor colorWithHexString:@"#666666"];
        attText.alignment = NSTextAlignmentLeft;
        attText.lineSpacing = 10;
        
        _hintLabel.numberOfLines = 2;
        _hintLabel.attributedText = attText;
    }
    return _hintLabel;
}

- (YYLabel *)wechatLabel {
    if (!_wechatLabel) {
        _wechatLabel = [[YYLabel alloc] init];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:kTextWechat];
        attText.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        attText.color = [UIColor colorWithHexString:@"#333333"];
        attText.alignment = NSTextAlignmentLeft;
        
        [attText setTextHighlightRange:NSMakeRange(kTextWechat.length - 5, 5)
                                    color:[UIColor colorWithHexString:kColorMain]
                          backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                                tapAction:nil];
        
        _wechatLabel.attributedText = attText;
    }
    return _wechatLabel;
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


@end
