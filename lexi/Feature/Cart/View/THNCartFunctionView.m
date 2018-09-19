//
//  THNCartFunctionView.m
//  lexi
//
//  Created by FLYang on 2018/9/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCartFunctionView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "THNConst.h"
#import "UIView+Helper.h"

static NSString *const kTextTotal       = @"合计：";
static NSString *const kTextClearing    = @"结算";

@interface THNCartFunctionView ()

/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 结算
@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation THNCartFunctionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)setTotalPrice:(CGFloat)totalPrice {
    _totalPrice = totalPrice;
    
    [self thn_setTotalPriceWithValue:totalPrice];
}

#pragma mark - event response
- (void)clearButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didSettleShoppingCartItems)]) {
        [self.delegate thn_didSettleShoppingCartItems];
    }
}

#pragma mark - private methods
- (void)thn_setTotalPriceWithValue:(CGFloat)value {
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", value]];
    priceAtt.color = [UIColor colorWithHexString:@"#333333"];
    priceAtt.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextTotal];
    att.color = [UIColor colorWithHexString:@"#555555"];
    att.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    
    [priceAtt insertAttributedString:att atIndex:0];
    
    self.priceLabel.attributedText = priceAtt;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.priceLabel];
    [self addSubview:self.clearButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-220);
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 40));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-15);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, 0)
                          end:CGPointMake(CGRectGetWidth(self.bounds), 0)
                        width:1.0
                        color:[UIColor colorWithHexString:@"#DADADA"]];
}

#pragma mark - getters and setters
- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
    }
    return _priceLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        _clearButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _clearButton.layer.cornerRadius = 4;
        [_clearButton setTitle:kTextClearing forState:(UIControlStateNormal)];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        [_clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _clearButton;
}

@end
