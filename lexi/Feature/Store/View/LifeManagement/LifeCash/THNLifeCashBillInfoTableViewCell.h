//
//  THNLifeCashBillInfoTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLifeCashBillOrderModel.h"

@interface THNLifeCashBillInfoTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showDetail;

- (void)thn_setLifeCashBillOrderData:(THNLifeCashBillOrderModel *)model;

@end
