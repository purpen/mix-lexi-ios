//
//  THNPayManger.m
//  lexi
//
//  Created by HongpingRao on 2018/11/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPayManger.h"
#import "THNAPI.h"
#import "SVProgressHUD+Helper.h"
#import "THNPayModel.h"
#import <MJExtension/MJExtension.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "THNConst.h"

static NSString *kUrlCreateOrderWXPay = @"/orders/app_pay";
static NSString *kUrlOrderWXPay = @"/orders/wx_pay/app";

@implementation THNPayManger

- (void)loadThirdPayParamsWithRid:(NSString *)rid
                      withFromPaymentType:(FromPaymentType)fromPaymentType
                          withPaymentType:(THNPaymentType)paymentType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    params[@"pay_type"] = paymentType == THNPaymentTypeHuabei ?  @(4) : @(paymentType);
    NSString *requestUrl = fromPaymentType == FromPaymentTypePaymentVC ?  kUrlCreateOrderWXPay : kUrlOrderWXPay;
    THNRequest *request = [THNAPI postWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        THNPayModel *payModel = [THNPayModel mj_objectWithKeyValues:result.data];
        switch (paymentType) {
            case THNPaymentTypeWechat:
                if (![WXApi isWXAppInstalled]) {
                    [SVProgressHUD thn_showInfoWithStatus:@"暂无微信客户端"];
                    return;
                } else {
                    [self tuneUpWechatPay:payModel];
                }
                
                break;
            default:
                [self alipay:payModel];
                break;
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 调起微信支付模板
- (void)tuneUpWechatPay:(THNPayModel *)payModel {
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = payModel.mch_id;
    request.prepayId= payModel.prepay_id;
    request.package = @"Sign=WXPay";
    request.nonceStr = payModel.nonce_str;
    request.timeStamp = payModel.timestamp;
    request.sign = payModel.sign;
    [WXApi sendReq:request];
}

// 支付宝支付
- (void)alipay:(THNPayModel *)payModel {
    [[AlipaySDK defaultService] payOrder:payModel.order_string fromScheme:kALiURLScheme callback:^(NSDictionary *resultDic) {
        
    }];
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
