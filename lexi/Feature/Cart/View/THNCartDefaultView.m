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
#import <Masonry/Masonry.h>

/// text
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
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 95));
        make.top.mas_equalTo(40);
        make.centerX.equalTo(self);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(20);
    }];
    
    [self.discoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 40));
        make.centerX.equalTo(self);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(30);
    }];
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
        _discoverButton.layer.cornerRadius = 4;
        [_discoverButton addTarget:self action:@selector(discoverButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _discoverButton;
}

@end
