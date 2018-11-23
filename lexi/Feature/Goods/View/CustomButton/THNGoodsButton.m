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
#import "NSString+Helper.h"

static NSString *const kTitleBuy        = @"购买";
static NSString *const kTitleAddCart    = @"加入购物车";
static NSString *const kTitleCustom     = @"接单订制";
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
    
    if (type == THNGoodsButtonTypeSell) {
        [self thn_setSellTitleLableTextWithMoney:self.makeMoney];
        
    } else {
        NSArray *titleArr = @[kTitleBuy, kTitleAddCart, kTitleCustom];
        [self thn_setTitleLableText:titleArr[(NSUInteger)type]];
    }
}

/**
 正常功能按钮
 */
- (void)thn_setTitleLableText:(NSString *)text {
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:text];
    titleAtt.font = [UIFont systemFontOfSize:16];
    titleAtt.color = [UIColor whiteColor];
    titleAtt.alignment = NSTextAlignmentCenter;
    
    self.textLabel.attributedText = titleAtt;
}

/**
 分销商品，卖货的按钮
 */
- (void)thn_setSellTitleLableTextWithMoney:(CGFloat)money {
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTitleSell];
    titleAtt.font = [UIFont systemFontOfSize:16];
    titleAtt.color = [UIColor whiteColor];
    
    if (money > 0) {
        NSString *makeMoneyStr = [NSString stringWithFormat:@" 赚%@", [NSString formatFloat:money]];
        NSMutableAttributedString *moneyAtt = [[NSMutableAttributedString alloc] initWithString:makeMoneyStr];
        moneyAtt.font = [UIFont systemFontOfSize:12];
        moneyAtt.color = [UIColor whiteColor];
        
        [titleAtt appendAttributedString:moneyAtt];
    }
    
    titleAtt.alignment = NSTextAlignmentCenter;
    
    self.textLabel.attributedText = titleAtt;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.textLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(2);
    }];
}

#pragma mark - getters and setters
- (void)setType:(THNGoodsButtonType)type {
    _type = type;
    
    [self thn_setButtonStyleWithType:type];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
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
