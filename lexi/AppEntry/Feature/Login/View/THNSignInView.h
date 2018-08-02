//
//  THNSignInView.h
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLoginBaseView.h"
#import "THNLoginManager.h"

@protocol THNSignInViewDelegate <NSObject>

@required
/**
 去设置密码
 
 @param param 请求参数
 @param type 登录方式
 */
- (void)thn_signInWithParam:(NSDictionary *)param loginModeType:(THNLoginModeType)type;

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

/**
 忘记密码
 */
- (void)thn_forgetPassword;

/**
 去注册
 */
- (void)thn_goToRegister;

@end

@interface THNSignInView : THNLoginBaseView

@property (nonatomic, weak) id <THNSignInViewDelegate> delegate;

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
