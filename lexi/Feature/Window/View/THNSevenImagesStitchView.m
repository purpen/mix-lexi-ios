//
//  THNSevenImagesStitchView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSevenImagesStitchView.h"
#import "UIImageView+WebImage.h"

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
        [imageView loadImageWithUrl:[obj loadImageUrlWithType:(THNLoadImageUrlTypeWindowP500)]];
        imageView.contentMode = self.isContentModeCenter ? UIViewContentModeCenter : UIViewContentModeScaleAspectFill;
    }];
}

- (void)setCLickImageView:(NSString *)url withSelectIndex:(NSInteger)index {
    UIImageView *imageView = self.imageViews[index];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView loadImageWithUrl:url];
}

- (void)setSevenImages:(NSArray *)coverWithSelectIndexs {
    for (NSDictionary *dict in coverWithSelectIndexs) {
        NSInteger selectIndex = [dict[@"selectIndex"] integerValue];
        if (selectIndex > 6) {
            return;
        }
        [self setCLickImageView:dict[@"cover"] withSelectIndex:selectIndex];
    }
}

- (void)clickEvent:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *views = (UIView*) tap.view;
    if (self.sevenImageBlock) {
        self.sevenImageBlock(views.tag);
    }
}

@end
