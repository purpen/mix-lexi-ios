//
//  THNLifeCashView.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "THNConst.h"

static NSString *const kTextTitle       = @"可提现金额";
static NSString *const kTextTitleSub    = @"（元）";
static NSString *const kTextTotal       = @"累计已提现：";
static NSString *const kTextHint        = @"可提现金额超过10元才可提现，每日最多可提现3次";
static NSString *const kTextCash        = @"提现";

@interface THNLifeCashView ()

// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
// 可提金额
@property (nonatomic, strong) UILabel *moneyLabel;
// 总结金额
@property (nonatomic, strong) UILabel *totalLabel;
// 提现按钮
@property (nonatomic, strong) UIButton *cashButton;
// 提示
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNLifeCashView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeCashCollect:(THNLifeCashCollectModel *)model {
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", model.cash_price];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%.2f", kTextTotal, model.total_cash_price];
    [self thn_setCashButtonStatusWithPrice:model.cash_price];
}

#pragma mark - event response
- (void)cashButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_checkLifeCash)]) {
        [self.delegate thn_checkLifeCash];
    }
}

#pragma mark - private methods
- (void)thn_setCashButtonStatusWithPrice:(CGFloat)price {
    NSString *colorHex = price > 10 ? kColorMain : @"#CCCCCC";
    self.cashButton.backgroundColor = [UIColor colorWithHexString:colorHex];
    self.cashButton.userInteractionEnabled = price > 10;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.totalLabel];
    [self addSubview:self.cashButton];
    [self addSubview:self.hintLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(15);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(25);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(13);
    }];
    
    [self.cashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-47);
        make.size.mas_equalTo(CGSizeMake(285, 40));
        make.centerX.equalTo(self);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.cashButton.mas_bottom).with.offset(15);
        make.height.mas_equalTo(13);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextTitle];
        titleAtt.color = [UIColor colorWithHexString:@"#333333"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextTitleSub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#333333"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _titleLabel.attributedText = titleAtt;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:12];
        _totalLabel.textColor = [UIColor colorWithHexString:@"#FB9013"];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

- (UIButton *)cashButton {
    if (!_cashButton) {
        _cashButton = [[UIButton alloc] init];
        [_cashButton setTitle:kTextCash forState:(UIControlStateNormal)];
        [_cashButton setTitleColor:[UIColor colorWithHexString:@"#F7F9FB"] forState:(UIControlStateNormal)];
        _cashButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cashButton.layer.cornerRadius = 4;
        _cashButton.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        [_cashButton addTarget:self action:@selector(cashButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _cashButton.userInteractionEnabled = NO;
    }
    return _cashButton;
}

@end
