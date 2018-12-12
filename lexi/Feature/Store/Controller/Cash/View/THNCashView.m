//
//  THNCashView.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashView.h"
#import "THNCashAmountView.h"
#import "THNCashMoneyView.h"
#import "THNCashModeView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNConst.h"

static NSString *const kTextCash = @"我要提现";

@interface THNCashView ()

@property (nonatomic, strong) THNCashAmountView *amountView;
@property (nonatomic, strong) THNCashMoneyView *moneyView;
@property (nonatomic, strong) THNCashModeView *modeView;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation THNCashView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)setCashAmount:(CGFloat)cashAmount {
    [self.amountView thn_setCashAmountValue:cashAmount];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.amountView];
    [self addSubview:self.moneyView];
    [self addSubview:self.modeView];
    [self addSubview:self.doneButton];
    
    [self setMasonryLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

- (void)setMasonryLayout {
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(96);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(180);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.amountView.mas_bottom).with.offset(10);
    }];
    
    [self.modeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.equalTo(self.moneyView.mas_bottom).with.offset(0);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.bottom.right.mas_equalTo(-20);
    }];
}

#pragma mark - getters and setters
- (THNCashAmountView *)amountView {
    if (!_amountView) {
        _amountView = [[THNCashAmountView alloc] init];
    }
    return _amountView;
}

- (THNCashMoneyView *)moneyView {
    if (!_moneyView) {
        _moneyView = [[THNCashMoneyView alloc] init];
    }
    return _moneyView;
}

- (THNCashModeView *)modeView {
    if (!_modeView) {
        _modeView = [[THNCashModeView alloc] init];
    }
    return _modeView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:kTextCash forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
    }
    return _doneButton;
}

@end
