//
//  THNOrdersModel.h
//  mixcash
//
//  Created by HongpingRao on 2018/5/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class THNOrdersItemsModel;
@class THNOrderStoreModel;

typedef NS_ENUM(NSUInteger, OrderStatus) {
    OrderStatusWaitDelivery = 1,
    OrderStatusReceipt,
    OrderStatusEvaluation,
    OrderStatuspayment,
    OrderStatusFinish,
    OrderStatusCancel
};


@interface THNOrdersModel :NSObject


// 订单状态 0、全部 1、待发货 2、待收货 3、待评价 4、待付款
@property (nonatomic , assign) NSInteger status;
// 订单金额
@property (nonatomic , assign) CGFloat pay_amount;
// 订单号
@property (nonatomic , copy) NSString *rid;

@property (nonatomic, strong) THNOrderStoreModel *store;

@property (nonatomic, strong) NSArray <THNOrdersItemsModel*> *items;

// 订单创建时间
@property (nonatomic, strong) NSString *created_at;
// 当前时间
@property (nonatomic, strong) NSString *current_time;
// 1、待发货 2、待收货 3、待评价 4、待付款 5、已完成 6、已取消
@property (nonatomic, assign) OrderStatus user_order_status;

@end


