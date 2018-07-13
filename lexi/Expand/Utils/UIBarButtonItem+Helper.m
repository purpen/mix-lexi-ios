//
//  UIBarButtonItem+Helper.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIBarButtonItem+Helper.h"

@implementation UIBarButtonItem (Helper)

#pragma mark - 设置图片按钮,normal:常规图片，highlighted:高亮图片
- (id)initWithNormalIcon:(NSString *)normal highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action {
    UIImage *image = [UIImage imageNamed:normal];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setBackgroundImage:image forState:UIControlStateNormal];
    [customButton setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    customButton.bounds = (CGRect){CGPointZero, image.size};
    [customButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:customButton];
}

+ (id)itemWithNormalIcon:(NSString *)normal highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action {
    return [[self alloc] initWithNormalIcon:normal highlightedIcon:highlighted target:target action:action];
}

#pragma mark - 设置文字按钮，默认文字颜色：高亮颜色：
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self initWithTitle:title normalColor:NormalColor highlightedColor:HighlightedColor target:target action:action];
}

+ (id)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [[self alloc] initWithTitle:title target:target action:action];
}

#pragma mark - 设置文字按钮, backgroundImage:背景图片，normal：常规颜色 Highlighted：高亮颜色
- (id)initWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage target:(id)target action:(SEL)action {
    return [self initWithTitle:title backgroundImage:backImage normalColor:NormalColor highlightedColor:HighlightedColor target:target action:action];
}

+ (id)itemWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage target:(id)target action:(SEL)action {
    return [[self alloc] initWithTitle:title backgroundImage:backImage target:target action:action];
}

#pragma mark - 设置文字按钮，normal：常规颜色 Highlighted：高亮颜色
+ (id)itemWithTitle:(NSString *)title normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action {
    return [[self alloc] initWithTitle:title backgroundImage:[UIImage new] normalColor:normal highlightedColor:highlighted target:target action:action];
}

- (id)initWithTitle:(NSString *)title normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action {
    return [self initWithTitle:title backgroundImage:[UIImage new] normalColor:[UIColor lightGrayColor] highlightedColor:[UIColor blackColor] target:target action:action];
}

#pragma mark - 设置文字按钮，backgroundImage:背景图片 normal：常规颜色 Highlighted：高亮颜色
+ (id)itemWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action {
    return [[self alloc] initWithTitle:title backgroundImage:backImage normalColor:normal highlightedColor:highlighted target:target action:action];
}

- (id)initWithTitle:(NSString *)title backgroundImage:(UIImage *)backImage normalColor:(UIColor *)normal highlightedColor:(UIColor *)highlighted target:(id)target action:(SEL)action {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.backgroundColor = [UIColor clearColor];
    [barButton setTitle:title forState:UIControlStateNormal];
    [barButton setTitleColor:normal forState:UIControlStateNormal];
    [barButton setTitleColor:highlighted forState:UIControlStateHighlighted];
    [barButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [barButton setBackgroundImage:backImage forState:UIControlStateHighlighted];
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    barButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    if (CGSizeEqualToSize(backImage.size, CGSizeZero)) {
        CGSize size = [barButton.titleLabel sizeThatFits:CGSizeMake(100, 44)];
        barButton.frame = CGRectMake(0, 0, size.width, size.height);
    } else {
        barButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    }

    return [self initWithCustomView:barButton];
}

@end
