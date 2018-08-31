//
//  THNGoodsTagTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsTableViewCells.h"

@interface THNGoodsTagTableViewCell : UITableViewCell

@property (nonatomic, strong) THNGoodsTableViewCells *baseCell;
@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setGoodsTagWithTags:(NSArray *)tags;

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView;
+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style;

@end
