//
//  THNFindPassword.h
//  lexi
//
//  Created by FLYang on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"


@protocol THNFindPasswordDelegate <NSObject>

@required
/**
 去设置密码
 
 @param phoneNum 手机号
 @param zipCode 手机区号
 @param code 短信验证码
 */
- (void)thn_setPasswordWithPhoneNum:(NSString *)phoneNum
                            zipCode:(NSString *)zipCode
                         verifyCode:(NSString *)code;

/**
 发送验证码
 
 @param phoneNum 手机号
 @param zipCode 手机区号
 */
- (void)thn_sendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode;

/**
 打开区号列表
 */
- (void)thn_showZipCodeList;

@end


@interface THNFindPassword : THNLoginBaseView

@property (nonatomic, weak) id <THNFindPasswordDelegate> delegate;

/**
 设置验证码
 
 @param code 验证码
 */
- (void)thn_setVerifyCode:(NSString *)code;

/**
 设置区号
 
 @param code 区号
 */
- (void)thn_setAreaCode:(NSString *)code;

/**
 设置错误提示
 
 @param text 提示文字
 */
- (void)thn_setErrorHintText:(NSString *)text;

@end