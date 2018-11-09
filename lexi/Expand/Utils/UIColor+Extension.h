//
//  UIColor+Extension.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 随机颜色

 @return 颜色
 */
+ (UIColor *)getRandomColor;

/**
 转换 HEX 格式的颜色值

 @param color 颜色值(#000000)
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 转换 HEX 格式的颜色值，设置透明度

 @param color 颜色值(#000000)
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 设置渐变色
 
 @param view 视图
 @param colors 渐变色, [开始色，结束色]
 @return layer
 */
+ (CAGradientLayer *)colorGradientWithView:(UIView *)view colors:(NSArray *)colors;

@end
