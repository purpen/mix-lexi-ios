//
//  THNAddressTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNAddressModel.h"

typedef void(^SelectedCellCompleted)(void);

@interface THNAddressTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) SelectedCellCompleted selectedCellCompleted;

- (void)thn_setAddressModel:(THNAddressModel *)model;

+ (instancetype)initAddressCellWithTableView:(UITableView *)tableView;

@end
