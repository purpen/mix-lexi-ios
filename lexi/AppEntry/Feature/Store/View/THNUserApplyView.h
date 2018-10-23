//
//  THNUserApplyView.h
//  lexi
//
//  Created by FLYang on 2018/8/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNUserApplyViewDelegate <NSObject>

@required
/**
 开通生活馆
 
 @param param 请求参数
 */
- (void)thn_applyLifeStoreWithParam:(NSDictionary *)param;

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

@interface THNUserApplyView : UIView

@property (nonatomic, weak) id <THNUserApplyViewDelegate> delegate;

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
