//
//  THNLifeDataView.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeDataView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

static NSString *const kTextOrder       = @"总计成交订单";
static NSString *const kTextOrderSub    = @"（笔）";
static NSString *const kTextMoney       = @"可提现金额";
static NSString *const kTextMoneySub    = @"（元）";
static NSString *const kTextToday       = @"今日：";
static NSString *const kTextTotal       = @"累计已提现：";

@interface THNLifeDataView ()

// 数据
@property (nonatomic, strong) THNLifeOrdersCollectModel *orderModel;
@property (nonatomic, strong) THNLifeCashCollectModel *cashModel;
// 订单
@property (nonatomic, strong) YYLabel *orderTitleLabel;
// 订单数量
@property (nonatomic, strong) UIButton *orderCountButton;
// 今日订单数量
@property (nonatomic, strong) UILabel *todayOrderLabel;
// 提现
@property (nonatomic, strong) YYLabel *moneyTitleLabel;
// 可提现金额
@property (nonatomic, strong) UIButton *getMoneyButton;
// 累计提现
@property (nonatomic, strong) YYLabel *totalMoneyLabel;
// 隐藏按钮
@property (nonatomic, strong) UIButton *showButton;

@end

@implementation THNLifeDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeOrdersCollecitonModel:(THNLifeOrdersCollectModel *)model {
    self.orderModel = model;
    
    [self.orderCountButton setTitle:[NSString stringWithFormat:@"%zi", model.all_count] forState:(UIControlStateNormal)];
    self.todayOrderLabel.text = [NSString stringWithFormat:@"%@%zi", kTextToday, model.today_count];
}

- (void)thn_setLifeCashCollectModel:(THNLifeCashCollectModel *)model {
    self.cashModel = model;
    
    [self.getMoneyButton setTitle:[NSString stringWithFormat:@"%.2f", model.cash_price] forState:(UIControlStateNormal)];
    [self thn_setTotalMoneyLabelTextWithCashPrice:model.total_cash_price];
}

#pragma mark - event response
- (void)orderCountButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_checkLifeOrderRecord)]) {
        [self.delegate thn_checkLifeOrderRecord];
    }
}

- (void)getMoneyButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_checkLifeCashMoney)]) {
        [self.delegate thn_checkLifeCashMoney];
    }
}

- (void)showButtonAction:(UIButton *)button {
    if (button.selected) {
        [self thn_setLifeOrdersCollecitonModel:self.orderModel];
        [self thn_setLifeCashCollectModel:self.cashModel];
        
    } else {
        [self.orderCountButton setTitle:@"＊＊＊＊" forState:(UIControlStateNormal)];
        [self.getMoneyButton setTitle:@"＊＊＊＊" forState:(UIControlStateNormal)];
        self.todayOrderLabel.text = [NSString stringWithFormat:@"%@＊＊＊", kTextToday];
        [self thn_setTotalMoneyLabelTextWithCashPrice:-1.0];
    }
    
    self.showButton.selected = !button.selected;
}

#pragma mark - private methods
- (void)thn_setTotalMoneyLabelTextWithCashPrice:(CGFloat)price {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextTotal];
    att.color = [UIColor colorWithHexString:@"#333333"];
    att.font = [UIFont systemFontOfSize:12];
    att.alignment = NSTextAlignmentLeft;
    
    NSString *priceStr = price < 0 ? @"＊＊＊" : [NSString stringWithFormat:@"%.2f", price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    priceAtt.color = [UIColor colorWithHexString:@"#FF9F22"];
    priceAtt.font = [UIFont systemFontOfSize:12];
    
    [att appendAttributedString:priceAtt];

    self.totalMoneyLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.orderTitleLabel];
    [self addSubview:self.orderCountButton];
    [self addSubview:self.todayOrderLabel];
    [self addSubview:self.moneyTitleLabel];
    [self addSubview:self.getMoneyButton];
    [self addSubview:self.totalMoneyLabel];
    [self addSubview:self.showButton];
}

- (void)updateConstraints {
    [self.orderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.right.equalTo(self.mas_centerX).with.offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.todayOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-15);
        make.right.equalTo(self.mas_centerX).with.offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.orderCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.orderTitleLabel.mas_bottom).with.offset(15);
        make.right.equalTo(self.mas_centerX).with.offset(-10);
        make.bottom.equalTo(self.todayOrderLabel.mas_top).with.offset(-15);
    }];
    
    [self.moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-45);
        make.top.mas_equalTo(15);
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.getMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.moneyTitleLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.bottom.equalTo(self.totalMoneyLabel.mas_top).with.offset(-15);
    }];
    
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
    }];
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(20, 0)
                          end:CGPointMake(CGRectGetWidth(self.frame) - 40, 0)
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
    
    [UIView drawRectLineStart:CGPointMake(CGRectGetWidth(self.frame) / 2, 15)
                          end:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 15)
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
    
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.frame))
                          end:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (YYLabel *)orderTitleLabel {
    if (!_orderTitleLabel) {
        _orderTitleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextOrder];
        titleAtt.color = [UIColor colorWithHexString:@"#333333"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextOrderSub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#999999"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _orderTitleLabel.attributedText = titleAtt;
    }
    return _orderTitleLabel;
}

- (UIButton *)orderCountButton {
    if (!_orderCountButton) {
        _orderCountButton = [[UIButton alloc] init];
        [_orderCountButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _orderCountButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightSemibold)];
        _orderCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_orderCountButton setImage:[UIImage imageNamed:@"icon_arrow_right_gray"] forState:(UIControlStateNormal)];
        [_orderCountButton setImageEdgeInsets:(UIEdgeInsetsMake(0, (kScreenWidth - 50) / 2 - 10, 0, 0))];
        [_orderCountButton addTarget:self action:@selector(orderCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _orderCountButton;
}

- (UILabel *)todayOrderLabel {
    if (!_todayOrderLabel) {
        _todayOrderLabel = [[UILabel alloc] init];
        _todayOrderLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _todayOrderLabel.font = [UIFont systemFontOfSize:12];
    }
    return _todayOrderLabel;
}

- (YYLabel *)moneyTitleLabel {
    if (!_moneyTitleLabel) {
        _moneyTitleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextMoney];
        titleAtt.color = [UIColor colorWithHexString:@"#333333"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextMoneySub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#999999"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _moneyTitleLabel.attributedText = titleAtt;
    }
    return _moneyTitleLabel;
}

- (UIButton *)getMoneyButton {
    if (!_getMoneyButton) {
        _getMoneyButton = [[UIButton alloc] init];
        [_getMoneyButton setTitleColor:[UIColor colorWithHexString:@"#FF6666"] forState:(UIControlStateNormal)];
        _getMoneyButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightSemibold)];
        _getMoneyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_getMoneyButton setImage:[UIImage imageNamed:@"icon_arrow_right_gray"] forState:(UIControlStateNormal)];
        [_getMoneyButton setImageEdgeInsets:(UIEdgeInsetsMake(0, (kScreenWidth - 50) / 2 - 10, 0, 0))];
        [_getMoneyButton addTarget:self action:@selector(getMoneyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _getMoneyButton;
}

- (YYLabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[YYLabel alloc] init];
        _totalMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _totalMoneyLabel;
}

- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icon_eye_open_gray"] forState:(UIControlStateNormal)];
        [_showButton setImage:[UIImage imageNamed:@"icon_eye_close_gray"] forState:(UIControlStateSelected)];
        _showButton.selected = NO;
        [_showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _showButton;
}

@end
