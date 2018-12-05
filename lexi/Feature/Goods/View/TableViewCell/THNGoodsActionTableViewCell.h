//
//  THNGoodsActionTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

@protocol THNGoodsActionTableViewCellDelegate <NSObject>

@optional
- (void)thn_putawayProduct;

@end

@interface THNGoodsActionTableViewCell : THNGoodsBaseTableViewCell

@property (nonatomic, weak) id <THNGoodsActionTableViewCellDelegate> delegate;

@property (nonatomic, strong) THNGoodsModel *goodsModel;

/**
 设置商品操作的状态
 */
- (void)thn_setActionButtonWithGoodsModel:(THNGoodsModel *)model;

@end
