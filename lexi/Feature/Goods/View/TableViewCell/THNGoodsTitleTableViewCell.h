//
//  THNGoodsTitleTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"
#import <YYKit/YYKit.h>

@interface THNGoodsTitleTableViewCell : THNGoodsBaseTableViewCell

/// 商品标题
@property (nonatomic, strong) YYLabel *titleLabel;

- (void)thn_setGoodsTitleWithModel:(THNGoodsModel *)model;

@end
