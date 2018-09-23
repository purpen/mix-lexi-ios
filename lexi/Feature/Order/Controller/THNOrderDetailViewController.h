//
//  THNOrderDetailViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"


/**
 跳转订单详情的类型

 - PushOrderDetailTypeOrder: 订单跳转
 - PushOrderDetailTypePaySuccess: 支付成功跳转
 */
typedef NS_ENUM(NSUInteger, PushOrderDetailType) {
    PushOrderDetailTypeOrder,
    PushOrderDetailTypePaySuccess
};

@interface THNOrderDetailViewController : THNBaseViewController
// 订单编号
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, assign) PushOrderDetailType pushOrderDetailType;

@end
