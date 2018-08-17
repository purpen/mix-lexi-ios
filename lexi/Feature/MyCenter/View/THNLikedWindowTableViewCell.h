//
//  THNLikedWindowTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNTableViewCells.h"

@interface THNLikedWindowTableViewCell : UITableViewCell

@property (nonatomic, strong) THNTableViewCells *cell;
@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setWindowData:(NSDictionary *)data;
+ (instancetype)initWindowCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style;

@end
