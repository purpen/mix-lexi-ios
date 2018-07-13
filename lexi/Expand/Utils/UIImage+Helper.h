//
//  UIImage+Helper.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)


/**
 默认从图片中心点开始拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName;

/**
 可以自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/**
 调整拍照图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 圆形裁剪

 @param image 图片
 @param borderWidth 边框宽度
 @param color 颜色
 @return 圆形图片
 */
+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

/**
 控件截屏
 */
+ (UIImage *)imageWithCaputureView:(UIView *)view;

/**
 生成二维码图片
 
 @param url 链接
 @return 二维码
 */
+ (UIImage *)creatQRCodeImageForLinkUrl:(NSString *)url width:(CGFloat)width;
+ (UIImage *)generateQRCodeimagesForCIImage:(CIImage *)ciImage width:(CGFloat)width;

@end

