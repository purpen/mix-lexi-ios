//
//  THNTableViewController.h
//  lexi
//
//  Created by FLYang on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNTableViewSections.h"
#import "THNTableViewCells.h"
#import "THNGoodsTableViewCells.h"

typedef NS_ENUM(NSUInteger, THNTableViewCellSeparatorStyle) {
    THNTableViewCellSeparatorStyleDefault = 0,  // 默认分隔线
    THNTableViewCellSeparatorStyleNone,         // 没有分隔线
    THNTableViewCellSeparatorStyleFull,         // cell 宽度的分隔线
    THNTableViewCellSeparatorStyleMargin        // 左边带间距
};

@interface THNBaseTableViewController : THNBaseViewController <
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

/**
 分割线样式
 */
@property (nonatomic, assign) THNTableViewCellSeparatorStyle separatorStyle;

/**
 组
 */
@property (nonatomic, strong) NSMutableArray *dataSections;

/**
 对显示的组重新排序
 */
- (void)thn_sortDataSecitons;

@end
