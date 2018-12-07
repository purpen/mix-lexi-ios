//
//  THNBindPhoneView.h
//  lexi
//
//  Created by FLYang on 2018/12/7.
//  Copyright © 2018 lexi. All rights reserved.
//

#import "THNLoginBaseView.h"

@protocol THNBindPhoneViewDelegate <NSObject>

@required
- (void)thn_bindPhoneWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code;
- (void)thn_bindSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode;
- (void)thn_bindShowZipCodeList;
- (void)thn_bindCheckProtocolUrl:(NSString *)url;

@end

@interface THNBindPhoneView : THNLoginBaseView

@property (nonatomic, weak) id <THNBindPhoneViewDelegate> delegate;

/**
 设置验证码
 */
- (void)thn_setVerifyCode:(NSString *)code;

/**
 设置区号
 */
- (void)thn_setAreaCode:(NSString *)code;

/**
 设置错误提示
 */
- (void)thn_setErrorHintText:(NSString *)text;

@end
