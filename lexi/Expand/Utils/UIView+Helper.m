//
//  UIView+Helper.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import <UIKit/UIKit.h>

@implementation UIView (Helper)

#pragma mark - 绘制直线
+ (void)drawRectLineStart:(CGPoint)start end:(CGPoint)end width:(CGFloat)width color:(UIColor *)color {
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addLineToPoint:end];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapButt;
    
    [path stroke];
}

#pragma mark - 绘制圆角
- (void)drawCornerWithType:(UILayoutCornerRadiusType)type radius:(CGFloat)radius {
    UIBezierPath *maskPath;
    
    switch (type) {
            
        // 四个角全切
        case UILayoutCornerRadiusAll: {
            maskPath = [self getBezierPathByCorners:UIRectCornerAllCorners
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
        
        // 三个角
        case UILayoutCornerRadiusExceptTopLeft: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusExceptTopRight: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusExceptBottomLeft: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopRight | UIRectCornerTopLeft | UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusExceptBottomRight: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        // 两个角
        case UILayoutCornerRadiusTop: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusLeft: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusRight: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusBottom: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        // 一个角
        case UILayoutCornerRadiusTopLeft: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopLeft)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusTopRight: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusBottomLeft: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerBottomLeft)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusBottomRight: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        // 对角线
        case UILayoutCornerRadiusTopLeftToBottomRight: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
            
        case UILayoutCornerRadiusTopRightToBottomLeft: {
            maskPath = [self getBezierPathByCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft)
                                             redius:radius];
            
            [self makeCornerWithMaskPath:maskPath];
        }
            break;
    }
}

- (UIBezierPath *)getBezierPathByCorners:(UIRectCorner)corner redius:(CGFloat)radius {
    CGSize cornerSize = CGSizeMake(radius, radius);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     byRoundingCorners:corner
                                                           cornerRadii:cornerSize];
    
    return bezierPath;
}

- (void)makeCornerWithMaskPath:(UIBezierPath *)maskPath {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - 绘制边框
- (void)drawViewBorderType:(UIViewBorderLineType)type width:(CGFloat)width color:(UIColor *)color {
    CALayer *boderLineLayer = [CALayer layer];
    boderLineLayer.backgroundColor = color.CGColor;
    
    switch (type) {
        case UIViewBorderLineTypeAll: {
            self.layer.borderWidth = width;
            self.layer.borderColor = color.CGColor;
        }
            break;
            
        case UIViewBorderLineTypeTop: {
            boderLineLayer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        }
            break;
        
        case UIViewBorderLineTypeRight: {
            boderLineLayer.frame = CGRectMake(self.frame.size.width, 0, width, self.frame.size.height);
        }
            break;
        
        case UIViewBorderLineTypeBottom:{
            boderLineLayer.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, width);
        }
            break;
       
        case UIViewBorderLineTypeLeft:{
            boderLineLayer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        }
            break;
    }
    
    [self.layer addSublayer:boderLineLayer];
}

- (void)drwaShadow {
    self.layer.shadowRadius = 4;
    self.layer.cornerRadius = 4;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.borderWidth = 0.5;
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowColor = [[UIColor colorWithHexString:@"000000"] CGColor];
    self.layer.borderColor = [[UIColor colorWithHexString:@"e9e9e9"] CGColor];
    self.layer.masksToBounds = NO;
}

+ (UIView *)initLineView:(CGRect)frame {
    UIView *lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    return lineView;
}

+ (instancetype)viewFromXib {
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])owner:nil options:nil]firstObject];
}

- (void)setViewHeight:(CGFloat)viewHeight {
    CGRect frame = self.frame;
    frame.size.height = viewHeight;
    self.frame = frame;
}

- (void)setViewWidth:(CGFloat)viewWidth {
    CGRect frame = self.frame;
    frame.size.width = viewWidth;
    self.frame = frame;
}

- (CGFloat)viewHeight {
    return self.frame.size.height;
}

- (CGFloat)viewWidth {
    return self.frame.size.width;
}

- (void)setViewX:(CGFloat)viewX {
    CGRect frame = self.frame;
    frame.origin.x = viewX;
    self.frame = frame;
}

- (CGFloat)viewX {
    return self.frame.origin.x;
}

- (void)setViewY:(CGFloat)viewY {
    CGRect frame = self.frame;
    frame.origin.y = viewY;
    self.frame = frame;
}

- (CGFloat)viewY {
    return self.frame.origin.y;
}

@end
