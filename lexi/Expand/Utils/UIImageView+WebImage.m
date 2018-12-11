//
//  UIImageView+WebImage.m
//  lexi
//
//  Created by FLYang on 2018/11/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"

static NSString *const kPlaceholderImageUser = @"default_user_place";
static NSString *const kPlaceholderImageName = @"default_image_place";

@implementation UIImageView (WebImage)

#pragma mark - SDWebImage 缓存图片
- (void)downloadImage:(NSString *)url {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:kPlaceholderImageName]
                     options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

- (void)downloadImage:(NSString *)url place:(UIImage *)place {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:place
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

#pragma mark - YYWebImage 缓存图片
- (void)loadImageWithUrl:(NSString *)url {
    [self setImageWithURL:[NSURL URLWithString:url]
              placeholder:[UIImage imageNamed:kPlaceholderImageName]
                  options:YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionIgnoreFailedURL
               completion:nil];
}

- (void)loadImageWithUrl:(NSString *)url place:(UIImage *)place {
    [self setImageWithURL:[NSURL URLWithString:url]
              placeholder:place
                  options:YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionIgnoreFailedURL
               completion:nil];
}

- (void)loadImageWithUrl:(NSString *)url circular:(BOOL)circular {
    if (circular) {
        [self loadImageWithUrl:url resizeToSize:self.frame.size cornerRadius:self.frame.size.height / 2];
        [self drawCornerWithType:(UILayoutCornerRadiusAll) radius:self.frame.size.height/2];
        
    } else {
        [self loadImageWithUrl:url];
    }
}

- (void)loadImageWithUrl:(NSString *)url resizeToSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    [self setImageWithURL:[NSURL URLWithString:url]
              placeholder:[UIImage imageNamed:kPlaceholderImageName]
                  options:YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionIgnoreFailedURL
                 progress:nil
                transform:^UIImage *(UIImage *image, NSURL *url) {
                    image = [image imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
                    return [image imageByRoundCornerRadius:cornerRadius];
                }
               completion:nil];
}

#pragma mark 加载本地图片
- (void)loadImageWithPath:(NSString *)path {
    self.imageURL = [NSURL fileURLWithPath:path];
}

@end
