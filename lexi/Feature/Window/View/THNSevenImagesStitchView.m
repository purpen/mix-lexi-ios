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
    [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent:)];
        [imageView addGestureRecognizer:singleTap];
        singleTap.view.tag = idx;
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
    }];
}

- (void)setSevenImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
        imageView.contentMode = self.isContentModeCenter ? UIViewContentModeCenter : UIViewContentModeScaleAspectFill;
    }];
}

- (void)setCLickImageView:(NSString *)url withSelectIndex:(NSInteger)index {
    UIImageView *imageView = self.imageViews[index];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

- (void)clickEvent:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *views = (UIView*) tap.view;
    if (self.sevenImageBlock) {
        self.sevenImageBlock(views.tag);
    }
}

@end
