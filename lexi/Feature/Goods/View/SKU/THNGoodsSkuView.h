//
//  THNGoodsSkuView.h
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"
#import "THNSkuModel.h"
#import "THNGoodsModel.h"

@interface THNGoodsSkuView : UIView

/**
 商品 id
 */
@property (nonatomic, copy) NSString *goodsId;

/**
 sku 信息
 */
@property (nonatomic, strong) THNSkuModel *skuModel;

/**
 选择的 SKU 结果
 */
@property (nonatomic, strong) THNSkuModelItem *selectSkuItem;

- (instancetype)initWithSkuModel:(THNSkuModel *)skuModel goodsModel:(THNGoodsModel *)goodsModel;
- (instancetype)initWithFrame:(CGRect)frame skuModel:(THNSkuModel *)skuModel goodsModel:(THNGoodsModel *)goodsModel;

@end
