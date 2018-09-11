//
//  THNSelectLogisticsTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNFreightModelItem.h"

@interface THNSelectLogisticsTableViewCell : UITableViewCell

- (void)thn_setLogisticsDataWithModel:(THNFreightModelItem *)model;

+ (instancetype)initSelectLogisticsCellWithTableView:(UITableView *)tableView;

@end
