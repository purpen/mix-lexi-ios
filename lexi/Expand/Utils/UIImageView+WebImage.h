//
//  UIImageView+WebImage.h
//  lexi
//
//  Created by FLYang on 2018/11/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/UIImage+YYAdd.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

typedef void (^DownloadSuccessBlock) (BOOL success, NSInteger cacheType, UIImage *image);
typedef void (^DownloadCompleted) (UIImage *image, NSError *error);
typedef void (^DownloadFailureBlock) (NSError *error);
typedef void (^DownloadProgressBlock) (NSInteger received, NSInteger expected);

@interface UIImageView (WebImage)

#pragma mark - SDWebImage
/**
 SDWebImage 下载并缓存图片
 
 @param url 图片的url(默认有缺省图)
 */
- (void)downloadImage:(NSString *)url;

/**
 SDWebImage 下载并缓存图片
 
 @param url 图片的url
 @param place 还未下载成功时的替换图片
 */
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place;

/**
 SDWebImage 下载并缓存图片
 
 @param url 图片的url
 @param place 还未下载成功时的替换图片
 @param completed 成功后的回调
 */
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place
            completed:(DownloadCompleted)completed;

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

#pragma mark - YYWebImage
/**
 YYWebImage 下载并缓存图片
 */
- (void)loadImageWithUrl:(NSString *)url;

/**
 YYWebImage 下载并缓存图片，显示占位图
 
 @param url 图片的url
 @param place 还未下载成功时的替换图片
 */
- (void)loadImageWithUrl:(NSString *)url
                   place:(UIImage *)place;

/**
 YYWebImage 下载并缓存图片，切圆形

 @param url 图片的url
 @param circular 是否裁剪成圆形
 */
- (void)loadImageWithUrl:(NSString *)url
                circular:(BOOL)circular;

/**
 YYWebImage 下载并缓存图片，切圆角

 @param url 图片的url
 @param size 缩放的尺寸
 @param cornerRadius 切圆角
 */
- (void)loadImageWithUrl:(NSString *)url
            resizeToSize:(CGSize)size
            cornerRadius:(CGFloat)cornerRadius;

/**
 YYWebImage 加载本地图片

 @param path 图片本地路径
 */
- (void)loadImageWithPath:(NSString *)path;

@end
