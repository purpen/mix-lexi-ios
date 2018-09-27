//
//  UIImageView+SDWedImage.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DownloadSuccessBlock) (BOOL success, NSInteger cacheType, UIImage *image);
typedef void (^DownloadCompleted) (UIImage *image, NSError *error);
typedef void (^DownloadFailureBlock) (NSError *error);
typedef void (^DownloadProgressBlock) (NSInteger received, NSInteger expected);

@interface UIImageView (SDWedImage)

/**
 SDWebImage 下载并缓存图片
 
 @param url 图片的url
 @param place 还未下载成功时的替换图片
 */
- (void)downloadImage:(NSString *)url place:(UIImage *)place;

/**
 SDWebImage 下载并缓存图片
 
 @param url 图片的url
 @param place 还未下载成功时的替换图片
 @param completed 成功后的回调
 */
- (void)downloadImage:(NSString *)url place:(UIImage *)place completed:(DownloadCompleted)completed;

/**
 SDWebImage 下载并缓存图片和下载进度

 @param url 图片的url
 @param place 还未下载成功时的替换图片
 @param success 图片下载成功
 @param failure 图片下载失败
 @param progress 图片下载进度
 */
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place
              success:(DownloadSuccessBlock)success
              failure:(DownloadFailureBlock)failure
             received:(DownloadProgressBlock)progress;

//网络延迟下载--圆形    背景色为透明 无背景色
- (void)thn_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image;

@end
