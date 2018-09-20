//
//  THNGoodsTitleTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsTitleTableViewCell.h"
#import "YYLabel+Helper.h"

static NSString *const kGoodsTitleTableViewCellId = @"kGoodsTitleTableViewCellId";

@interface THNGoodsTitleTableViewCell ()

/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 原价价格
@property (nonatomic, strong) YYLabel *originalPriceLabel;

@end

@implementation THNGoodsTitleTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsTitleTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsTitleTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsTitleTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setGoodsTitleWithModel:(THNGoodsModel *)model {
    [self thn_setTitleText:model];
    [self thn_setPriceTextWithValue:model.minSalePrice ? model.minSalePrice : model.minPrice];
    [self thn_setOriginalPriceTextWithValue:model.minSalePrice == 0 ? 0 : model.minPrice];
}

#pragma mark - private methods
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
}

- (void)thn_setPriceTextWithValue:(CGFloat)value {
    NSString *salePriceStr = [NSString stringWithFormat:@"￥%.2f", value];
    NSMutableAttributedString *salePriceAtt = [[NSMutableAttributedString alloc] initWithString:salePriceStr];
    salePriceAtt.color = [UIColor colorWithHexString:@"#333333"];
    salePriceAtt.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    
    self.priceLabel.attributedText = salePriceAtt;
}

- (void)thn_setOriginalPriceTextWithValue:(CGFloat)value {
    if (value == 0) {
        self.originalPriceLabel.hidden = YES;
        return;
    }
    
    NSString *originalPriceStr = [NSString stringWithFormat:@"¥%.2f", value];
    NSMutableAttributedString *originalPriceAtt = [[NSMutableAttributedString alloc] initWithString:originalPriceStr];
    originalPriceAtt.color = [UIColor colorWithHexString:@"#949EA6"];
    originalPriceAtt.font = [UIFont systemFontOfSize:14];
    originalPriceAtt.textStrikethrough = [YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle)];

    self.originalPriceLabel.hidden = NO;
    self.originalPriceLabel.attributedText = originalPriceAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.originalPriceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:self.titleLabel.attributedText.string fontSize:16 lineSpacing:6
                                                          fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(textH);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo([self.priceLabel thn_getLabelWidthWithMaxHeight:20]);
    }];
    
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).with.offset(5);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.priceLabel);
        make.height.mas_equalTo(20);
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

- (YYLabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[YYLabel alloc] init];
    }
    return _originalPriceLabel;
}

@end
