//
//  THNFollowStoreTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNTableViewCells.h"
#import "THNStoreModel.h"
#import "THNFollowStoreButton.h"

@interface THNFollowStoreTableViewCell : UITableViewCell

@property (nonatomic, strong) THNTableViewCells *cell;
@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setStoreData:(THNStoreModel *)model;
+ (instancetype)initStoreCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style;

@end
