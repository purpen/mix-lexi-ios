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
#import "UIColor+Extension.h"
#import "NSString+Helper.h"

static NSString *const kTextTotal       = @"合计：";
static NSString *const kTextClearing    = @"结算";
static NSString *const kTextRemove      = @"移除";
static NSString *const kTextWishList    = @"放入心愿单";

@interface THNCartFunctionView ()

/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 结算
@property (nonatomic, strong) UIButton *clearButton;
/// 删除
@property (nonatomic, strong) UIButton *removeButton;
/// 添加到心愿单
@property (nonatomic, strong) UIButton *wishListButton;

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

- (void)setStatus:(THNCartFunctionStatus)status {
    BOOL isEditStatus = status == THNCartFunctionStatusEdit;
    
    [self thn_startEditStatus:isEditStatus];
}

#pragma mark - event response
- (void)clearButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didSettleShoppingCartItems)]) {
        [self.delegate thn_didSettleShoppingCartItems];
    }
}

- (void)removeButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didRemoveShoppingCartItems)]) {
        [self.delegate thn_didRemoveShoppingCartItems];
    }
}

- (void)wishListButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didShoppingCartItemsToWishlist)]) {
        [self.delegate thn_didShoppingCartItemsToWishlist];
    }
}

#pragma mark - private methods
- (void)thn_setTotalPriceWithValue:(CGFloat)value {
    if (!value) return;
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString formatFloat:value]];
    priceAtt.color = [UIColor colorWithHexString:@"#333333"];
    priceAtt.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextTotal];
    att.color = [UIColor colorWithHexString:@"#555555"];
    att.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    
    [priceAtt insertAttributedString:att atIndex:0];
    
    self.priceLabel.attributedText = priceAtt;
}

/**
 进入编辑状态
 */
- (void)thn_startEditStatus:(BOOL)start {
    self.priceLabel.hidden = start;
    self.clearButton.hidden = start;
    self.removeButton.hidden = !start;
    self.wishListButton.hidden = !start;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.priceLabel];
    [self addSubview:self.clearButton];
    [self addSubview:self.removeButton];
    [self addSubview:self.wishListButton];
    
    [self setMasnoryLayout];
}

- (void)setMasnoryLayout {
    CGSize clearButtonSize = CGSizeMake((kScreenWidth - 40) / 2, 40);
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(clearButtonSize.width + 25));
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(clearButtonSize);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-15);
    }];
    
    CGSize buttonSize = CGSizeMake((kScreenWidth - 45) / 2, 40);
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.wishListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
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

- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [[UIButton alloc] init];
        _removeButton.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:0.1];
        [_removeButton setTitle:kTextRemove forState:(UIControlStateNormal)];
        [_removeButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateNormal)];
        _removeButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        _removeButton.layer.cornerRadius = 4;
        _removeButton.layer.borderColor = [UIColor colorWithHexString:kColorMain].CGColor;
        _removeButton.layer.borderWidth = 1;
        [_removeButton addTarget:self action:@selector(removeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _removeButton;
}

- (UIButton *)wishListButton {
    if (!_wishListButton) {
        _wishListButton = [[UIButton alloc] init];
        _wishListButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_wishListButton setTitle:kTextWishList forState:(UIControlStateNormal)];
        [_wishListButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _wishListButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        _wishListButton.layer.cornerRadius = 4;
        [_wishListButton addTarget:self action:@selector(wishListButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _wishListButton;
}

@end
