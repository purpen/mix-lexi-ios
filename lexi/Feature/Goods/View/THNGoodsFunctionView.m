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

@interface THNGoodsFunctionView ()

/// 左侧主按钮：加入购物车、购买
@property (nonatomic, strong) THNGoodsButton *mainButton;
/// 左侧副按钮：购买、定制、卖
@property (nonatomic, strong) THNGoodsButton *subButton;
/// 购物车
@property (nonatomic, strong) THNCartButton *cartButton;

@end

@implementation THNGoodsFunctionView

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupViewUI];
//    }
//    return self;
//}

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
    if (model.isCustomMade) {
        self.type = THNGoodsFunctionViewTypeCustom;
    } else {
        self.type = THNGoodsFunctionViewTypeDefault;
    }
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
            
        case THNGoodsFunctionViewTypeDirectSelect: {
            self.mainButton.type = THNGoodsButtonTypeAddCart;
            self.subButton.type = THNGoodsButtonTypeBuy;
            self.cartButton.hidden = YES;
        }
            break;
    }
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
    
    [self addSubview:self.mainButton];
    [self addSubview:self.subButton];
    [self addSubview:self.cartButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 是否是直接选择规格
    BOOL isDirectSelect = self.type == THNGoodsFunctionViewTypeDirectSelect;
    CGFloat cartWidth = !isDirectSelect ? 59 : 0;
    CGFloat buttonWidth = (CGRectGetWidth(self.bounds) - 40 - cartWidth) / 2;
    
    self.mainButton.frame = CGRectMake(20 + cartWidth, 5, buttonWidth, 40);
    [self.mainButton drawCornerWithType:(UILayoutCornerRadiusLeft) radius:4];

    self.subButton.frame = CGRectMake(CGRectGetMaxX(self.mainButton.frame), 5, buttonWidth, 40);
    [self.subButton drawCornerWithType:(UILayoutCornerRadiusRight) radius:4];
    
    if (!isDirectSelect) {
        self.cartButton.frame = CGRectMake(0, 5, 79, 40);
    }
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, 0)
                          end:CGPointMake(CGRectGetWidth(self.bounds), 0)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
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

@end
