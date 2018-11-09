//
//  THNGoodsFunctionView.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsFunctionView.h"
#import "THNGoodsButton.h"
#import "THNGoodsButton+SelfManager.h"
#import "THNCartButton.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNLoginManager.h"

static NSString *const kTextNone = @"已售罄";

@interface THNGoodsFunctionView ()

/// 左侧主按钮：加入购物车、购买
@property (nonatomic, strong) THNGoodsButton *mainButton;
/// 左侧副按钮：购买、定制、卖
@property (nonatomic, strong) THNGoodsButton *subButton;
/// 购物车
@property (nonatomic, strong) THNCartButton *cartButton;
/// 购物车商品数量
@property (nonatomic, strong) UILabel *countLabel;
/// 售罄提示
@property (nonatomic, strong) UILabel *noneLabel;
/// 是否显示购物车
@property (nonatomic, assign) BOOL showGoodsCart;

@end

@implementation THNGoodsFunctionView

- (instancetype)initWithType:(THNGoodsFunctionViewType)type {
    self = [super self];
    if (self) {
        self.type = type;
        [self setupViewUI];
        [self thn_setFunctionButtonWithType:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(THNGoodsFunctionViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self setupViewUI];
        [self thn_setFunctionButtonWithType:type];
    }
    return self;
}

- (void)thn_setGoodsModel:(THNGoodsModel *)model {
    if (model.stockCount <= 0) {
        [self thn_hasStockCount:NO];
        return;
    }
    
    [self thn_hasStockCount:YES];
    
    if (model.isCustomMade) {
        self.type = THNGoodsFunctionViewTypeCustom;
    } else {
        self.type = THNGoodsFunctionViewTypeDefault;
    }
    
//    if ([THNLoginManager sharedManager].openingUser && model.isDistributed) {
//        self.type = THNGoodsFunctionViewTypeSell;
//    }
}

- (void)thn_showGoodsCart:(BOOL)show {
    self.cartButton.hidden = YES;
    self.showGoodsCart = show;
}

- (void)thn_setCartGoodsCount:(NSInteger)count {
    self.countLabel.hidden = count == 0;
    
    NSString *countStr = count > 9 ? @"9+" : [NSString stringWithFormat:@"%zi", count];
    self.countLabel.text = countStr;
}

#pragma mark - private methods
- (void)thn_setFunctionButtonWithType:(THNGoodsFunctionViewType)type {
    switch (type) {
        case THNGoodsFunctionViewTypeDefault: {
            self.mainButton.type = THNGoodsButtonTypeAddCart;
            self.subButton.type = THNGoodsButtonTypeBuy;
        }
            break;
        
        case THNGoodsFunctionViewTypeCustom: {
            self.mainButton.type = THNGoodsButtonTypeAddCart;
            self.subButton.type = THNGoodsButtonTypeCustom;
        }
            break;
            
        case THNGoodsFunctionViewTypeSell: {
            self.mainButton.type = THNGoodsButtonTypeBuy;
            self.subButton.type = THNGoodsButtonTypeSell;
        }
            break;
    }
}

/**
 是否有库存
 */
- (void)thn_hasStockCount:(BOOL)has {
    self.noneLabel.hidden = has;
    self.mainButton.hidden = !has;
    self.subButton.hidden = !has;
}

#pragma mark - event response
- (void)mainButtonAction:(THNGoodsButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_openGoodsSkuWithType:)]) {
        [self.delegate thn_openGoodsSkuWithType:(THNGoodsButtonType)button.type];
    }
}

- (void)subButtonAction:(THNGoodsButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_openGoodsSkuWithType:)]) {
        [self.delegate thn_openGoodsSkuWithType:(THNGoodsButtonType)button.type];
    }
}

- (void)cartButtonAction:(THNCartButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_openGoodsCart)]) {
        [self.delegate thn_openGoodsCart];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.showGoodsCart = YES;
    
    [self addSubview:self.mainButton];
    [self addSubview:self.subButton];
    [self addSubview:self.cartButton];
    [self addSubview:self.countLabel];
    [self addSubview:self.noneLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cartWidth = self.showGoodsCart ? 59 : 0;
    CGFloat buttonWidth = (CGRectGetWidth(self.bounds) - 40 - cartWidth) / 2;
    
    self.mainButton.frame = CGRectMake(20 + cartWidth, 5, buttonWidth, 40);
    [self.mainButton drawCornerWithType:(UILayoutCornerRadiusLeft) radius:4];

    self.subButton.frame = CGRectMake(CGRectGetMaxX(self.mainButton.frame), 5, buttonWidth, 40);
    [self.subButton drawCornerWithType:(UILayoutCornerRadiusRight) radius:4];
    
    self.noneLabel.frame = CGRectMake(20 + cartWidth, 5, buttonWidth * 2, 40);
    [self.noneLabel drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    
    if (self.showGoodsCart) {
        self.cartButton.frame = CGRectMake(0, 5, 79, 40);
        self.countLabel.frame = CGRectMake(45, 6, 12, 12);
        [self.countLabel drawCornerWithType:(UILayoutCornerRadiusAll) radius:6];
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.drawLine) {
        [UIView drawRectLineStart:CGPointMake(0, 0)
                              end:CGPointMake(CGRectGetWidth(self.bounds), 0)
                            width:0.5
                            color:[UIColor colorWithHexString:@"#E9E9E9"]];
    }
}

#pragma mark - getters and setters
- (void)setType:(THNGoodsFunctionViewType)type {
    [self thn_setFunctionButtonWithType:type];
}

- (THNGoodsButton *)mainButton {
    if (!_mainButton) {
        _mainButton = [[THNGoodsButton alloc] init];
        [_mainButton addTarget:self action:@selector(mainButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _mainButton;
}

- (THNGoodsButton *)subButton {
    if (!_subButton) {
        _subButton = [[THNGoodsButton alloc] init];
        [_subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _subButton;
}

- (THNCartButton *)cartButton {
    if (!_cartButton) {
        _cartButton = [[THNCartButton alloc] init];
        [_cartButton addTarget:self action:@selector(cartButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cartButton;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        _countLabel.font = [UIFont systemFontOfSize:8];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.hidden = YES;
    }
    return _countLabel;
}

- (UILabel *)noneLabel {
    if (!_noneLabel) {
        _noneLabel = [[UILabel alloc] init];
        _noneLabel.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:0.5];
        _noneLabel.font = [UIFont systemFontOfSize:16];
        _noneLabel.textColor = [UIColor whiteColor];
        _noneLabel.textAlignment = NSTextAlignmentCenter;
        _noneLabel.text = kTextNone;
        _noneLabel.hidden = YES;
    }
    return _noneLabel;
}

@end
