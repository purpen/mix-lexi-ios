//
//  THNLifeCashBillDetailViewController.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNLifeCashBillOrderModel.h"

@interface THNLifeCashBillDetailViewController : THNBaseViewController

// 收益记录ID
- (instancetype)initWithRid:(NSString *)rid detailModel:(THNLifeCashBillOrderModel *)model;

@end
