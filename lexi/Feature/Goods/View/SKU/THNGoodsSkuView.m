//
//  THNGoodsSkuView.m
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsSkuView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "YYLabel+Helper.h"
#import "NSString+Helper.h"
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "THNGoodsSkuCollecitonView.h"

static NSString *const kTitleColor = @"颜色";
static NSString *const kTitleSize  = @"尺寸";
///
static CGFloat const kMaxHeight = 337.0;

@interface THNGoodsSkuView ()

/// 商品标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, assign) CGFloat titleH;
/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 滚动容器
@property (nonatomic, strong) UIScrollView *contentView;
/// 颜色列表
@property (nonatomic, strong) THNGoodsSkuCollecitonView *colorCollectionView;
@property (nonatomic, assign) CGFloat colorHeight;
/// 尺寸列表
@property (nonatomic, strong) THNGoodsSkuCollecitonView *sizeCollectionView;
@property (nonatomic, assign) CGFloat sizeHeight;

@end

@implementation THNGoodsSkuView

- (instancetype)initWithSkuModel:(THNSkuModel *)skuModel goodsModel:(THNGoodsModel *)goodsModel {
    self = [super init];
    if (self) {
        [self thn_setGoodsSkuModel:skuModel];
        [self thn_setTitleText:goodsModel];
        [self setupViewUI];
    }
    return self;
}

#pragma mark - private methods
/**
 设置 SKU
 */
- (void)thn_setGoodsSkuModel:(THNSkuModel *)model {
    [self thn_setPriceTextWithValue:189.2];
    
    if (model.colors.count) {
        [self.colorCollectionView thn_setSkuNameData:model.colors];
        self.colorHeight = [self thn_getModeContentHeightWithModelData:model.colors];
    }
    
    if (model.modes.count) {
        [self.sizeCollectionView thn_setSkuNameData:model.modes];
        self.sizeHeight = [self thn_getModeContentHeightWithModelData:model.modes];
    }
}

/**
 设置商品标题
 */
- (void)thn_setTitleText:(THNGoodsModel *)model {
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:model.name];
    UIFont *titleFont = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    titleAtt.color = [UIColor colorWithHexString:@"#333333"];
    titleAtt.font = titleFont;
    
    // 包邮标签
    UIImage *iconImage = [UIImage imageNamed:@"icon_express_free"];
    
    if (model.isFreePostage) {
        NSMutableAttributedString *iconAtt = [NSMutableAttributedString \
                                              attachmentStringWithContent:iconImage
                                              contentMode:UIViewContentModeLeft
                                              attachmentSize:CGSizeMake(iconImage.size.width + 5, iconImage.size.height)
                                              alignToFont:titleFont
                                              alignment:YYTextVerticalAlignmentCenter];
        
        [titleAtt insertAttributedString:iconAtt atIndex:0];
    }
    titleAtt.lineSpacing = 5;
    
    self.titleLabel.attributedText = titleAtt;
    self.titleH = [self.titleLabel thn_getLabelHeightWithMaxWidth:SCREEN_WIDTH - 40];
}

/**
 设置商品价格
 */
- (void)thn_setPriceTextWithValue:(CGFloat)value {
    NSString *salePriceStr = [NSString stringWithFormat:@"￥%.2f", value];
    NSMutableAttributedString *salePriceAtt = [[NSMutableAttributedString alloc] initWithString:salePriceStr];
    salePriceAtt.color = [UIColor colorWithHexString:@"#333333"];
    salePriceAtt.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    
    self.priceLabel.attributedText = salePriceAtt;
}

/**
 sku 内容的高度
 */
- (CGFloat)thn_getModeContentHeightWithModelData:(NSArray *)data {
    CGFloat contentW = 0;
    for (THNSkuModelColor *model in data) {
        CGFloat nameW = [model.name boundingSizeWidthWithFontSize:12] + 22;
        contentW += nameW;
    }
    
    CGFloat contentH = 34.0;
    CGFloat lineNum = (contentW - 10) / (SCREEN_WIDTH - 70);
    
    return contentH * ceil(lineNum);
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.colorCollectionView];
    [self.contentView addSubview:self.sizeCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT - [self thn_getSkuViewSizeHeight], SCREEN_WIDTH, [self thn_getSkuViewSizeHeight]);
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(self.titleH);
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(kDeviceiPhoneX ? -90 : -70);
    }];
    self.contentView.contentSize = CGSizeMake(SCREEN_WIDTH, [self thn_getContentSizeHeight]);
    
    [self.colorCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, self.colorHeight));
    }];
    
    [self.sizeCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.colorCollectionView.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, self.sizeHeight));
    }];
}

- (CGFloat)thn_getContentSizeHeight {
    CGFloat contentH = self.colorHeight + self.sizeHeight + 35;
    contentH = self.colorHeight == 0 ? contentH - 20 : contentH;
    contentH = self.sizeHeight == 0 ? contentH - 20 : contentH;
    
    return contentH;
}

- (CGFloat)thn_getSkuViewSizeHeight {
    CGFloat originBottom = kDeviceiPhoneX ? 90 : 75;
    CGFloat contentSizeH = [self thn_getContentSizeHeight];
    CGFloat selfHeight = self.titleH + contentSizeH + originBottom + 60;
    selfHeight = selfHeight > kMaxHeight ? kMaxHeight : selfHeight;
    
    return selfHeight;
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
    }
    return _priceLabel;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
    }
    return _contentView;
}

- (THNGoodsSkuCollecitonView *)colorCollectionView {
    if (!_colorCollectionView) {
        _colorCollectionView = [[THNGoodsSkuCollecitonView alloc] initWithFrame:CGRectZero title:kTitleColor];
    }
    return _colorCollectionView;
}

- (THNGoodsSkuCollecitonView *)sizeCollectionView {
    if (!_sizeCollectionView) {
        _sizeCollectionView = [[THNGoodsSkuCollecitonView alloc] initWithFrame:CGRectZero title:kTitleSize];
    }
    return _sizeCollectionView;
}

@end
