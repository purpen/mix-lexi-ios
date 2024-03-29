//
//  THNOrderDetailModel.h
//  lexi
//
//  Created by HongpingRao on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THNPayManger.h"

@class THNOrdersItemsModel;
@class THNOrderStoreModel;

@interface THNOrderDetailModel : NSObject

@property (nonatomic, strong) NSString *buyer_address;
@property (nonatomic, strong) NSString *buyer_city;
@property (nonatomic, strong) NSString *buyer_country;
@property (nonatomic, strong) NSString *buyer_name;
@property (nonatomic, strong) NSString *buyer_province;
@property (nonatomic, strong) NSString *buyer_phone;
// 邮编
@property (nonatomic, strong) NSString *buyer_zipcode;
@property (nonatomic, strong) NSString *buyer_remark; // 买家备注
@property (nonatomic, assign) CGFloat freight; //运费
@property (nonatomic, strong) NSString *outside_target_id; // 订单编号
@property (nonatomic, assign) CGFloat user_pay_amount; // 支付金额
@property (nonatomic, assign) CGFloat total_amount; // 小计
@property (nonatomic, strong) NSArray <THNOrdersItemsModel*> *items;
@property (nonatomic, strong) THNOrderStoreModel *store;
// 优惠券金额
@property (nonatomic , assign) CGFloat coupon_amount;
// 官方优惠券金额
@property (nonatomic , assign) CGFloat bonus_amount;
// 首单优惠
@property (nonatomic , assign) CGFloat first_discount;
// 满减金额
@property (nonatomic , assign) CGFloat reach_minus;
// 订单状态  // 1、待发货 2、待收货 3、待评价 4、待付款 5、已完成 6、已取消
@property (nonatomic, assign) NSInteger user_order_status;
// 支付方式
@property (nonatomic, assign) THNPaymentType pay_type;
// 订单创建时间
@property (nonatomic, strong) NSString *created_at;


@end
