//
//  THNWxPayModel.h
//  lexi
//
//  Created by HongpingRao on 2018/10/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNWxPayModel : NSObject

// 微信支付key
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *nonce_str;
@property (nonatomic, strong) NSString *prepay_id;
@property (nonatomic, strong) NSString *sign;
// 商户号
@property (nonatomic, strong) NSString *mch_id;
@property (nonatomic, assign) UInt32 timestamp;

@end
