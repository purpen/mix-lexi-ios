//
//  THNTableViewCells.m
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNTableViewCells.h"

@implementation THNTableViewCells

+ (instancetype)initWithCellType:(THNTableViewCellType)type didSelectedItem:(void (^)(NSString *))completion {
    THNTableViewCells *cells = [[THNTableViewCells alloc] init];
    cells.cellType = type;
    cells.selectedCellBlock = completion;
    
    return cells;
}

+ (instancetype)initWithCellType:(THNTableViewCellType)type didSelectedWindow:(THNSelectedWindowBlock)completion {
    THNTableViewCells *cells = [[THNTableViewCells alloc] init];
    cells.cellType = type;
    cells.selectedWindowBlock = completion;
    
    return cells;
}

+ (instancetype)initWithCellType:(THNTableViewCellType)type cellHeight:(CGFloat)height didSelectedItem:(THNSelectedCellBlock)completion {
    THNTableViewCells *cells = [[THNTableViewCells alloc] init];
    cells.cellType = type;
    cells.height = height;
    cells.selectedCellBlock = completion;
    
    return cells;
}

- (NSArray *)goodsDataArr {
    return _goodsDataArr ? _goodsDataArr : [NSArray array];
}

- (NSArray *)windowDataArr {
    return _windowDataArr ? _windowDataArr : [NSArray array];
}

- (THNStoreModel *)storeModel {
    return _storeModel ? _storeModel : [THNStoreModel new];
}

- (CGFloat)height {
    return _height ? _height : 88.0;
}

@end
