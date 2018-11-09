//
//  THNAddressTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNAddressModel.h"
@class THNAddressTableViewCell;

typedef NS_ENUM(NSUInteger, THNAddressCellType) {
    THNAddressCellTypeSelect = 0,  // 可选择
    THNAddressCellTypeNormal,
};

@protocol THNAddressTableViewCellDelegate <NSObject>

@optional
- (void)thn_didSelectedAddressCell:(THNAddressTableViewCell *)cell;

@end

@interface THNAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) THNAddressModel *model;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) THNAddressCellType type;
@property (nonatomic, weak) id <THNAddressTableViewCellDelegate> delegate;

+ (instancetype)initAddressCellWithTableView:(UITableView *)tableView type:(THNAddressCellType)type;

@end
