//
//  THNPaymentPriceView.m
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaymentPriceView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

static NSString *const kTextPrice       = @"小计：";
static NSString *const kTextFreight     = @"运费：";
static NSString *const kTextTotalPrice  = @"总计\n";

@interface THNPaymentPriceView ()

@property (nonatomic, strong) UIView *containerView;
/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 运费
@property (nonatomic, strong) YYLabel *freightLabel;
/// 总价
@property (nonatomic, strong) YYLabel *totalPriceLabel;

@end;

@implementation THNPaymentPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setPriceValue:(CGFloat)priceValue totalPriceValue:(CGFloat)totalPriceValue freightValue:(CGFloat)freightValue {
    self.priceLabel.attributedText = [self thn_getPriceAttributedStringWithValue:priceValue];
    self.freightLabel.attributedText = [self thn_getFreightAttributedStringWithValue:freightValue];
    self.totalPriceLabel.attributedText = [self thn_getTotalPriceAttributedStringWithValue:totalPriceValue];
}

#pragma mark - private methods
- (NSMutableAttributedString *)thn_getPriceAttributedStringWithValue:(CGFloat)value {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextPrice];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    att.color = [UIColor colorWithHexString:@"#999999"];
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f", value]];
    priceAtt.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    priceAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    [att appendAttributedString:priceAtt];
    
    return att;
}

- (NSMutableAttributedString *)thn_getFreightAttributedStringWithValue:(CGFloat)value {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextFreight];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    att.color = [UIColor colorWithHexString:@"#999999"];
    
    NSString *freightStr = value == 0 ? @"包邮" : [NSString stringWithFormat:@"￥%.2f", value];
    NSMutableAttributedString *freightAtt = [[NSMutableAttributedString alloc] initWithString:freightStr];
    freightAtt.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightMedium)];
    freightAtt.color = [UIColor colorWithHexString:@"#C2A67D"];
    
    [att appendAttributedString:freightAtt];
    
    return att;
}

- (NSMutableAttributedString *)thn_getTotalPriceAttributedStringWithValue:(CGFloat)value {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextTotalPrice];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    att.color = [UIColor colorWithHexString:@"#999999"];
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f", value]];
    priceAtt.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    priceAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    priceAtt.alignment = NSTextAlignmentRight;
    
    att.alignment = NSTextAlignmentRight;
    att.lineSpacing = 7;
    [att appendAttributedString:priceAtt];
    
    return att;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.priceLabel];
    [self.containerView addSubview:self.freightLabel];
    [self.containerView addSubview:self.totalPriceLabel];
}

- (void)updateConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(16);
    }];
    
    [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(15);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
    }
    return _priceLabel;
}

- (YYLabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel = [[YYLabel alloc] init];
    }
    return _freightLabel;
}

- (YYLabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[YYLabel alloc] init];
        _totalPriceLabel.numberOfLines = 2;
    }
    return _totalPriceLabel;
}

@end
