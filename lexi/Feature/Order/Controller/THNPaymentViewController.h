//
//  THNPaymentViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@class THNWxPayModel;
@class THNOrderDetailModel;

@interface THNPaymentViewController : THNBaseViewController

@property (nonatomic, strong) THNOrderDetailModel *detailModel;
@property (nonatomic, strong) THNWxPayModel *payModel;
// 订单ID
@property (nonatomic, strong) NSString *orderRid;

@end
