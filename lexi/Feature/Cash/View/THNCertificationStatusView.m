//
//  THNCertificationStatusView.m
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCertificationStatusView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNConst.h"

static NSString *const kTextHint = @"身份信息提交成功";
static NSString *const kTextDone = @"去提现";

@interface THNCertificationStatusView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation THNCertificationStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_certificationStatusViewDoneAction)]) {
        [self.delegate thn_certificationStatusViewDoneAction];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.hintLabel];
    [self addSubview:self.doneButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(60);
        make.centerX.equalTo(self);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(13);
        make.centerX.equalTo(self);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(25);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_commit_success"]];
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton setTitle:kTextDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
