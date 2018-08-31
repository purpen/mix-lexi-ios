//
//  THNGoodsTableViewCells.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsTableViewCells.h"

@implementation THNGoodsTableViewCells

+ (instancetype)initWithCellType:(THNGoodsTableViewCellType)type {
    THNGoodsTableViewCells *cells = [[THNGoodsTableViewCells alloc] init];
    cells.cellType = type;
    
    return cells;
}

+ (instancetype)initWithCellType:(THNGoodsTableViewCellType)type didSelectedItem:(GoodsInfoSelectedCellBlock)completion {
    THNGoodsTableViewCells *cells = [[THNGoodsTableViewCells alloc] init];
    cells.selectedCellBlock = completion;
    cells.cellType = type;
    
    return cells;
}

+ (instancetype)initWithCellType:(THNGoodsTableViewCellType)type
                      cellHeight:(CGFloat)height
                 didSelectedItem:(GoodsInfoSelectedCellBlock)completion {
    
    THNGoodsTableViewCells *cells = [[THNGoodsTableViewCells alloc] init];
    cells.height = height;
    cells.cellType = type;
    cells.selectedCellBlock = completion;
    
    return cells;
}

- (THNGoodsModel *)goodsModel {
    return _goodsModel ? _goodsModel : [THNGoodsModel new];
}

- (NSArray *)tagsArr {
    return _tagsArr ? _tagsArr : [NSArray array];
}

- (CGFloat)height {
    return _height ? _height : 44.0;
}

@end
