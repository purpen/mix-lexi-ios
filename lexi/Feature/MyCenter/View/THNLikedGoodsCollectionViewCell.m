//
//  THNLikedGoodsCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedGoodsCollectionViewCell.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "YYLabel+Helper.h"
#import "UIImageView+SDWedImage.h"

static NSString *const kTextLikePrefix = @"喜欢 +";

@interface THNLikedGoodsCollectionViewCell ()

/// 商品图片
@property (nonatomic, strong) UIImageView *goodsImageView;
/// 商品信息内容视图
@property (nonatomic, strong) UIView *infoView;
/// 商品标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 商品价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 喜欢数量
@property (nonatomic, strong) YYLabel *likeValueLabel;

@end

@implementation THNLikedGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setGoodsModel:(THNProductModel *)model showInfoView:(BOOL)show {
    [self.goodsImageView downloadImage:model.cover place:[UIImage imageNamed:@""]];
    
    if (show) {
        self.infoView.hidden = NO;
        self.titleLabel.text = @"阿斯顿发撒到噶树大根深的根深蒂固";
        [self thn_setPriceLabelTextWithPrice:299];
        [self thn_setLikeValueLabelTextWithValue:140];
    };

    [self layoutIfNeeded];
}

#pragma mark - private methods
- (void)thn_setPriceLabelTextWithPrice:(CGFloat)price {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f", price]];
    attStr.yy_color = [UIColor colorWithHexString:@"#333333"];
    attStr.yy_font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    
    self.priceLabel.attributedText = attStr;
}

- (void)thn_setLikeValueLabelTextWithValue:(NSInteger)value {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: \
                                         [NSString stringWithFormat:@"%@%zi", kTextLikePrefix, value]];
    attStr.yy_color = [UIColor colorWithHexString:@"#999999"];
    attStr.yy_font = [UIFont systemFontOfSize:11 weight:(UIFontWeightLight)];
    
    self.likeValueLabel.attributedText = attStr;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.goodsImageView];
    
    [self addSubview:self.infoView];
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.priceLabel];
    [self.infoView addSubview:self.likeValueLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)));
        make.top.left.mas_equalTo(0);
    }];
    [self.goodsImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(12);
    }];
    
    CGFloat priceLableWidth = [self.priceLabel thn_getLabelWidthWithMaxHeight:11];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(priceLableWidth, 11));
    }];
    
    CGFloat likeLableWidth = [self.likeValueLabel thn_getLabelWidthWithMaxHeight:11];
    [self.likeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).with.offset(5);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(likeLableWidth, 11));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImageView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodsImageView;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        _infoView.hidden = YES;
    }
    return _infoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
    }
    return _priceLabel;
}

- (YYLabel *)likeValueLabel {
    if (!_likeValueLabel) {
        _likeValueLabel = [[YYLabel alloc] init];
    }
    return _likeValueLabel;
}

@end
