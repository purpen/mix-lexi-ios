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
#import "THNSkuFilter.h"
#import "THNGoodsSkuCollectionViewCell.h"

static NSString *const kGoodsSkuCollectionViewCellId = @"kGoodsSkuCollectionViewCellId";
///
static NSString *const kTitleColor   = @"颜色";
static NSString *const kTitleSize    = @"尺寸";
static NSString *const kTextInterval = @"¢";
///
static CGFloat const kMaxHeight = 337.0;

@interface THNGoodsSkuView () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    THNSkuFilterDataSource
>

/// 商品标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, assign) CGFloat titleH;
/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 滚动容器
@property (nonatomic, strong) UIScrollView *contentView;
/// sku 列表
@property (nonatomic, strong) UICollectionView *skuCollectionView;
@property (nonatomic, strong) NSMutableArray *skuArr;
@property (nonatomic, strong) NSMutableArray *modeArr;
/// 颜色列表
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, assign) CGFloat colorHeight;
/// 尺寸列表
@property (nonatomic, assign) CGFloat sizeHeight;
@property (nonatomic, strong) UILabel *sizeLabel;
/// sku 筛选器
@property (nonatomic, strong) THNSkuFilter *skuFilter;

@end

@implementation THNGoodsSkuView

- (instancetype)initWithFrame:(CGRect)frame skuModel:(THNSkuModel *)skuModel goodsModel:(THNGoodsModel *)goodsModel {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        self.skuModel = skuModel ? skuModel : nil;
        [self thn_setTitleText:goodsModel];
    }
    return self;
}

- (instancetype)initWithSkuModel:(THNSkuModel *)skuModel goodsModel:(THNGoodsModel *)goodsModel {
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300)
                      skuModel:skuModel
                    goodsModel:goodsModel];
}

- (void)setSkuModel:(THNSkuModel *)skuModel {
    _skuModel = skuModel;
    
    [self thn_setGoodsSkuModel:skuModel];
    [self.skuCollectionView reloadData];
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)thn_getSelectedSkuItem {
    if (!self.skuFilter.currentResult) {
        self.selectSkuItem = nil;
        return;
    };
    
    NSInteger skuIndex = [self.skuArr indexOfObject:self.skuFilter.currentResult];
    THNSkuModelItem *item = self.skuModel.items[skuIndex];
    [self thn_setPriceTextWithValue:item.salePrice > 0 ? item.salePrice : item.price];
    
    self.selectSkuItem = item;
}

/**
 设置 SKU
 */
- (void)thn_setGoodsSkuModel:(THNSkuModel *)model {
    if (!model.items.count) {
        return;
    }
    
    THNSkuModelItem *itemModel = model.items[0];
    [self thn_setPriceTextWithValue:itemModel.salePrice > 0 ? itemModel.salePrice : itemModel.price];
    [self thn_getSkuWithModelData:model.items];
    [self.modeArr removeAllObjects];
    
    if (model.colors.count) {
        self.colorLabel.hidden = NO;
        [self thn_getModeContentTextWithModelData:model.colors];
        self.colorHeight = [self thn_getModeContentHeightWithModelData:model.colors];
    }
    
    if (model.modes.count) {
        self.sizeLabel.hidden = NO;
        [self thn_getModeContentTextWithModelData:model.modes];
        self.sizeHeight = [self thn_getModeContentHeightWithModelData:model.modes];
    }
    
    // 没有颜色、尺寸，不选择SKU，可直接购买
    if (!model.colors.count && !model.modes.count) {
        self.selectSkuItem = itemModel;
        return;
    }
    
    // 默认选中
    [self.skuFilter thn_didSelectedModeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self thn_getSelectedSkuItem];
}

/**
 获取可组合搭配的 SKU
 */
- (void)thn_getSkuWithModelData:(NSArray *)data {
    [self.skuArr removeAllObjects];
    
    for (THNSkuModelItem *itemModel in data) {
        [self.skuArr addObject:[NSString stringWithFormat:@"%@%@%@", itemModel.sColor, kTextInterval, itemModel.sModel]];
    }
}

/**
 获取型号的内容
 */
- (void)thn_getModeContentTextWithModelData:(NSArray *)data {
    NSMutableArray *contentArr = [NSMutableArray array];
    for (THNSkuModelColor *model in data) {
        [contentArr addObject:model.name];
    }
    
    [self.modeArr addObject:contentArr];
}

/**
 设置商品标题
 */
- (void)thn_setTitleText:(THNGoodsModel *)model {
    if (!model.name) return;
    
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
 所有型号内容的高度
 */
- (CGFloat)thn_getModeContentHeightWithModelData:(NSArray *)data {
    CGFloat contentW = 0;
    
    for (THNSkuModelColor *model in data) {
        CGFloat nameW = [model.name boundingSizeWidthWithFontSize:12] + 22;
        contentW += nameW;
    }
    
    CGFloat contentH = 34.0;
    CGFloat lineNum = ceil(contentW) / (SCREEN_WIDTH - 73);
    
    return contentH * ceil(lineNum) + 15;
}


#pragma mark - sku filter datasource
- (NSInteger)thn_numberOfSectionsForModeInFilter:(THNSkuFilter *)filter {
    return self.modeArr.count;
}

- (NSArray *)thn_filter:(THNSkuFilter *)filter modesInSection:(NSInteger)section {
    return self.modeArr[section];
}

- (NSInteger)thn_numberOfConditionsInFilter:(THNSkuFilter *)filter {
    return self.skuArr.count;
}

- (NSArray *)thn_filter:(THNSkuFilter *)filter conditionForRow:(NSInteger)row {
    NSMutableArray *skus = [NSMutableArray arrayWithArray:[self.skuArr[row] componentsSeparatedByString:kTextInterval]];

    [skus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![(NSString *)obj length]) {
            [skus removeObject:obj];
        }
    }];
    
    return [skus copy];
}

- (id)thn_filter:(THNSkuFilter *)filter resultOfConditionForRow:(NSInteger)row {
    return self.skuArr[row];
}

#pragma mark - collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.modeArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modeArr[section] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data = (NSArray *)self.modeArr[indexPath.section];
    
    return CGSizeMake([data[indexPath.row] boundingSizeWidthWithFontSize:12] + 12, 24);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGoodsSkuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsSkuCollectionViewCellId
                                                                                    forIndexPath:indexPath];
    
    NSArray *data = (NSArray *)self.modeArr[indexPath.section];
    cell.modeName = data[indexPath.row];
    
    if ([self.skuFilter.availableIndexPathsSet containsObject:indexPath]) {
        cell.cellType = THNGoodsSkuCellTypeNormal;
        
    } else {
        cell.cellType = THNGoodsSkuCellTypeDisable;
    }
    
    if ([self.skuFilter.selectedIndexPaths containsObject:indexPath]) {
        cell.cellType = THNGoodsSkuCellTypeSelected;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.skuFilter thn_didSelectedModeWithIndexPath:indexPath];
    [collectionView reloadData];
    
    [self thn_getSelectedSkuItem];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.colorLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.skuCollectionView];
}

- (void)updateConstraints {
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [self thn_getSkuViewSizeHeight]));
        make.left.bottom.mas_equalTo(0);
    }];
    
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
    
    [self.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 24));
    }];
    
    [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.colorHeight > 0 ? self.colorHeight + 6 : 15);
        make.size.mas_equalTo(CGSizeMake(40, 24));
    }];
    
    [self.skuCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 73, [self thn_getContentSizeHeight]));
    }];
    
    [super updateConstraints];
}

- (CGFloat)thn_getContentSizeHeight {
//    CGFloat modeH = self.modeArr.count * 15;
    
    return self.colorHeight + self.sizeHeight + 25;
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

- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] init];
        _colorLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightLight)];
        _colorLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _colorLabel.text = kTitleColor;
        _colorLabel.hidden = YES;
    }
    return _colorLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightLight)];
        _sizeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _sizeLabel.text = kTitleSize;
        _sizeLabel.hidden = YES;
    }
    return _sizeLabel;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UICollectionView *)skuCollectionView {
    if (!_skuCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _skuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _skuCollectionView.delegate = self;
        _skuCollectionView.dataSource = self;
        _skuCollectionView.showsVerticalScrollIndicator = NO;
        _skuCollectionView.scrollEnabled = NO;
        _skuCollectionView.backgroundColor = [UIColor whiteColor];
        [_skuCollectionView registerClass:[THNGoodsSkuCollectionViewCell class] forCellWithReuseIdentifier:kGoodsSkuCollectionViewCellId];
    }
    return _skuCollectionView;
}

- (NSMutableArray *)skuArr {
    if (!_skuArr) {
        _skuArr = [NSMutableArray array];
    }
    return _skuArr;
}

- (NSMutableArray *)modeArr {
    if (!_modeArr) {
        _modeArr = [NSMutableArray array];
    }
    return _modeArr;
}

- (THNSkuFilter *)skuFilter {
    if (!_skuFilter) {
        _skuFilter = [[THNSkuFilter alloc] initWithDataSource:self];
    }
    return _skuFilter;
}

@end
