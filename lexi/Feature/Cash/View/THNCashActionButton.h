//
//  THNCashActionButton.h
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THNCashActionButton;

typedef NS_ENUM(NSUInteger, THNCashActionButtonType) {
    THNCashActionButtonTypeMoney = 0,   // 显示金额
    THNCashActionButtonTypeMode,        // 提现方式
};

typedef NS_ENUM(NSUInteger, THNCashMode) {
    THNCashModeWechat = 0,  // 微信支付
    THNCashModeAlipay,      // 支付宝
};

@protocol THNCashActionButtonDelegate <NSObject>

@optional
- (void)thn_didSelectedCashActionButton:(THNCashActionButton *)button;

@end

@interface THNCashActionButton : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id <THNCashActionButtonDelegate> delegate;

/**
 显示“极速到账”的角标
 */
- (void)thn_showHintIcon;

/**
 提现金额设置
 */
- (void)thn_showCashMoneyValue:(CGFloat)value;

/**
 提现方式
 */
- (void)thn_showCashMode:(THNCashMode)mode;

- (instancetype)initWithType:(THNCashActionButtonType)type;

@end
