//
//  THNCashActionButton.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashActionButton.h"
#import "UIColor+Extension.h"
#import "NSString+Helper.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>

@interface THNCashActionButton ()

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIImageView *selectedIcon;
@property (nonatomic, strong) UIImageView *hintIcon;

@end

@implementation THNCashActionButton

- (instancetype)initWithType:(THNCashActionButtonType)type {
    self = [super init];
    if (self) {
        [self setupViewUI];
        [self setupShowStyleWithType:type];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_showHintIcon {
    self.hintIcon.hidden = NO;
}

- (void)thn_showCashMoneyValue:(CGFloat)value {
    NSString *moneyStr = [NSString stringWithFormat:@"%.0f元", value];
    
    [self.actionButton setTitle:moneyStr forState:(UIControlStateNormal)];
}

- (void)thn_showCashMode:(THNCashMode)mode {
    NSDictionary *modeDict = @{@(THNCashModeWechat): @"icon_cash_wx",
                               @(THNCashModeAlipay): @"icon_cash_ali"};
    
    NSDictionary *titleDict = @{@(THNCashModeWechat): @"微信",
                                @(THNCashModeAlipay): @"支付宝"};
    
    [self.actionButton setImage:[UIImage imageNamed:modeDict[@(mode)]] forState:(UIControlStateNormal)];
    [self.actionButton setTitle:titleDict[@(mode)] forState:(UIControlStateNormal)];
}

#pragma mark - private methods
- (void)thn_changeStatusOfSelected:(BOOL)selected {
    NSString *selectedColor = selected ? kColorMain : @"#CCCCCC";
    
    self.actionButton.layer.borderColor = [UIColor colorWithHexString:selectedColor].CGColor;
    self.selectedIcon.hidden = !selected;
}

- (void)setSelected:(BOOL)selected {
    [self thn_changeStatusOfSelected:selected];
}

#pragma mark - event response
- (void)actionButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedCashActionButton:)]) {
        [self.delegate thn_didSelectedCashActionButton:self];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.actionButton];
    [self addSubview:self.selectedIcon];
    [self addSubview:self.hintIcon];
    
    [self setMasonryLayout];
}

- (void)setupShowStyleWithType:(THNCashActionButtonType)type {
    if (type == THNCashActionButtonTypeMoney) {
        self.actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    } else if (type == THNCashActionButtonTypeMode) {
        self.actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.actionButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        [self.actionButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 25, 0, 0))];
    }
}

- (void)setMasonryLayout {
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.left.mas_equalTo(0);
    }];
    
    [self.hintIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(46, 14));
        make.top.mas_equalTo(-7);
        make.right.mas_equalTo(0);
    }];
}

#pragma mark - getters and setters
- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.layer.cornerRadius = 4;
        _actionButton.layer.borderWidth = 1;
        _actionButton.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_actionButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _actionButton;
}

- (UIImageView *)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cash_selected"]];
        _selectedIcon.hidden = YES;
    }
    return _selectedIcon;
}

- (UIImageView *)hintIcon {
    if (!_hintIcon) {
        _hintIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cash_hint"]];
        _hintIcon.hidden = YES;
    }
    return _hintIcon;
}

@end
