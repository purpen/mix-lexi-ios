//
//  UIView+Helper.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UILayoutCornerRadiusType) {
    // 全部角都切圆角
    UILayoutCornerRadiusAll = 0,
    
    // 切三个角
    UILayoutCornerRadiusExceptTopLeft,
    UILayoutCornerRadiusExceptTopRight,
    UILayoutCornerRadiusExceptBottomLeft,
    UILayoutCornerRadiusExceptBottomRight,
    
    // 切两个角（同一边）
    UILayoutCornerRadiusTop,
    UILayoutCornerRadiusLeft,
    UILayoutCornerRadiusRight,
    UILayoutCornerRadiusBottom,
    
    // 切一个角
    UILayoutCornerRadiusTopLeft,
    UILayoutCornerRadiusTopRight,
    UILayoutCornerRadiusBottomLeft,
    UILayoutCornerRadiusBottomRight,
    
    // 对角线
    UILayoutCornerRadiusTopLeftToBottomRight,
    UILayoutCornerRadiusTopRightToBottomLeft
};

typedef NS_ENUM(NSUInteger, UIViewBorderLineType) {
    UIViewBorderLineTypeAll,
    UIViewBorderLineTypeTop,
    UIViewBorderLineTypeRight,
    UIViewBorderLineTypeBottom,
    UIViewBorderLineTypeLeft,
};

@interface UIView (Helper)

/**
 绘制直线

 @param start X 开始位置
 @param end Y 开始位置
 @param width 宽度
 @param color 颜色
 */
+ (void)drawRectLineStart:(CGPoint)start end:(CGPoint)end width:(CGFloat)width color:(UIColor *)color;

/**
 绘制圆角

 @param type 类型
 @param radius 半径
 */
- (void)drawCornerWithType:(UILayoutCornerRadiusType)type radius:(CGFloat)radius;

/**
 设置视图的单边框

 @param type 边框类型
 @param width 宽度
 @param color 颜色
 */
- (void)drawViewBorderType:(UIViewBorderLineType)type width:(CGFloat)width color:(UIColor *)color ;

/**
 绘制渐变色透明遮罩
 
 @param startPoint 开始
 @param endPoint 结束
 @param hexColors HEX 色值
 */
- (void)drawGradientMaskWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)hexColors;

/**

 绘制阴影
 */
- (void)drwaShadow;

/**
 xib加载View
 */
+ (instancetype)viewFromXib;

/**
 灰色的View用于直线划分
 */
+ (UIView *)initLineView:(CGRect)frame;



/**
 view的属性 获取当前视图的 Height，Width，X, Y
 */
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewX;
@property (nonatomic, assign) CGFloat viewY;

@end
