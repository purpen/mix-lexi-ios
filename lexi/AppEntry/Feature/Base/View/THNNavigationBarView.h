//
//  THNNavigationBarView.h
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNNavigationBarViewDelegate <NSObject>

@optional
/// 点击返回按钮
- (void)didNavigationBackButtonEvent;
/// 点击关闭按钮
- (void)didNavigationCloseButtonEvent;
/// 点击右边的功能按钮
- (void)didNavigationRightButtonOfIndex:(NSInteger)index;

@end

typedef void (^THNNavigationBarLeftButtonCompletion)(void);
typedef void (^THNNavigationBarRightButtonCompletion)(void);

@interface THNNavigationBarView : UIView

/**
 导航栏标题
 */
@property (nonatomic, copy) NSString *title;

/**
 是否透明
 */
@property (nonatomic, assign) BOOL transparent;

/**
 代理
 */
@property (nonatomic, weak) id <THNNavigationBarViewDelegate> delegate;

#pragma mark - Set Methods
/// 设置导航栏透明，显示阴影遮罩
- (void)setNavigationTransparent:(BOOL)transparent showShadow:(BOOL)show;

/// 设置页面标题属性
- (void)setNavigationTitleHidden:(BOOL)hidden;
- (void)setNavigationTitle:(NSString *)title;
- (void)setNavigationTitle:(NSString *)title fontSize:(CGFloat)size;
- (void)setNavigationTitle:(NSString *)title textHexColor:(NSString *)hexColor;
- (void)setNavigationTitle:(NSString *)title textHexColor:(NSString *)hexColor fontSize:(CGFloat)size;

/// 设置左边按钮
- (void)setNavigationLeftButtonOfImageNamed:(NSString *)imageName;
- (void)setNavigationLeftButtonOfText:(NSString *)text;
- (void)setNavigationLeftButtonOfText:(NSString *)text fontSize:(CGFloat)size;
- (void)setNavigationLeftButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor;
- (void)setNavigationLeftButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor fontSize:(CGFloat)size;
- (void)didNavigationLeftButtonCompletion:(nullable THNNavigationBarLeftButtonCompletion)completion;

/// 设置右边按钮
- (void)setNavigationRightButtonOfImageNamed:(NSString *)imageName;
- (void)setNavigationRightButtonOfImageNamedArray:(NSArray *)imageNames;
- (void)setNavigationRightButtonOfText:(NSString *)text;
- (void)setNavigationRightButtonOfText:(NSString *)text fontSize:(CGFloat)size;
- (void)setNavigationRightButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor;
- (void)setNavigationRightButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor fontSize:(CGFloat)size;
- (void)didNavigationRightButtonCompletion:(nullable THNNavigationBarRightButtonCompletion)completion;

/// 设置返回按钮
- (void)setNavigationBackButton;
- (void)setNavigationBackButtonHidden:(BOOL)hidden;

/// 设置关闭按钮
- (void)setNavigationCloseButton;
- (void)setNavigationCloseButtonHidden:(BOOL)hidden;

@end
