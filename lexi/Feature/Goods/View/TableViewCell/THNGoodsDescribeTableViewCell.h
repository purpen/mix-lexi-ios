//
//  THNGoodsDescribeTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, THNGoodsDescribeCellType) {
    THNGoodsDescribeCellTypeDes = 0,    // 描述
    THNGoodsDescribeCellTypeDispatch,   // 发货地
    THNGoodsDescribeCellTypeTime,       // 交货时间
    THNGoodsDescribeCellTypeSalesReturn // 退换货政策
};

@interface THNGoodsDescribeTableViewCell : THNGoodsBaseTableViewCell

/**
 设置发货时间
 */
- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type freightModel:(THNFreightModel *)model;

/**
 设置商品描述
 */
- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type goodsModel:(THNGoodsModel *)model showIcon:(BOOL)showIcon;

/**
 设置发货地
 */
- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type storeModel:(THNStoreModel *)model;

- (void)thn_hiddenLine;

/**
 设置显示内容
 */
- (void)thn_setDescribeType:(THNGoodsDescribeCellType)type content:(NSString *)content;
- (void)thn_setDescribeTitleText:(NSString *)title content:(NSString *)content;

@end
