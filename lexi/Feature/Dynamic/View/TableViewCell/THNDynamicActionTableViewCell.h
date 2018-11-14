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

@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) THNDynamicModelLines *dynamicModel;
@property (nonatomic, copy) NSString *dynamicRid;

- (void)thn_setDynamicAcitonWithModel:(THNDynamicModelLines *)model;

+ (instancetype)initDynamicActionCellWithTableView:(UITableView *)tableView;

@end
