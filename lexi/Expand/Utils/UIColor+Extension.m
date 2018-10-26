//
//  UIColor+Extension.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIColor+Extension.h"

#define DEFAULT_VOID_COLOR [UIColor blackColor]

@implementation UIColor (Extension)

#pragma mark - 获取随机颜色
+ (UIColor *)getRandomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f
                                         green:aGreenValue / 255.0f
                                          blue:aBlueValue / 255.0f alpha:1.0f];
    
    return randColor;
}

#pragma mark - 转换 HEX 格式的颜色值
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)color {
    return [UIColor colorWithHexString:color alpha:1.0f];
}

#pragma mark - 绘制渐变色
+ (CAGradientLayer *)colorGradientWithView:(UIView *)view colors:(NSArray *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:colors[0]].CGColor,
                             (__bridge id)[UIColor colorWithHexString:colors[1]].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.locations = @[@0, @1];
    
    return gradientLayer;
}

@end
