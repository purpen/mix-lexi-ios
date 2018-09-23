//
//  THNGoodsDescribeTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsDescribeTableViewCell.h"
#import <YYKit/YYKit.h>

static NSString *const kGoodsDescribeTableViewCellId = @"kGoodsDescribeTableViewCellId";
static NSString *const kTitleDes         = @"描述";
static NSString *const kTitleDispatch    = @"发货地";
static NSString *const kTitleTime        = @"交货时间";
static NSString *const kTitleSalesReturn = @"退货政策";

@interface THNGoodsDescribeTableViewCell () {
    BOOL _drawLine;
}

/// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
///
@property (nonatomic, strong) NSArray *titleArr;
/// 内容
@property (nonatomic, strong) YYLabel *contentLabel;

@end

@implementation THNGoodsDescribeTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsDescribeTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsDescribeTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsDescribeTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type goodsModel:(THNGoodsModel *)model showIcon:(BOOL)showIcon {
    if (type == THNGoodsDescribeCellTypeSalesReturn) {
        [self thn_setTitleWithType:type];
        [self thn_setSalesReturnTitle:model.returnPolicyTitle info:model.productReturnPolicy];
    
    } else if (type == THNGoodsDescribeCellTypeDes) {
        [self thn_setTitleWithType:type];
        [self thn_setDescribeInfoWithGoodsModel:model showIcon:showIcon];
    }
}

- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type storeModel:(THNStoreModel *)model {
    if (type == THNGoodsDescribeCellTypeDispatch) {
        NSString *country = model.country ? model.country : @"";
        NSString *city = model.city ? model.city : @"";
        NSString *dispatch = [NSString stringWithFormat:@"%@.%@", country, city];
        [self thn_setDescribeType:(THNGoodsDescribeCellTypeDispatch) content:dispatch];
    }
}

- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type freightModel:(THNFreightModel *)model {
    if (type == THNGoodsDescribeCellTypeTime) {
        THNFreightModelItem *item = model.items[0];
        NSString *minDay = item.minDays ? [NSString stringWithFormat:@"%zi", item.minDays] : @"";
        NSString *maxDay = item.maxDays ? [NSString stringWithFormat:@"%zi", item.maxDays] : @"";
        NSString *time = [NSString stringWithFormat:@"预计%@-%@天到达", minDay, maxDay];
        [self thn_setDescribeType:(THNGoodsDescribeCellTypeTime) content:time];
    }
}

- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type content:(NSString *)content {
    [self thn_setDescribeTitleText:self.titleArr[(NSUInteger)type] content:content];
}

- (void)thn_setDescribeTitleText:(NSString *)title content:(NSString *)content {
    [self thn_setTitleText:title];
    [self thn_setContentText:content];
}

- (void)thn_hiddenLine {
    _drawLine = NO;
}

#pragma mark - private methods
- (void)thn_setTitleWithType:(THNGoodsDescribeCellType)tyep {
    [self thn_setTitleText:self.titleArr[(NSUInteger)tyep]];
}

- (void)thn_setTitleText:(NSString *)text {
    self.titleLabel.text = text;
}

- (void)thn_setContentText:(NSString *)text {
    self.contentLabel.text = text;
}

/**
 设置“退换货政策”

 @param title 服务标题
 @param info 服务内容
 */
- (void)thn_setSalesReturnTitle:(NSString *)title info:(NSString *)info {
    NSString *titleText = title.length ? [NSString stringWithFormat:@"· %@\n", title] : @"";
    NSString *text = [NSString stringWithFormat:@"%@%@", titleText, info];
    
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.lineSpacing = 7;
    textAtt.paragraphSpacing = 3;
    textAtt.font = [UIFont systemFontOfSize:14];
    textAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    self.contentLabel.attributedText = textAtt;
}

/**
 设置”描述“内容

 @param model 商品数据
 */
- (void)thn_setDescribeInfoWithGoodsModel:(THNGoodsModel *)model showIcon:(BOOL)showIcon {
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] init];
    
    // 亮点
    BOOL showFeatures = model.features.length > 0;
    if (showFeatures) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"亮点" content:model.features showIcon:showIcon]];
    }
    
    // 材质
    BOOL showMaterial = model.materialName.length > 0;
    if (showMaterial) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"材质" content:model.materialName showIcon:showIcon]];
    }
    
    // 特点
    if (model.isCustomService) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"特点" content:@"可提供订制化服务" showIcon:showIcon]];
    }
    
    // 数量
    BOOL showCount = model.stockCount < 10;
    BOOL isSellOut = model.stockCount == 0;
    if (showCount) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"数量"
                                                                content:[NSString stringWithFormat:@"仅剩最后%zi件", model.stockCount]
                                                               showIcon:showIcon]];
    }
    if (isSellOut) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"数量" content:@"已售罄" showIcon:showIcon]];
    }
    
    textAtt.lineSpacing = 7;
    textAtt.paragraphSpacing = 3;
    
    self.contentLabel.attributedText = textAtt;
}

/**
 描述内容
 */
- (NSMutableAttributedString *)thn_getDescribePrefixText:(NSString *)text content:(NSString *)content showIcon:(BOOL)showIcon {
    NSMutableAttributedString *prefixAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", text]];
    prefixAtt.font = [UIFont systemFontOfSize:14 weight:showIcon ? UIFontWeightMedium : UIFontWeightRegular];
    prefixAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", content]];
    contentAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    contentAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    [prefixAtt appendAttributedString:contentAtt];
    
    if (showIcon) {
        [prefixAtt insertAttributedString:[self thn_getSymbolText] atIndex:0];
    }
    
    return prefixAtt;
}

/**
 前缀符号
 */
- (NSMutableAttributedString *)thn_getSymbolText {
    NSMutableAttributedString *symbolAtt = [[NSMutableAttributedString alloc] initWithString:@"·  "];
    symbolAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
    symbolAtt.color = [UIColor colorWithHexString:kColorMain];
    
    return symbolAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.titleArr = @[kTitleDes, kTitleDispatch, kTitleTime, kTitleSalesReturn];
    _drawLine = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectGetHeight(self.bounds) > 1) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(15);
        }];
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(9);
            make.bottom.mas_equalTo(-20);
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    if (CGRectGetHeight(self.bounds) >= 80) {
        if (_drawLine) {
            [UIView drawRectLineStart:CGPointMake(15, CGRectGetHeight(self.bounds) - 1)
                                  end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                                width:0.5
                                color:[UIColor colorWithHexString:@"#E9E9E9"]];
        }
    }
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightLight)];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
