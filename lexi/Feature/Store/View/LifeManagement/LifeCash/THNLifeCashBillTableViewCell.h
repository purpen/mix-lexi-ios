//
//  THNLifeCashBillTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLifeCashBillDataModel.h"
#import "THNLifeCashBillModel.h"

@interface THNLifeCashBillTableViewCell : UITableViewCell

- (void)thn_setLifeCashRecordData:(NSDictionary *)dict;
- (void)thn_setWinCashRecordData:(NSDictionary *)data;

@end
