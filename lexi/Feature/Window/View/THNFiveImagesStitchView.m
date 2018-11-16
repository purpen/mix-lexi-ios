//
//  THNFiveImagesStitchView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFiveImagesStitchView.h"
#import "UIImageView+WebImage.h"

@interface THNFiveImagesStitchView()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation THNFiveImagesStitchView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        imageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent:)];
        [imageView addGestureRecognizer:singleTap];
        singleTap.view.tag = idx;
        imageView.userInteractionEnabled = YES;
    }];
}

- (void)setFiveImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        [imageView loadImageWithUrl:[obj loadImageUrlWithType:(THNLoadImageUrlTypeWindowP500)]];
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
    if (self.fiveImageBlock) {
        self.fiveImageBlock(views.tag);
    }
}

@end
