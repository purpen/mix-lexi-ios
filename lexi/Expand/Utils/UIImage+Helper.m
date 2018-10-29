//
//  UIImage+Helper.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIImage+Helper.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImage+MultiFormat.h>

@implementation UIImage (Helper)

#pragma mark - 默认从图片中心点开始拉伸图片
+ (UIImage *)resizedImage:(NSString *)imgName {
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

#pragma mark - 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos {
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

#pragma mark - 调整拍照图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }

    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:

            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 圆形裁剪
+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    CGFloat imageWH = image.size.width;
    CGFloat border = borderWidth;
    CGFloat ovalWH = imageWH + 2 * border;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    
    [color set];
    [path fill];

    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];

    [image drawAtPoint:CGPointMake(border, border)];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImage;
}

#pragma mark - 控件截屏
+ (UIImage *)imageWithCaputureView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 生成二维码图片
+ (UIImage *)creatQRCodeImageForLinkUrl:(NSString *)url width:(CGFloat)width {
    NSData *urlData = [url dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:urlData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = [qrFilter outputImage];
    return [self generateQRCodeimagesForCIImage:ciImage width:width];
}

+ (UIImage *)generateQRCodeimagesForCIImage:(CIImage *)ciImage width:(CGFloat)width {
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(width/CGRectGetWidth(extent), width/CGRectGetHeight(extent));
    
    // 创建 bitmap
    size_t imageWidth = CGRectGetWidth(extent) * scale;
    size_t imageHeight = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, imageWidth, imageHeight, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存 bitmap 到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 压缩图片
+ (UIImage *)compressImage:(UIImage *)image {
    return [self compressImage:image width:[[UIScreen mainScreen] bounds].size.width];
}

+ (UIImage *)compressImage:(UIImage *)image width:(CGFloat)width {
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float height = image.size.height / (image.size.width / width);
    float widthScale = imageWidth / width;
    float heightScale = imageHeight / height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth/heightScale, height)];
        
    } else {
        [image drawInRect:CGRectMake(0, 0, width, imageHeight/widthScale)];
    }

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSData *)compressImageToData:(UIImage *)image {
    UIImage *newImage = [self compressImage:image];
    return UIImageJPEGRepresentation(newImage, 0.9);
}

#pragma mark - 通过 url 获取图片的尺寸
+ (CGSize)getImageSizeFromUrl:(NSString *)imageUrl {
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL URLWithString:imageUrl], NULL);
    NSDictionary *imageHeader = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    CGFloat imageW = [imageHeader[@"PixelWidth"] floatValue];
    CGFloat imageH = [imageHeader[@"PixelHeight"] floatValue];
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    return imageSize;
}

#pragma mark - 获取缓存中的图片
+ (UIImage *)getImageFormDiskCacheForKey:(NSString *)key {
    if ([self isCacheImageOfImageUrl:key]) {
        return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    }
    
    UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:key]]];
    
    return [self compressImage:image width:700];
}

+ (BOOL)isCacheImageOfImageUrl:(NSString *)imageUrl {
    return [[SDImageCache sharedImageCache] diskImageDataExistsWithKey:imageUrl];
}

#pragma mark - 调整图片的尺寸
+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size {
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
        
    } else if ([[UIScreen mainScreen] scale] == 3.0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
        
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
}

#pragma mark - 圆形
- (void)thn_roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor opaque:(BOOL)opaque completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //        NSTimeInterval start = CACurrentMediaTime();
        
        // 1. 利用绘图，建立上下文 BOOL选项为是否为不透明
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // 2. 设置填充颜色
        if (opaque) {
            [fillColor setFill];
            UIRectFill(rect);
        }
        
        // 3. 利用 贝赛尔路径 `裁切 效果
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        
        // 4. 绘制图像 如果图片为空那么为单色渲染
        if (self) {
            [self drawInRect:rect];
        }
        
        // 5. 取得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6. 关闭上下文
        UIGraphicsEndImageContext();

        
        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

@end
