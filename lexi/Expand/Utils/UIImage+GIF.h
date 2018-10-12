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

@end
