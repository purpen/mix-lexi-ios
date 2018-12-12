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
- (void)thn_signInWithParam:(NSDictionary *)param loginModeType:(THNLoginModeType)type;
- (void)thn_signInSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode;
- (void)thn_signInShowZipCodeList;
- (void)thn_signInForgetPassword;
- (void)thn_signInToRegister;
- (void)thn_signInUseWechatLogin;

@end

@interface THNSignInView : THNLoginBaseView

@property (nonatomic, weak) id <THNSignInViewDelegate> delegate;

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
