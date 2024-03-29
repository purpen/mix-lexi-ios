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
#import "THNCashHintView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNConst.h"

static NSString *const kTextCash = @"我要提现";

@interface THNCashView () <THNCashMoneyViewDelegate>

@property (nonatomic, strong) THNCashAmountView *amountView;
@property (nonatomic, strong) THNCashMoneyView *moneyView;
@property (nonatomic, strong) THNCashModeView *modeView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) THNCashHintView *hintView;

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
    _cashAmount = cashAmount;
    
    [self.amountView thn_setCashAmountValue:cashAmount];
}

#pragma mark - custom delegate
- (void)thn_didSelectedCashMoneyIndex:(NSInteger)index {
    [self.hintView thn_changeCashMoneyTime:index > 0];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedDoneCashWithAmount:mode:)]) {
        [self.delegate thn_didSelectedDoneCashWithAmount:[self thn_getCashAmount]
                                                    mode:[self thn_getCashMode]];
    }
}

#pragma mark - private methods
- (CGFloat)thn_getCashAmount {
    return self.moneyView.cashAmount;
}

- (NSInteger)thn_getCashMode {
    return self.modeView.cashMode;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.amountView];
    [self addSubview:self.moneyView];
    [self addSubview:self.modeView];
    [self addSubview:self.doneButton];
    [self addSubview:self.hintView];
    
    [self setMasonryLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

- (void)setMasonryLayout {
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(90);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(170);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.amountView.mas_bottom).with.offset(10);
    }];
    
    [self.modeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(190);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.moneyView.mas_bottom).with.offset(0);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.modeView.mas_bottom).with.offset(-20);
    }];
    
    [self.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(180);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.modeView.mas_bottom).with.offset(10);
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
        _moneyView.delegate = self;
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
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (THNCashHintView *)hintView {
    if (!_hintView) {
        _hintView = [[THNCashHintView alloc] initWithType:(THNCashHintViewTypeNotes)];
    }
    return _hintView;
}

@end
