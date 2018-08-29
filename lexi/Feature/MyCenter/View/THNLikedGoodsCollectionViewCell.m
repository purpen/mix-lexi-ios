//
//  THNLikedGoodsCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedGoodsCollectionViewCell.h"
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
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
/// 商品价格&喜欢数量
@property (nonatomic, strong) YYLabel *priceLabel;

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
    [self.goodsImageView downloadImage:model.cover
                               placess:[UIImage imageNamed:@"default_goods_place"]
                             completed:^(UIImage *image, NSError *error) {
                                 if (error) return;
                                 [self thn_showLoadImageAnimate:YES];
                             }];
    
    if (show) {
        self.infoView.hidden = NO;
        self.titleLabel.text = model.name;
        [self thn_setPriceLabelTextWithPrice:model.min_sale_price ? model.min_sale_price : model.min_price
                                   likeValue:model.like_count];
    };
    
    [self layoutIfNeeded];
}

#pragma mark - private methods
- (void)thn_setPriceLabelTextWithPrice:(CGFloat)price likeValue:(NSInteger)value {
    // 价格
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f  ", price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    priceAtt.color = [UIColor colorWithHexString:@"#333333"];
    priceAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    
    if (value > 0) {
        // 喜欢数量
        NSString *likeStr = [NSString stringWithFormat:@"%@%zi", kTextLikePrefix, value];
        NSMutableAttributedString *likeAtt = [[NSMutableAttributedString alloc] initWithString:likeStr];
        likeAtt.color = [UIColor colorWithHexString:@"#999999"];
        likeAtt.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightLight)];
        
        [priceAtt appendAttributedString:likeAtt];
    }

    self.priceLabel.attributedText = priceAtt;
}

- (void)thn_showLoadImageAnimate:(BOOL)show {
    self.goodsImageView.alpha = 0.0f;
    [UIView animateWithDuration:0.4 animations:^{
        self.goodsImageView.alpha = 1.0f;
    }];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.goodsImageView];
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.priceLabel];
    [self addSubview:self.infoView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds)));
        make.top.left.mas_equalTo(0);
    }];
    [self.goodsImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];

    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(12);
    }];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(11);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
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

@end
