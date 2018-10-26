//
//  THNCartDefaultView.m
//  lexi
//
//  Created by FLYang on 2018/9/19.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCartDefaultView.h"
#import <YYKit/YYKit.h>
#import "THNConst.h"

static NSString *kTextHint      = @"您的购物车还没有任何礼品";
static NSString *kTextDiscover  = @"现在去逛逛";

@interface THNCartDefaultView ()

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 提示信息
@property (nonatomic, strong) UILabel *hintLabel;
/// 发现按钮
@property (nonatomic, strong) UIButton *discoverButton;

@end

@implementation THNCartDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)discoverButtonAction:(UIButton *)button {
    if (self.cartDefaultDiscoverBlock) {
        self.cartDefaultDiscoverBlock();
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.hintLabel];
    [self addSubview:self.discoverButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake((kScreenWidth - 95) / 2, 40, 95, 95);
    self.hintLabel.frame = CGRectMake(20, CGRectGetMaxY(self.iconImageView.frame) + 20, kScreenWidth - 40, 16);
    self.discoverButton.frame = CGRectMake((kScreenWidth - 250) / 2, CGRectGetMaxY(self.hintLabel.frame) + 30, 250, 40);
    self.discoverButton.layer.cornerRadius = 4;
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cart_place"]];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightLight)];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

- (UIButton *)discoverButton {
    if (!_discoverButton) {
        _discoverButton = [[UIButton alloc] init];
        _discoverButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_discoverButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_discoverButton setTitle:kTextDiscover forState:(UIControlStateNormal)];
        _discoverButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_discoverButton addTarget:self action:@selector(discoverButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _discoverButton;
}

@end
