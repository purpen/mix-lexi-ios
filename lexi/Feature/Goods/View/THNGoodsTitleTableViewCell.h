//
//  THNGoodsTitleTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "THNGoodsTableViewCells.h"

@interface THNGoodsTitleTableViewCell : UITableViewCell

/// 商品标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) THNGoodsTableViewCells *baseCell;
@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setGoodsTitleWithModel:(THNGoodsModel *)model;

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView;
+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style;

@end
