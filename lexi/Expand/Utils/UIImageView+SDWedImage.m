//
//  UIImageView+SDWedImage.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIImageView+SDWedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (SDWedImage)

#pragma mark SDWebImage缓存图片
- (void)downloadImage:(NSString *)url place:(UIImage *)place {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

#pragma mark SDWebImage缓存图片后的回调
- (void)downloadImage:(NSString *)url placess:(UIImage *)place completed:(DownloadCompleted)completed {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            completed(image, error);
        }
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
                      options:SDWebImageLowPriority | SDWebImageRetryFailed
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

@end
