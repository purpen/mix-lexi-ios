//
//  THNCouponGoodsView.m
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponGoodsView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIImageView+WebImage.h"
#import "UIColor+Extension.h"
#import "NSString+Helper.h"

@interface THNCouponGoodsView ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UIImageView *hintImageView;
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) YYLabel *priceLabel;
@property (nonatomic, strong) YYLabel *oriPriceLabel;

@end

@implementation THNCouponGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setStoreCouponGoodsSku:(THNCouponSharedModelProductSku *)sku {
    [self.goodsImageView loadImageWithUrl:[sku.productCover loadImageUrlWithType:(THNLoadImageUrlTypeWindowMd)]];
    self.titleLabel.text = sku.productName;
    self.priceLabel.text = [NSString formatFloat:sku.productAmount];
    [self thn_setOriginalPriceWithValue:sku.productCouponAmount];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)thn_setOriginalPriceWithValue:(CGFloat)value {
    if (value == 0) {
        self.oriPriceLabel.hidden = YES;
        return;
    }
    
    NSString *originalPriceStr = [NSString formatFloat:value];
    NSMutableAttributedString *originalPriceAtt = [[NSMutableAttributedString alloc] initWithString:originalPriceStr];
    originalPriceAtt.color = [UIColor colorWithHexString:@"#999999"];
    originalPriceAtt.font = [UIFont systemFontOfSize:10 weight:(UIFontWeightRegular)];
    originalPriceAtt.textStrikethrough = [YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle)];
    
    self.oriPriceLabel.hidden = NO;
    self.oriPriceLabel.attributedText = originalPriceAtt;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.goodsImageView];
    [self addSubview:self.hintImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.oriPriceLabel];
}

- (void)updateConstraints {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(CGRectGetWidth(self.bounds));
    }];
    
    [self.hintImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.goodsImageView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(13);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(16);
    }];
    
    [self.oriPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(2);
        make.height.mas_equalTo(13);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.backgroundColor = [UIColor whiteColor];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.cornerRadius = 2;
        _goodsImageView.layer.masksToBounds = YES;
    }
    return _goodsImageView;
}

- (UIImageView *)hintImageView {
    if (!_hintImageView) {
        _hintImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price_tag_0"]];
    }
    return _hintImageView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    return _priceLabel;
}

- (YYLabel *)oriPriceLabel {
    if (!_oriPriceLabel) {
        _oriPriceLabel = [[YYLabel alloc] init];
    }
    return _oriPriceLabel;
}

@end
