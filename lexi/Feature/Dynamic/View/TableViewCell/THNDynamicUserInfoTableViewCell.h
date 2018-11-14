//
//  THNDynamicUserInfoTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNDynamicModelLines.h"

typedef void(^UserDynamicActionBlock)(NSString *dynamicRid);

@interface THNDynamicUserInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *dynamicRid;
@property (nonatomic, copy) UserDynamicActionBlock userDynamicActionBlock;

- (void)thn_setDynamicUserInfoWithModel:(THNDynamicModelLines *)model;

+ (instancetype)initDynamicUserInfoCellWithTableView:(UITableView *)tableView;

@end
