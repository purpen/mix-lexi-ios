//
//  THNSevenImagesStitchView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSevenImagesStitchView.h"
#import "UIImageView+WebCache.h"

@interface THNSevenImagesStitchView()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation THNSevenImagesStitchView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSevenImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    }];
}

@end
