//
//  THNGoodsCheckTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, THNGoodsCheckTableViewCellType) {
    THNGoodsCheckTableViewCellTypeAllDescribe = 0,  // 查看全部
};

@interface THNGoodsCheckTableViewCell : THNGoodsBaseTableViewCell

- (void)thn_setGoodsCheckCellType:(THNGoodsCheckTableViewCellType)type;

@end
