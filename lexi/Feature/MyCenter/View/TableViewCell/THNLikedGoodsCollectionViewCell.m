//
//  THNLikedGoodsCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedGoodsCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "YYLabel+Helper.h"
#import "UIImageView+WebImage.h"

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
/// 视图类型
@property (nonatomic, assign) THNGoodsListCellViewType viewType;


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
- (void)thn_setGoodsCellViewType:(THNGoodsListCellViewType)cellViewType goodsModel:(THNGoodsModel *)goodsModel showInfoView:(BOOL)show {
    [self thn_setGoodsCellViewType:cellViewType goodsModel:goodsModel showInfoView:show index:0];
}

- (void)thn_setGoodsCellViewType:(THNGoodsListCellViewType)cellViewType goodsModel:(THNGoodsModel *)goodsModel showInfoView:(BOOL)show index:(NSInteger)index {
    self.viewType = cellViewType;
    
    THNLoadImageUrlType urlType = (index + 1) % 5 ? THNLoadImageUrlTypeGoodsList : THNLoadImageUrlTypeWindowP500;
    [self.goodsImageView loadImageWithUrl:[goodsModel.cover loadImageUrlWithType:urlType]];
    
    if (show) {
        self.infoView.hidden = NO;
        self.titleLabel.text = goodsModel.name;
        [self thn_setPriceLabelTextWithPrice:goodsModel.minSalePrice ? goodsModel.minSalePrice : goodsModel.minPrice
                                   likeValue:goodsModel.likeCount];
    };
    
    [self setNeedsUpdateConstraints];
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

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.goodsImageView];
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.priceLabel];
    [self addSubview:self.infoView];
}

- (void)updateConstraints {
    [self setMasnoryLayout];

    [super updateConstraints];
}

- (void)setMasnoryLayout {
    self.goodsImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
    [self thn_drawGoodsImageCorner];
    
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

- (void)thn_drawGoodsImageCorner {
    switch (self.viewType) {
        case THNGoodsListCellViewTypeGoodsList:
        case THNGoodsListCellViewTypeUserCenter: {
            [self.goodsImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getters and setters
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.masksToBounds = YES;
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
