//
//  UIImageView+SDWedImage.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIImageView+SDWedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Helper.h"

@implementation UIImageView (SDWedImage)

#pragma mark SDWebImage缓存图片
- (void)downloadImage:(NSString *)url place:(UIImage *)place {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place
                     options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

#pragma mark SDWebImage缓存图片后的回调
- (void)downloadImage:(NSString *)url place:(UIImage *)place completed:(DownloadCompleted)completed {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:place
                     options:SDWebImageLowPriority | SDWebImageRetryFailed
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       completed(image, error);
                   }];
}

#pragma mark SDWebImage图片下载进度
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place
              success:(DownloadSuccessBlock)success
              failure:(DownloadFailureBlock)failure
             received:(DownloadProgressBlock)progress {
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager loadImageWithURL:[NSURL URLWithString:url]
                      options:SDWebImageHighPriority | SDWebImageRetryFailed
                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                         if (receivedSize && expectedSize) {
                             progress(receivedSize, expectedSize);
                         }
                         
                     } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                         if (error) {
                             failure(error);
                             
                         } else {
                             self.image = image;
                             success(finished, cacheType, image);
                         }
                     }];
}

//网络延迟下载--圆形 背景色为透明 无背景色
- (void)thn_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image{
    [self thn_setCircleImageWithUrlString:urlString placeholder:image fillColor:nil opaque:NO];
}

- (void)thn_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color opaque:(BOOL)opaque{
    [self.superview layoutIfNeeded];
    NSURL *url = [NSURL URLWithString:urlString];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (image) {
        //占位图片不为空的情况
        //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
        [image thn_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusPlaceHolder) {
            
            //2.使用sd的方法缓存异步下载的图片
            [weakSelf sd_setImageWithURL:url placeholderImage:radiusPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img thn_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusImage) {
                    weakSelf.image = radiusImage;
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        //2.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img thn_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
        }];
    }
}

@end
