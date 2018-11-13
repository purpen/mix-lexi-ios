//
//  THNDynamicActionTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNDynamicModelLines.h"

@interface THNDynamicActionTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setDynamicAcitonWithModel:(THNDynamicModelLines *)model;

+ (instancetype)initDynamicActionCellWithTableView:(UITableView *)tableView;

@end
