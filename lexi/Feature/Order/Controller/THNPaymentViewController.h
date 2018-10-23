//
//  THNPaymentViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@interface THNPaymentViewController : THNBaseViewController

// 商品总价
@property (nonatomic, assign) CGFloat totalPrice;
// 支付金额
@property (nonatomic, assign) CGFloat paymentAmount;
// 总运费
@property (nonatomic, assign) CGFloat totalFreight;

@end
