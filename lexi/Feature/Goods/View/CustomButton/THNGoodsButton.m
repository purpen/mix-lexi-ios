//
//  THNGoodsButton.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsButton.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "THNConst.h"

static NSString *const kTitleBuy        = @"购买";
static NSString *const kTitleAddCart    = @"加入购物车";
static NSString *const kTitleCustom     = @"接单定制";
static NSString *const kTitleSell       = @"卖";

@interface THNGoodsButton ()

/// 标题
@property (nonatomic, strong) YYLabel *textLabel;

@end

@implementation THNGoodsButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithType:(THNGoodsButtonType)type {
    self = [super init];
    if (self) {
        [self thn_setButtonStyleWithType:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(THNGoodsButtonType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        [self thn_setButtonStyleWithType:type];
    }
    return self;
}

#pragma mark - private methods
- (void)thn_setButtonStyleWithType:(THNGoodsButtonType)type {
    NSArray *colorArr = @[kColorMain, @"#2D343A", kColorMain, @"#FF6666"];
    self.backgroundColor = [UIColor colorWithHexString:colorArr[(NSUInteger)type]];
    
    NSArray *titleArr = @[kTitleBuy, kTitleAddCart, kTitleCustom, kTitleSell];
    [self thn_setTitleLableText:titleArr[(NSUInteger)type]];
}

- (void)thn_setTitleLableText:(NSString *)text {
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:text];
    titleAtt.font = [UIFont systemFontOfSize:16];
    titleAtt.color = [UIColor whiteColor];
    titleAtt.alignment = NSTextAlignmentCenter;
    
    self.textLabel.attributedText = titleAtt;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(2);
    }];
}

#pragma mark - getters and setters
- (void)setType:(THNGoodsButtonType)type {
    [self thn_setButtonStyleWithType:type];
}

- (void)setTitle:(NSString *)title {
    [self thn_setTitleLableText:title];
}

- (YYLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[YYLabel alloc] init];
        _textLabel.userInteractionEnabled = NO;
    }
    return _textLabel;
}

@end
