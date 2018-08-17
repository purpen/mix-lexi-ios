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

- (CGFloat)height {
    return _height ? _height : 88.0;
}

@end
