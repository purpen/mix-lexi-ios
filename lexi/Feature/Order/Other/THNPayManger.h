//
//  THNPayManger.h
//  lexi
//
//  Created by HongpingRao on 2018/11/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 哪里调起的支付

 - FromPaymentTypePreViewVC: 支付界面
 - FromPaymentTypeOrderVC: 订单界面
 */
typedef NS_ENUM(NSUInteger, FromPaymentType) {
    FromPaymentTypePaymentVC,
    FromPaymentTypeOrderVC
};

typedef NS_ENUM(NSInteger, THNPaymentType) {
    THNPaymentTypeWechat = 1,   // 微信支付
    THNPaymentTypeAlipay,       // 支付宝
    THNPaymentTypeHuabei = 4,       // 花呗
};

@interface THNPayManger : NSObject

/**
 第三方支付
 */
- (void)loadThirdPayParamsWithRid:(NSString *)rid
              withFromPaymentType:(FromPaymentType)fromPaymentType
                  withPaymentType:(THNPaymentType)paymentType;

+ (instancetype)sharedManager;

@end
