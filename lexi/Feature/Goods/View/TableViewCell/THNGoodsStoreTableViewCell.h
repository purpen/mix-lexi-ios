//
//  THNGoodsStoreTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

@interface THNGoodsStoreTableViewCell : THNGoodsBaseTableViewCell

/**
 商品所在的店铺信息
 */
- (void)thn_setGoodsStoreInfoWithModel:(THNStoreModel *)model;

@end
