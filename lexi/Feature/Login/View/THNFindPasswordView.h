//
//  THNFindPasswordView.h
//  lexi
//
//  Created by FLYang on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"

@protocol THNFindPasswordDelegate <NSObject>

@required
- (void)thn_findPwdSetPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code;
- (void)thn_findPwdSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode;
- (void)thn_findPwdShowZipCodeList;

@end


@interface THNFindPasswordView : THNLoginBaseView

@property (nonatomic, weak) id <THNFindPasswordDelegate> delegate;

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
