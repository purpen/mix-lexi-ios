//
//  UITableViewCell+DealContent.m
//  lexi
//
//  Created by FLYang on 2018/11/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "UITableViewCell+DealContent.h"
#import "YYLabel+Helper.h"
#import "THNDealContentModel.h"
#import "NSString+Helper.h"
#import <SDWebImage/NSData+ImageContentType.h>
#import <SDWebImage/SDWebImageManager.h>
#import "UIImage+Helper.h"

@interface UITableViewCell ()

/// 创建类型
@property (nonatomic, assign) THNDealContentType type;

@end

@implementation UITableViewCell (DealContent)

+ (CGFloat)heightWithText:(NSString *)text fontSize:(CGFloat)fontSize spacing:(CGFloat)spacing width:(CGFloat)width {
    CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:text
                                                         fontSize:fontSize
                                                      lineSpacing:spacing
                                                          fixSize:CGSizeMake(width, MAXFLOAT)].height;
    return textH;
}

+ (CGFloat)heightWithDaelContentData:(NSArray *)dealContent {
    return [self heightWithDaelContentData:dealContent type:(THNDealContentTypeArticle)];
}

+ (CGFloat)heightWithDaelContentData:(NSArray<THNDealContentModel *> *)dealContent type:(THNDealContentType)type {
    CGFloat contentH = 0.0;
    CGFloat imageW = type == THNDealContentTypeArticle ? kScreenWidth : kScreenWidth - 30;
    
    for (THNDealContentModel *model in dealContent) {
        if ([model.type isEqualToString:@"text"]) {
            CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:[NSString filterHTML:model.content]
                                                                 fontSize:14
                                                              lineSpacing:7
                                                                  fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
            contentH += (textH + 10);
            
        } else if ([model.type isEqualToString:@"image"]) {
            if (model.width > 0 && model.height > 0) {
                CGFloat imageScale = imageW / model.width;
                CGFloat imageH = model.height * imageScale;
                
                contentH += (imageH + 10);
            
            } else {
                UIImage *contentImage = [UIImage getImageFormDiskCacheForKey:model.content];
                
                if (![UIImage isCacheImageOfImageUrl:model.content]) {
                    [[SDWebImageManager sharedManager].imageCache storeImage:contentImage
                                                                      forKey:model.content
                                                                      toDisk:YES
                                                                  completion:nil];
                }
                
                CGFloat imageScale = (kScreenWidth - 30) / contentImage.size.width;
                CGFloat imageH = contentImage.size.height * imageScale;
                
                contentH += (imageH + 10);
            }
        }
    }
    
    return contentH + 15;
}

@end
