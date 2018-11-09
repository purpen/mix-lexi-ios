//
//  UIImage+GIF.h
//  lexi
//
//  Created by FLYang on 2018/10/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GifImageBlock)(UIImage *gifImage);

@interface UIImage (GIF)

+ (UIImage *)imageWithGifNamed:(NSString *)name;
+ (UIImage *)imageWithGifData:(NSData *)data;

/**
 gif 图拆分成图片数组

 @param name gif 图名称
 @return 图片数组
 */
+ (NSArray *)imagesWithGifNamed:(NSString *)name;

@end
