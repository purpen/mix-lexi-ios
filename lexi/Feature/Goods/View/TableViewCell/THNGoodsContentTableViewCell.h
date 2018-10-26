//
//  THNGoodsContentTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

@interface THNGoodsContentTableViewCell : THNGoodsBaseTableViewCell

/**
 设置商品详情内容
 */
- (void)thn_setContentWithGoodsModel:(THNGoodsModel *)model;

/**
 图文详情内容
 */
- (void)thn_setContentData:(NSArray *)content;

@end
