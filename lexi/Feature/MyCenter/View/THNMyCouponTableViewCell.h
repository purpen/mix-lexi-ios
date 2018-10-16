//
//  THNMyCouponTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"
#import "THNCouponDataModel.h"
#import "THNCouponModel.h"

@interface THNMyCouponTableViewCell : UITableViewCell

- (void)thn_setMyCouponInfoData:(THNCouponModel *)model;
- (void)thn_setMyBrandCouponInfoData:(THNCouponDataModel *)model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(THNUserCouponType)type;

@end
