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
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "THNGoodsSkuCollecitonView.h"

static NSString *const kTitleColor = @"颜色";
static NSString *const kTitleSize  = @"尺寸";

@interface THNGoodsSkuView ()

/// 商品标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, assign) CGFloat titleH;
/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 颜色列表
@property (nonatomic, strong) THNGoodsSkuCollecitonView *colorCollectionView;
/// 尺寸列表
@property (nonatomic, strong) THNGoodsSkuCollecitonView *sizeCollectionView;

@end

@implementation THNGoodsSkuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setGoodsSkuModel:(THNSkuModel *)model {
    [self thn_setPriceTextWithValue:189.2];
    [self.colorCollectionView thn_setSkuNameData:model.colors];
    [self.sizeCollectionView thn_setSkuNameData:model.modes];
}

/**
 设置商品标题
 */
- (void)thn_setTitleAttributedString:(NSAttributedString *)string {
    self.titleLabel.attributedText = string;
    self.titleH = [self.titleLabel thn_getLabelHeightWithMaxWidth:CGRectGetWidth(self.bounds) - 40];
}

/**
 已选择“购买” / “加购物车”
 */
- (void)thn_setGoodsSkuViewHandleType:(THNGoodsButtonType)handleType titleAttributedString:(NSAttributedString *)string {
    self.handleType = handleType;
    [self thn_setTitleAttributedString:string];
}

#pragma mark - private methods
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

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.colorCollectionView];
    [self addSubview:self.sizeCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
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
    
    [self.colorCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(30);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(24);
    }];
    
    [self.sizeCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.colorCollectionView.mas_bottom).with.offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(24);
    }];
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
