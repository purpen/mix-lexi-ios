//
//  THNSignUpView.h
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLoginBaseView.h"

@protocol THNSignUpViewDelegate <NSObject>

@required
- (void)thn_signUpSetPasswordWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode verifyCode:(NSString *)code;
- (void)thn_signUpSendAuthCodeWithPhoneNum:(NSString *)phoneNum zipCode:(NSString *)zipCode;
- (void)thn_signUpShowZipCodeList;
- (void)thn_signUpDirectLogin;
- (void)thn_signUpCheckProtocolUrl:(NSString *)url;

@end

@interface THNSignUpView : THNLoginBaseView

@property (nonatomic, weak) id <THNSignUpViewDelegate> delegate;

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
