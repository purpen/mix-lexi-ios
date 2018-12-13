//
//  THNCashAlipayView.h
//  lexi
//
//  Created by FLYang on 2018/12/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCashAlipayViewDelegate <NSObject>

@optional
/**
 提现到支付宝

 @param amount 提现金额
 @param account 支付宝账号
 @param name 支付宝姓名
 */
- (void)thn_cashAlipayAmount:(CGFloat)amount account:(NSString *)account name:(NSString *)name;

@end

@interface THNCashAlipayView : UIView

@property (nonatomic, weak) id <THNCashAlipayViewDelegate> delegate;

/**
 可提现的金额
 */
- (void)thn_setCanCashAmount:(CGFloat)amount;

@end
