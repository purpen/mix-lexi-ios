//
//  THNGoodsSkuViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNSkuModel.h"
#import "THNGoodsModel.h"
#import "THNGoodsSkuView.h"

typedef NS_ENUM(NSUInteger, THNGoodsSkuType) {
    THNGoodsSkuTypeDefault = 0,  // 默认（确认按钮）
    THNGoodsSkuTypeDirectSelect  // 直接选择SKU（购物功能按钮）
};

@interface THNGoodsSkuViewController : THNBaseViewController

/**
 sku 视图
 */
@property (nonatomic, strong) THNGoodsSkuView *skuView;

/**
 功能视图类型
 */
@property (nonatomic, assign) THNGoodsFunctionViewType functionType;

- (instancetype)initWithSkuModel:(THNSkuModel *)model goodsModel:(THNGoodsModel *)goodsModel viewType:(THNGoodsSkuType)viewTpye;

@end
