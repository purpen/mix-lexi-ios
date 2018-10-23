//
//  THNGoodsHeaderTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, THNGoodsHeaderCellType) {
    THNGoodsHeaderCellTypeDefualt = 0,  // 默认
    THNGoodsHeaderCellTypeSimilar,      // 相似商品
    THNGoodsHeaderCellTypeGoodsInfo,    // 商品详情
};

@interface THNGoodsHeaderTableViewCell : THNGoodsBaseTableViewCell

- (void)thn_setHeaderCellWithText:(NSString *)text;
- (void)thn_setHeaderCellType:(THNGoodsHeaderCellType)type;

@end
