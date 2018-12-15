//
//  THNCashAwardView.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashAwardView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "UIView+Helper.h"

static NSString *const kTextCash    = @"可提现金额（元）";
static NSString *const kTextHint    = @"可提现金额超过10元才可提现";
static NSString *const kTextDone    = @"立即提现";
static NSString *const kTextTitle   = @"累计获得奖励（元）";
static NSString *const kTextWait    = @"待结算：";
static NSString *const kTextAlready = @"已提现：";
///
static CGFloat const minCashMoney   = 3;

@interface THNCashAwardView ()

// 金额
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundColorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *alreadyLabel;
@property (nonatomic, strong) UILabel *waitLabel;
@property (nonatomic, strong) UIButton *waitHintButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *cutLineView;
// 提现
@property (nonatomic, strong) UILabel *cashTitleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *doneButton;
///
@property (nonatomic, strong) THNInviteAmountModel *amountModel;

@end

@implementation THNCashAwardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeInviteAmountModel:(THNInviteAmountModel *)model {
    self.amountModel = model;
    
    [self thn_cashMoneyButtonWithAmount:model.cashAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f", model.rewardPrice];
    self.alreadyLabel.text = [NSString stringWithFormat:@"%@%.2f", kTextAlready, model.cumulativeCashAmount];
    self.waitLabel.text = [NSString stringWithFormat:@"%@%.2f", kTextWait, model.pendingPrice];
}

#pragma mark - private methods
- (void)thn_cashMoneyButtonWithAmount:(CGFloat)amount {
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", amount];
    
    BOOL canCash = amount > minCashMoney;
    
    self.doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:canCash ? 1 : 0.5];
    self.doneButton.userInteractionEnabled = canCash;
}

#pragma mark - event response
- (void)showButtonAction:(UIButton *)button {
    if (button.selected) {
        [self thn_setLifeInviteAmountModel:self.amountModel];
        
    } else {
        self.totalLabel.text = @"＊＊＊＊";
        self.alreadyLabel.text = [NSString stringWithFormat:@"%@＊＊＊", kTextAlready];
        self.waitLabel.text = [NSString stringWithFormat:@"%@＊＊＊", kTextWait];
    }
    
    self.showButton.selected = !button.selected;
}

- (void)waitHintButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_showCashHintText)]) {
        [self.delegate thn_showCashHintText];
    }
}

- (void)doneButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_cashAwardMoney)]) {
        [self.delegate thn_cashAwardMoney];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self.containerView addSubview:self.backgroundColorView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.showButton];
    [self.containerView addSubview:self.totalLabel];
    [self.containerView addSubview:self.cutLineView];
    [self.containerView addSubview:self.alreadyLabel];
    [self.containerView addSubview:self.waitLabel];
    [self.containerView addSubview:self.waitHintButton];
    [self.containerView addSubview:self.lineView];
    [self addSubview:self.containerView];
    
    [self addSubview:self.cashTitleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.hintLabel];
    [self addSubview:self.doneButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(335, 138));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.centerX.equalTo(self.containerView);
    }];
    
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(26);
    }];
    
    [self.cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
        make.height.mas_equalTo(1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 12));
        make.bottom.mas_equalTo(-17);
        make.centerX.equalTo(self);
    }];
    
    [self.alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.lineView.mas_left).with.offset(-20);
        make.bottom.mas_equalTo(-17);
    }];
    
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.left.equalTo(self.lineView.mas_right).with.offset(20);
        make.bottom.mas_equalTo(-17);
    }];
    
    [self.waitHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-16);
    }];
    
#pragma mark 提现视图
    [self.cashTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 14));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.containerView.mas_bottom).with.offset(20);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.cashTitleLabel.mas_bottom).with.offset(5);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 13));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(5);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 33));
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.containerView.mas_bottom).with.offset(25);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:33/2];
}

#pragma mark - getters and setters
#pragma mark 金额
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextTitle;
    }
    return _titleLabel;
}

- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icon_eye_open_white"] forState:(UIControlStateNormal)];
        [_showButton setImage:[UIImage imageNamed:@"icon_eye_close_white"] forState:(UIControlStateSelected)];
        _showButton.selected = NO;
        [_showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _showButton;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightBold)];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UILabel *)alreadyLabel {
    if (!_alreadyLabel) {
        _alreadyLabel = [[UILabel alloc] init];
        _alreadyLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _alreadyLabel.textColor = [UIColor whiteColor];
        _alreadyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alreadyLabel;
}

- (UILabel *)waitLabel {
    if (!_waitLabel) {
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _waitLabel.textColor = [UIColor whiteColor];
        _waitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _waitLabel;
}

- (UIButton *)waitHintButton {
    if (!_waitHintButton) {
        _waitHintButton = [[UIButton alloc] init];
        [_waitHintButton setImage:[UIImage imageNamed:@"icon_hint_white"] forState:(UIControlStateNormal)];
        [_waitHintButton addTarget:self action:@selector(waitHintButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _waitHintButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [[UIView alloc] init];
        _cutLineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
    }
    return _cutLineView;
}

- (UIView *)backgroundColorView {
    if (!_backgroundColorView) {
        _backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 335, 138)];
        
        UIView *colorView = [[UIView alloc] initWithFrame:_backgroundColorView.bounds];
        [colorView.layer addSublayer:[UIColor colorGradientWithView:self colors:@[@"#8069f9", @"#d288ff"]]];
        colorView.layer.cornerRadius = 4;
        colorView.layer.masksToBounds = YES;
        
        _backgroundColorView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
        _backgroundColorView.layer.shadowOffset = CGSizeMake(0, 0);
        _backgroundColorView.layer.shadowRadius = 4;
        _backgroundColorView.layer.shadowOpacity = 0.3;
        
        [_backgroundColorView addSubview:colorView];
    }
    return _backgroundColorView;
}

#pragma mark 提现
- (UILabel *)cashTitleLabel {
    if (!_cashTitleLabel) {
        _cashTitleLabel = [[UILabel alloc] init];
        _cashTitleLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
        _cashTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _cashTitleLabel.text = kTextCash;
    }
    return _cashTitleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    return _moneyLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:kTextDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:1];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
