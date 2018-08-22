//
//  THNLikedGoodsTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNTableViewCells.h"

@interface THNLikedGoodsTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) THNTableViewCells *cell;
@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setLikedGoodsData:(NSArray *)goodsData;

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView
                                 cellStyle:(UITableViewCellStyle)style;

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView
                             initWithStyle:(UITableViewCellStyle)style
                           reuseIdentifier:(NSString *)reuseIdentifier;

@end
