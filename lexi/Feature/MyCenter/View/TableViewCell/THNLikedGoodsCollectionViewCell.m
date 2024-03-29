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
@property (nonatomic, strong) YYLabel *titleLabel;
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
        [self thn_setTitleText:goodsModel];
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

- (void)thn_setTitleText:(THNGoodsModel *)model {
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:model.name];
    UIFont *titleFont = [UIFont systemFontOfSize:12];
    titleAtt.color = [UIColor colorWithHexString:@"#333333"];
    titleAtt.font = titleFont;
    
    // 包邮标签
    UIImage *iconImage = [UIImage imageNamed:@"icon_express_free"];
    
    if (model.isFreePostage) {
        NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:iconImage
                                                                                        contentMode:UIViewContentModeLeft
                                                                                     attachmentSize:CGSizeMake(25, 12)
                                                                                        alignToFont:titleFont
                                                                                          alignment:YYTextVerticalAlignmentCenter];
        
        [titleAtt insertAttributedString:iconAtt atIndex:0];
    }
    
    self.titleLabel.attributedText = titleAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.goodsImageView];
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.priceLabel];
    [self addSubview:self.infoView];
}

- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds)));
        make.top.left.mas_equalTo(0);
    }];
    
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(14);
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(11);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
    }];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self thn_drawGoodsImageCorner];
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

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
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
