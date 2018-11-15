//
//  THNImageStitchingView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNThreeImageStitchingView.h"
#import "UIImageView+WebCache.h"
#import "THNProductModel.h"

@interface THNThreeImageStitchingView()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *moreImageCountLabel;

@end

@implementation THNThreeImageStitchingView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = self.imageViews[idx];
        imageView.layer.masksToBounds = YES;
        self.moreImageCountLabel.hidden = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent:)];
        [imageView addGestureRecognizer:singleTap];
        singleTap.view.tag = idx;
    }];
}

- (void)setThreeImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 2) {
            return;
        }
        UIImageView *imageView = self.imageViews[idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
        imageView.userInteractionEnabled = self.isHaveUserInteractionEnabled;
        imageView.contentMode = self.isContentModeCenter ? UIViewContentModeCenter : UIViewContentModeScaleAspectFill;
        
    }];
    
    if (images.count > 3) {
        self.moreImageCountLabel.hidden = NO;
        self.moreImageCountLabel.text = [NSString stringWithFormat:@"+%ld",images.count - 3];
    } else {
        self.moreImageCountLabel.hidden = YES;
    }
}

- (void)clickEvent:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *views = (UIView*) tap.view;
    if (self.threeImageBlock) {
        self.threeImageBlock(views.tag);
    }
}

@end
