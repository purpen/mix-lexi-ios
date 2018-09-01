//
//  THNGoodsBaseTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsTableViewCells.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "UIImageView+SDWedImage.h"
#import "THNConst.h"

@interface THNGoodsBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) THNGoodsTableViewCells *baseCell;
@property (nonatomic, weak) UITableView *tableView;

- (void)setupCellViewUI;
+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView;
+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style;

@end
