//
//  UIBarButtonItem+Helper.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NormalColor             [UIColor blackColor]    // 文字默认颜色
#define HighlightedColor        [UIColor whiteColor]    // 文字高亮颜色

@interface UIBarButtonItem (Helper)

/**
 设置图片按钮

 @param normal 常规图片
 @param highlighted 高亮图片
 */
- (id)initWithNormalIcon:(NSString *)normal highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
+ (id)itemWithNormalIcon:(NSString *)normal highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

/**
 设置文字按钮，不带背景图片

 @param title 文字
 */
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 设置文字按钮，带背景图片

 @param title 文字
 @param backImage 背景图片
 */
- (id)initWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage target:(id)target action:(SEL)action;

/**
 设置文字按钮，不带背景图片

 @param title 文字
 @param normal 常规颜色
 @param highlighted 高亮颜色
 */
+ (id)itemWithTitle:(NSString *)title normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action;

/**
 设置文字按钮

 @param title 文字
 @param backImage 背景图片
 @param normal 常规颜色
 @param highlighted 高亮颜色
 */
+ (id)itemWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action;

@end
