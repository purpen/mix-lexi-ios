//
//  UIImage+GIF.m
//  lexi
//
//  Created by FLYang on 2018/10/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+Helper.h"

@implementation UIImage (GIF)

+ (UIImage *)imageWithGifData:(NSData *)data {
    if (!data) return nil;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
        
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            NSTimeInterval frameDuration = [UIImage sd_frameDurationAtIndex:i source:source];
            
            duration += frameDuration;
            
            [images addObject:[UIImage imageWithCGImage:image
                                                  scale:[UIScreen mainScreen].scale
                                            orientation:UIImageOrientationUp]];
            
            CFRelease(image);
            
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }

    CFRelease(source);
    
    return animatedImage;
}

+ (UIImage *)imageWithGifNamed:(NSString *)name {
    NSUInteger scale = (NSUInteger)[UIScreen mainScreen].scale;
    
    return [self gifImageName:name scale:scale];
}

+ (UIImage *)gifImageName:(NSString *)name scale:(NSUInteger)scale {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    
    if (!imagePath) {
        (scale + 1 > 3) ? (scale -= 1) : (scale += 1);
        imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    }
    
    if (imagePath) {
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        
        return [UIImage imageWithGifData:imageData];
        
    } else {
        imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        if (imagePath) {
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            
            return [UIImage imageWithGifData:imageData];
            
        } else {
            return [UIImage imageNamed:name];
        }
    }
}

#pragma mark - gif 帧时长
+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    
    return frameDuration;
}

#pragma mark - gif 图拆分成图片数组
+ (NSArray *)imagesWithGifNamed:(NSString *)name {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"gif"];
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage resizeImage:[UIImage imageWithCGImage:imageRef] size:CGSizeMake(60, 60)];
        [frames addObject:image];
        CGImageRelease(imageRef);
    }
    
    return frames;
}

@end
