//
//  THNGoodsActionTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

@interface THNGoodsActionTableViewCell : THNGoodsBaseTableViewCell

@property (nonatomic, weak) UIViewController *currentController;

/**
 设置商品操作的状态

 @param model 商品数据
 @param putaway 是否可以上架
 */
- (void)thn_setActionButtonWithGoodsModel:(THNGoodsModel *)model canPutaway:(BOOL)putaway;

@end
