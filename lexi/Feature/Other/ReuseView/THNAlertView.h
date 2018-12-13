//
//  THNAlertView.h
//  lexi
//
//  Created by FLYang on 2018/10/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNAlertViewStyle) {
    THNAlertViewStyleAlert = 0,     // 默认弹出样式
    THNAlertViewStyleActionSheet
};

typedef void (^ActionButtonHandler)(UIButton *actionButton, NSInteger index);

@interface THNAlertView : UIView

/**
 默认高亮操作按钮的颜色
 */
@property (nonatomic, strong) UIColor *mainActionColor;
@property (nonatomic, strong) UIColor *mainTitleColor;

/**
 点击背景视图，使视图消失(默认为 No)
 */
@property (nonatomic, assign) BOOL canClickBackgroundDismiss;

/**
 弹出视图的样式
 */
@property (nonatomic, assign) THNAlertViewStyle alertViewStyle;

/**
 操作按钮点击
 */
@property (nonatomic, copy) ActionButtonHandler actionButtonHandler;

/**
 创建按钮

 @param title 按钮标题
 @param handler 点击操作
 */
- (void)addActionButtonWithTitle:(NSString *)title handler:(ActionButtonHandler)handler;

/**
 创建多个按钮

 @param titles 按钮标题
 @param handler 点击操作
 */
- (void)addActionButtonWithTitles:(NSArray *)titles handler:(ActionButtonHandler)handler;
- (void)addActionButtonWithTitles:(NSArray *)titles style:(THNAlertViewStyle)style handler:(ActionButtonHandler)handler;

/**
 展示/消失视图
 */
- (void)show;
- (void)dismiss;

+ (instancetype)initAlertViewTitle:(NSString *)title message:(NSString *)message;

/**
 显示微信头像视图

 @param image 头像链接
 @param nickname 微信名
 @param title 提示语
 @return self
 */
+ (instancetype)initAlertViewWechatHeadImage:(NSString *)image nickname:(NSString *)nickname title:(NSString *)title;

@end
