//
//  THNGoodsInfoTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsInfoTableViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIImageView+SDWedImage.h"
#import "YYLabel+Helper.h"

static NSString *const kGoodsInfoTableViewCellId = @"kGoodsInfoTableViewCellId";

@interface THNGoodsInfoTableViewCell ()

/// 图片
@property (nonatomic, strong) UIImageView *goodsImageView;
/// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
/// 现价
@property (nonatomic, strong) YYLabel *priceLabel;
/// 原价
@property (nonatomic, strong) YYLabel *oriPriceLabel;
/// 数量
@property (nonatomic, strong) YYLabel *countLabel;
/// 交货时间
@property (nonatomic, strong) YYLabel *timeLabel;
/// 颜色&规格
@property (nonatomic, strong) YYLabel *colorLabel;
/// 店铺
@property (nonatomic, strong) YYLabel *storeLabel;

@end

@implementation THNGoodsInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style type:(THNGoodsInfoCellType)type {
    THNGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsInfoTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsInfoTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsInfoTableViewCellId];
        cell.cellType = type;
    }
    return cell;
}

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView type:(THNGoodsInfoCellType)type {
    return [self initGoodsInfoCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault) type:type];
}

- (void)thn_setGoodsInfoWithModel:(THNGoodsModel *)model {
    [self.goodsImageView downloadImage:model.cover place:[UIImage imageNamed:@"default_goods_place"]];
    
    switch (self.cellType) {
        case THNGoodsInfoCellTypeSelectLogistics: {
            [self thn_setGoodsTitleWithText:model.name font:[UIFont systemFontOfSize:12]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - private methods
/**
 设置商品名称
 */
- (void)thn_setGoodsTitleWithText:(NSString *)text font:(UIFont *)font {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.font = font;
    att.color = [UIColor colorWithHexString:@"#333333"];
    att.lineSpacing = 6;
    
    self.titleLabel.attributedText = att;
}

/**
 设置店铺名称
 */
- (void)thn_setStoreNameWithText:(NSString *)text {
    UIFont *textFont = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.font = textFont;
    att.color = [UIColor colorWithHexString:@"#949EA6"];
    
    // 店铺名称设置图标
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store_gray"]];
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:iconImage
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(10, 10)
                                                                                    alignToFont:textFont
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];
    
    [att insertAttributedString:iconAtt atIndex:0];
    
    self.storeLabel.attributedText = att;
}

/**
 设置原价
 */
- (void)thn_setOriginalPriceWithValue:(CGFloat)value {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", value]];
    att.color = [UIColor colorWithHexString:@"#B2B2B2"];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    att.alignment = NSTextAlignmentRight;
    att.textStrikethrough = [YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle)];
    
    self.oriPriceLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.goodsImageView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.oriPriceLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.colorLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.storeLabel];
    
    self.goodsImageView.backgroundColor = [UIColor grayColor];
    [self thn_setGoodsTitleWithText:@"手作插画创意手提袋礼品见好就收的纪设计开始卡谁看饭刻开始可" font:[UIFont systemFontOfSize:12]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isSelectLogistics = self.cellType == THNGoodsInfoCellTypeSelectLogistics;
    self.backgroundColor = isSelectLogistics ? [UIColor colorWithHexString:@"#F7F9FB"] : [UIColor whiteColor];
    
    CGFloat imageH = self.cellType == THNGoodsInfoCellTypeOrderList ? CGRectGetHeight(self.bounds) - 15 : CGRectGetHeight(self.bounds) - 30;
    CGFloat originX = self.cellType == THNGoodsInfoCellTypeCartEdit ? 52 : 15;
    
    // 图片
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageH, imageH));
        make.left.mas_equalTo(originX);
        make.centerY.mas_equalTo(self);
    }];
    
    // 价格
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self.priceLabel thn_getLabelWidthWithMaxHeight:15]);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.goodsImageView.mas_top).with.offset(0);
    }];
    
    // 原价
    [self.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self.oriPriceLabel thn_getLabelWidthWithMaxHeight:15]);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(5);
    }];
    
    // 数量
    if (self.cellType == THNGoodsInfoCellTypeSubmitOrder || self.cellType == THNGoodsInfoCellTypeOrderList) {
        // 数量在标题下边
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
            make.top.equalTo(self.colorLabel.mas_bottom).with.offset(5);
            make.right.mas_equalTo(self.titleLabel.mas_right).with.offset(0);
            make.height.mas_equalTo(15);
        }];
        
    } else {
        // 数量在标题右边
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([self.countLabel thn_getLabelWidthWithMaxHeight:15]);
            make.height.mas_equalTo(15);
            make.right.equalTo(self.priceLabel.mas_left).with.offset(-10);
            make.top.equalTo(self.goodsImageView.mas_top).with.offset(0);
        }];
    }
    
    if (self.cellType == THNGoodsInfoCellTypeSelectLogistics) {
        // 标题在中间
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
            make.top.bottom.mas_offset(0);
            make.right.mas_equalTo(-35);
        }];
        
    } else {
        // 标题在顶部
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
            make.top.equalTo(self.goodsImageView.mas_top).with.offset(0);
            make.right.mas_equalTo(self.countLabel.mas_left).with.offset(-10);
            make.height.mas_equalTo([self.titleLabel thn_getLabelHeightWithMaxWidth:MAXFLOAT]);
        }];
    }
    
    // 颜色
    [self.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(self.titleLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(15);
    }];
    
    // 交货时间
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.top.equalTo(self.colorLabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(self.titleLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(15);
    }];
    
    // 店铺
    [self.storeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
        make.right.mas_equalTo(self.titleLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - setup UI
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodsImageView;
}

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
        _priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _priceLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (YYLabel *)oriPriceLabel {
    if (!_oriPriceLabel) {
        _oriPriceLabel = [[YYLabel alloc] init];
    }
    return _oriPriceLabel;
}

- (YYLabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[YYLabel alloc] init];
        _countLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _countLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _colorLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (YYLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
    }
    return _timeLabel;
}

- (YYLabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[YYLabel alloc] init];
        _colorLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
        _colorLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightLight)];
    }
    return _colorLabel;
}

- (YYLabel *)storeLabel {
    if (!_storeLabel) {
        _storeLabel = [[YYLabel alloc] init];
    }
    return _storeLabel;
}

@end
