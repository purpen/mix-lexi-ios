//
//  THNCouponModel.h
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

/**
 展示优惠券的样式
 
 - ShowCouponStyleTypeAmount: 抵扣金额
 - ShowCouponStyleTypeUnavailable: 不可使用
 - ShowCouponStyleTypeNotavailable: 没有可用
 - ShowCouponStyleTypeQuantityAvailable: 可用优惠券数量
 */
typedef NS_ENUM(NSUInteger, ShowCouponStyleType) {
    ShowCouponStyleTypeAmount,
    ShowCouponStyleTypeUnavailable,
    ShowCouponStyleTypeNotavailable,
    ShowCouponStyleTypeQuantityAvailable
};

@interface THNCouponModel : NSObject

// 面值
@property (nonatomic, assign) CGFloat amount;
// 满减金额
@property (nonatomic, assign) CGFloat reach_amount;
// 最小金额
@property (nonatomic, assign) CGFloat min_amount;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSString *start_at;
@property (nonatomic, strong) NSString *expired_at;
// 店铺信息
@property (nonatomic, strong) NSString *store_logo;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *store_rid;
// 是否领取 0、未领取 1、已领取
@property (nonatomic, assign) NSInteger status;
// 来源 1、分享领红包 2、猜图赢现金 3、赠送 4、新人奖励 11、领券中心
@property (nonatomic, assign) NSInteger source;
// 有效天数
@property (nonatomic, strong) NSString *days;
// 描述
@property (nonatomic, strong) NSString *type_text;
// 优惠券code
@property (nonatomic, strong) NSString *code;
/**
 正常类型：1、同享券 2、单享券 3、满减
 失效类型：1、店铺优惠券 2、官方优惠券
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) BOOL is_grant;
@property (nonatomic, assign) NSInteger pickup_count;
@property (nonatomic, assign) NSInteger surplus_count;
@property (nonatomic, assign) NSInteger use_count;

@end
