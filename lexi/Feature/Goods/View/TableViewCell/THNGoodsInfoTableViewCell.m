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
#import "UIImageView+WebImage.h"
#import "YYLabel+Helper.h"
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "SVProgressHUD+Helper.h"

static NSString *const kGoodsInfoTableViewCellId = @"kGoodsInfoTableViewCellId";
///
static NSString *const kTextSaleOut         = @"售罄";
static NSString *const kTextGoodsOut        = @"该商品已下架";
static NSString *const kTextGoodsSaleOut    = @"该商品已售罄";
static NSString *const kTextResetSku        = @"重选规格";

@interface THNGoodsInfoTableViewCell ()

/// 图片
@property (nonatomic, strong) UIImageView *goodsImageView;
/// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
/// 现价
@property (nonatomic, strong) YYLabel *priceLabel;
@property (nonatomic, assign) CGFloat priceW;
/// 原价
@property (nonatomic, strong) YYLabel *oriPriceLabel;
@property (nonatomic, assign) CGFloat oriPriceW;
/// 数量
@property (nonatomic, strong) YYLabel *countLabel;
@property (nonatomic, assign) CGFloat countW;
/// 交货时间
@property (nonatomic, strong) YYLabel *timeLabel;
/// 颜色&规格
@property (nonatomic, strong) YYLabel *colorLabel;
/// 店铺
@property (nonatomic, strong) YYLabel *storeLabel;
/// 商品销售状态标签
@property (nonatomic, strong) YYLabel *tagLabel;
/// 商品销售状态提示
@property (nonatomic, strong) YYLabel *statusLabel;
/// 加入购物车按钮
@property (nonatomic, strong) UIButton *addCart;
/// 选择按钮
@property (nonatomic, strong) UIButton *selectButton;
/// 数量编辑视图
@property (nonatomic, strong) UIView *editCountView;
/// 数量加
@property (nonatomic, strong) UIButton *addCountButton;
/// 数量减
@property (nonatomic, strong) UIButton *subCountButton;
/// 编辑数量
@property (nonatomic, strong) UILabel *editCountLabel;
/// 商品数量
@property (nonatomic, assign) NSInteger goodsCount;
/// 库存数量
@property (nonatomic, assign) NSInteger stockCount;
/// 商品状态
@property (nonatomic, assign) NSInteger goodsStatus;
/// 重选 sku 规格
@property (nonatomic, strong) UIButton *resetSkuButton;

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

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView
                                     cellStyle:(UITableViewCellStyle)style
                                          type:(THNGoodsInfoCellType)type
                               reuseIdentifier:(NSString *)reuseIdentifier {
    THNGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[THNGoodsInfoTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
        cell.cellType = type;
        [cell thn_setBackgroundColor];
    }
    return cell;
}

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView
                                          type:(THNGoodsInfoCellType)type
                               reuseIdentifier:(NSString *)reuseIdentifier {
    
    return [self initGoodsInfoCellWithTableView:tableView
                                      cellStyle:(UITableViewCellStyleDefault)
                                           type:type
                                reuseIdentifier:reuseIdentifier];
}

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView type:(THNGoodsInfoCellType)type {
    return [self initGoodsInfoCellWithTableView:tableView type:type reuseIdentifier:kGoodsInfoTableViewCellId];
}

#pragma mark - set model
- (void)thn_setGoodsInfoWithModel:(THNGoodsModel *)model {
    [self.goodsImageView loadImageWithUrl:[model.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    
    switch (self.cellType) {
        case THNGoodsInfoCellTypeSelectLogistics: {
            [self thn_setGoodsTitleWithText:model.name font:[UIFont systemFontOfSize:12]];
        }
            break;
            
        case THNGoodsInfoCellTypeCartWish: {
            [self thn_setGoodsTitleWithText:model.name font:[UIFont systemFontOfSize:13]];
            [self thn_setSalePriceWithValue:model.minSalePrice > 0 ? model.minSalePrice : model.minPrice oriPrice:0.0];
            
            self.stockCount = model.totalStock;
            self.goodsStatus = model.status;
            [self thn_setStatusTagAndHintText];
        }
            break;
            
        default:
            break;
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)thn_setSkuGoodsInfoWithModel:(THNSkuModelItem *)model {
    [self.goodsImageView loadImageWithUrl:[model.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    [self thn_setGoodsTitleWithText:model.productName font:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)]];
    
    [self setNeedsUpdateConstraints];
}

- (void)thn_setCartGoodsInfoWithModel:(THNCartModelItem *)model {
    if (!model.product.rid) return;
    
    [self.goodsImageView loadImageWithUrl:[model.product.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    
    [self thn_setGoodsTitleWithText:model.product.productName font:[UIFont systemFontOfSize:13 weight:(UIFontWeightMedium)]];
    [self thn_setStoreNameWithText:model.product.storeName];
    [self thn_setSalePriceWithValue:model.product.salePrice oriPrice:model.product.price];
    [self thn_setGoodsColorText:model.product.sColor mode:model.product.sModel];
    
    if (self.cellType == THNGoodsInfoCellTypeCartNormal) {
        self.editCountView.hidden = NO;
        
        self.goodsCount = model.quantity;
        self.stockCount = model.product.stockCount;
        self.goodsStatus = model.product.status;
        
        [self thn_setStatusTagAndHintText];
        [self thn_setShowResetSkuButtonWithSkuStock:model.product.stockCount
                                         totalStock:model.product.productTotalCount];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.selectButton.selected = isSelected;
}

- (void)setGoodsCount:(NSInteger)goodsCount {
    _goodsCount = goodsCount;
    
    self.editCountLabel.text = [NSString stringWithFormat:@"%zi", goodsCount];
}

#pragma mark - event response
- (void)addCartAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedAddGoodsToCart:)]) {
        [self.delegate thn_didSelectedAddGoodsToCart:self];
    }
}

- (void)selectButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedEditGoodsCell:)]) {
        [self.delegate thn_didSelectedEditGoodsCell:self];
    }
}

- (void)subCountButtonAction:(id)sender {
    if (self.goodsCount == 1) {
        [SVProgressHUD thn_showInfoWithStatus:@"数量不能再减少了"];
        return;
    }
    
    self.goodsCount -= 1;
    [self thn_setEditCountValue:self.goodsCount];
}

- (void)addCountButtonAction:(id)sender {
    if (self.goodsCount == self.stockCount) {
        [SVProgressHUD thn_showInfoWithStatus:@"超出可售数量范围"];
        return;
    }
    
    self.goodsCount += 1;
    [self thn_setEditCountValue:self.goodsCount];
}

- (void)resetSkuButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedResetSkuGoodsCell:)]) {
        [self.delegate thn_didSelectedResetSkuGoodsCell:self];
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
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", text]];
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
 设置价格信息
 */
- (void)thn_setSalePriceWithValue:(CGFloat)salePrice oriPrice:(CGFloat)oriPrice {
    if (salePrice == 0) {
        salePrice = oriPrice;
        self.oriPriceLabel.hidden = YES;
    }
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString formatFloat:salePrice]];
    priceAtt.color = [UIColor colorWithHexString:@"#333333"];
    priceAtt.font = [self thn_getPriceFont];
    priceAtt.alignment = NSTextAlignmentRight;
    self.priceLabel.attributedText = priceAtt;
    self.priceW = [priceAtt.string boundingSizeWidthWithFontSize:14] + 4;
    
    if (oriPrice <= 0) return;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString formatFloat:oriPrice]];
    att.color = [UIColor colorWithHexString:@"#B2B2B2"];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    att.alignment = NSTextAlignmentRight;
    att.textStrikethrough = [YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle)];
    self.oriPriceLabel.attributedText = att;
    self.oriPriceW = [att.string boundingSizeWidthWithFontSize:12] + 4;
}

/**
 商品数量
 */
- (void)thn_setGoodsCount:(NSInteger)count {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi", count]];
    att.color = [UIColor colorWithHexString:@"#999999"];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    att.alignment = NSTextAlignmentRight;
    self.countLabel.attributedText = att;
    self.countW = [att.string boundingSizeWidthWithFontSize:12] + 4;
}

/**
 设置商品的颜色/尺寸信息
 */
- (void)thn_setGoodsColorText:(NSString *)color mode:(NSString *)mode {
    NSString *skuMode = [NSString stringWithFormat:@"%@ / %@", color, mode];
    
    self.colorLabel.text = skuMode;
}

/**
 设置商品状态
 */
- (void)thn_setGoodsStatusInfoWithText:(NSString *)text {
    self.tagLabel.text = text;
    self.tagLabel.hidden = text.length == 0;
}

/**
 设置编辑数量
 */
- (void)thn_setEditCountValue:(NSInteger)value {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedEditGoodsCountCell:count:)]) {
        [self.delegate thn_didSelectedEditGoodsCountCell:self count:value];
    }
}

/**
 商品状态提示信息
 */
- (void)thn_setHintStatusText:(NSString *)text {
    self.statusLabel.hidden = text.length == 0;
    self.statusLabel.text = text;
}

- (void)thn_setStatusTagAndHintText {
    if (self.cellType == THNGoodsInfoCellTypeCartNormal) {
        [self thn_setGoodsStatusInfoWithText:self.stockCount ? @"" : kTextSaleOut];
        self.editCountView.hidden = self.goodsStatus == 2;
        
    } else if (self.cellType == THNGoodsInfoCellTypeCartWish) {
        self.addCart.hidden = self.goodsStatus == 2;
    }
    
    [self thn_setHintStatusText:self.goodsStatus == 2 ? kTextGoodsOut : @""];
}

/**
 设置重选规格按钮

 @param skuStock sku 的库存
 @param totalStock 该商品的总库存
 */
- (void)thn_setShowResetSkuButtonWithSkuStock:(NSInteger)skuStock totalStock:(NSInteger)totalStock {
    // 存在其他 sku
    BOOL hasOtherSku = totalStock - skuStock > 0;
    
    if (skuStock == 0 && hasOtherSku) {
        self.resetSkuButton.hidden = NO;
        self.editCountView.hidden = YES;
        self.statusLabel.hidden = YES;
        
    } else {
        self.resetSkuButton.hidden = YES;
    }
}

/**
 设置背景颜色
 */
- (void)thn_setBackgroundColor {
    BOOL isSelectLogistics = self.cellType == THNGoodsInfoCellTypeSelectLogistics;
    self.backgroundColor = isSelectLogistics ? [UIColor colorWithHexString:@"#F7F9FB"] : [UIColor whiteColor];
}

- (CGSize)thn_getImageSize {
    CGFloat imageH = 60.0;
    
    switch (self.cellType) {
        case THNGoodsInfoCellTypeCartNormal:
        case THNGoodsInfoCellTypeCartEdit:
        case THNGoodsInfoCellTypeCartWish: {
            imageH = 70.0;
        }
            break;
            
        case THNGoodsInfoCellTypePaySuccess:
        case THNGoodsInfoCellTypeSubmitOrder: {
            imageH = 65.0;
        }
            break;
            
        case THNGoodsInfoCellTypeOrderList: {
            imageH = 60.0;
        }
            break;
        
        default:
            break;
    }
    
    return CGSizeMake(imageH, imageH);
}

- (CGFloat)thn_getTitleHeight {
    CGFloat titleH = 15.0;
    
    switch (self.cellType) {
        case THNGoodsInfoCellTypeCartWish:
        case THNGoodsInfoCellTypeOrderList: {
            titleH = [self.titleLabel thn_getLabelHeightWithMaxWidth:kScreenWidth - 190];
        }
            break;
            
        default:
            break;
    }
    
    return titleH;
}

- (UIFont *)thn_getPriceFont {
    UIFont *priceFont = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    
    switch (self.cellType) {
        case THNGoodsInfoCellTypeCartNormal:
        case THNGoodsInfoCellTypeCartEdit:
        case THNGoodsInfoCellTypeCartWish: {
            priceFont = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        }
            break;
            
        default:
            break;
    }
    
    return priceFont;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.showLine = YES;
    
    [self addSubview:self.goodsImageView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.oriPriceLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.colorLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.storeLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.addCart];
    [self addSubview:self.selectButton];
    [self.editCountView addSubview:self.subCountButton];
    [self.editCountView addSubview:self.addCountButton];
    [self.editCountView addSubview:self.editCountLabel];
    [self addSubview:self.editCountView];
    [self addSubview:self.resetSkuButton];
    [self addSubview:self.statusLabel];
}

- (void)updateConstraints {
    // 图片
    if (self.cellType == THNGoodsInfoCellTypeCartEdit) {
        [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self thn_getImageSize]);
            make.left.mas_equalTo(52);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
        
    } else {
        [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self thn_getImageSize]);
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
    }
    
    // 销售状态
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(31, 18));
        make.top.left.equalTo(self.goodsImageView).with.offset(5);
    }];
    
    // 价格
    if (self.cellType != THNGoodsInfoCellTypeCartWish) {
        // 价格在右边
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.priceW);
            make.height.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.goodsImageView.mas_top).with.offset(0);
        }];
        
        // 下架提示信息在右边
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 12));
            make.right.mas_equalTo(-13);
            make.bottom.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
        }];
    }
    
    // 原价
    [self.oriPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.oriPriceW);
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
            make.right.equalTo(self.titleLabel.mas_right).with.offset(0);
            make.height.mas_equalTo(15);
        }];
        
    } else {
        // 数量在标题右边
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.countW);
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
            make.top.equalTo(self.goodsImageView.mas_top).with.offset(1);
            if (self.cellType == THNGoodsInfoCellTypeCartWish) {
                make.right.mas_equalTo(-90);
            } else {
                make.right.equalTo(self.countLabel.mas_left).with.offset(-10);
            }
            make.height.mas_equalTo([self thn_getTitleHeight]);
        }];
    }
    
    // 价格在标题下边
    if (self.cellType == THNGoodsInfoCellTypeCartWish) {
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.priceW);
            make.height.mas_equalTo(15);
            make.left.equalTo(self.titleLabel.mas_left).with.offset(0);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        }];
        
        [self.addCart mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(52, 25));
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self);
        }];
        
        // 下架提示信息在左边
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 12));
            make.left.equalTo(self.titleLabel.mas_left).with.offset(0);
            make.top.equalTo(self.priceLabel.mas_bottom).with.offset(10);
        }];
    }
    
    // 颜色
    [self.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(7);
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
        make.right.mas_equalTo(-130);
        make.height.mas_equalTo(15);
    }];
    
    // 编辑数量
    [self.editCountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 24));
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
    }];
    
    [self.subCountButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 24));
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.editCountView);
    }];
    
    [self.addCountButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 24));
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.editCountView);
    }];
    
    [self.editCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subCountButton.mas_right).with.offset(-4);
        make.right.equalTo(self.addCountButton.mas_left).with.offset(4);
        make.centerY.mas_equalTo(self.editCountView);
        make.height.mas_equalTo(24);
    }];
    
    // 重选规格
    [self.resetSkuButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 24));
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.tagLabel drawCornerWithType:(UILayoutCornerRadiusAll) radius:2];
}

- (void)drawRect:(CGRect)rect {
    if (!self.showLine) return;
    
    [UIView drawRectLineStart:CGPointMake(15, CGRectGetHeight(self.bounds) - 1)
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - setup UI
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.masksToBounds = YES;
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
        _countLabel.textAlignment = NSTextAlignmentRight;
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

- (YYLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[YYLabel alloc] init];
        _tagLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = [UIFont systemFontOfSize:10];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
        _tagLabel.hidden = YES;
    }
    return _tagLabel;
}

- (YYLabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[YYLabel alloc] init];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _statusLabel.font = [UIFont systemFontOfSize:11];
        _statusLabel.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}

- (UIButton *)addCart {
    if (!_addCart) {
        _addCart = [[UIButton alloc] init];
        _addCart.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _addCart.layer.cornerRadius = 4;
        [_addCart setImage:[UIImage imageNamed:@"icon_cart_white"] forState:(UIControlStateNormal)];
        [_addCart setImageEdgeInsets:(UIEdgeInsetsMake(0, 3, 0, 0))];
        [_addCart setTitle:@"＋" forState:(UIControlStateNormal)];
        [_addCart setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_addCart setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        [_addCart addTarget:self action:@selector(addCartAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addCart;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_none"] forState:(UIControlStateNormal)];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_main"] forState:(UIControlStateSelected)];
        _selectButton.imageView.contentMode = UIViewContentModeCenter;
        _selectButton.selected = NO;
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectButton;
}

#pragma mark 编辑数量视图
- (UIView *)editCountView {
    if (!_editCountView) {
        _editCountView = [[UIView alloc] init];
        _editCountView.backgroundColor = [UIColor whiteColor];
        _editCountView.hidden = YES;
    }
    return _editCountView;
}

- (UIButton *)addCountButton {
    if (!_addCountButton) {
        _addCountButton = [[UIButton alloc] init];
        [_addCountButton setTitle:@"+" forState:(UIControlStateNormal)];
        [_addCountButton setTitleColor:[UIColor colorWithHexString:@"#949EA6"] forState:(UIControlStateNormal)];
        [_addCountButton setTitleEdgeInsets:(UIEdgeInsetsMake(-2, 5, 0, 0))];
        _addCountButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:(UIFontWeightLight)];
        _addCountButton.layer.borderWidth = 0.5;
        _addCountButton.layer.borderColor = [UIColor colorWithHexString:@"#D5D5D6"].CGColor;
        _addCountButton.layer.cornerRadius = 4;
        [_addCountButton addTarget:self action:@selector(addCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addCountButton;
}

- (UIButton *)subCountButton {
    if (!_subCountButton) {
        _subCountButton = [[UIButton alloc] init];
        [_subCountButton setTitle:@"−" forState:(UIControlStateNormal)];
        [_subCountButton setTitleColor:[UIColor colorWithHexString:@"#949EA6"] forState:(UIControlStateNormal)];
        [_subCountButton setTitleEdgeInsets:(UIEdgeInsetsMake(-2, -5, 0, 0))];
        _subCountButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:(UIFontWeightLight)];
        _subCountButton.layer.borderWidth = 0.5;
        _subCountButton.layer.borderColor = [UIColor colorWithHexString:@"#D5D5D6"].CGColor;
        _subCountButton.layer.cornerRadius = 4;
        [_subCountButton addTarget:self action:@selector(subCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _subCountButton;
}

- (UILabel *)editCountLabel {
    if (!_editCountLabel) {
        _editCountLabel = [[UILabel alloc] init];
        _editCountLabel.font = [UIFont systemFontOfSize:12];
        _editCountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _editCountLabel.textAlignment = NSTextAlignmentCenter;
        _editCountLabel.layer.borderWidth = 0.5;
        _editCountLabel.layer.borderColor = [UIColor colorWithHexString:@"#D5D5D6"].CGColor;
        _editCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _editCountLabel;
}

- (UIButton *)resetSkuButton {
    if (!_resetSkuButton) {
        _resetSkuButton = [[UIButton alloc] init];
        [_resetSkuButton setTitle:kTextResetSku forState:(UIControlStateNormal)];
        [_resetSkuButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _resetSkuButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightLight)];
        _resetSkuButton.layer.borderWidth = 1;
        _resetSkuButton.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _resetSkuButton.layer.cornerRadius = 4;
        _resetSkuButton.backgroundColor = [UIColor whiteColor];
        _resetSkuButton.hidden = YES;
        [_resetSkuButton addTarget:self action:@selector(resetSkuButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _resetSkuButton;
}

@end
