//
//  THNPaymentTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNPayManger.h"

@interface THNPaymentTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelectedPayment;

- (void)thn_setPaymentTypeWithType:(THNPaymentType)type;

+ (instancetype)initPaymentCellWithTableView:(UITableView *)tableView;

@end
