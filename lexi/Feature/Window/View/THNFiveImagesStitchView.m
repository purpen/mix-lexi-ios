//
//  THNFiveImagesStitchView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFiveImagesStitchView.h"
#import "UIImageView+WebCache.h"

@interface THNFiveImagesStitchView()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation THNFiveImagesStitchView

- (void)setFiveImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    }];
}

@end
