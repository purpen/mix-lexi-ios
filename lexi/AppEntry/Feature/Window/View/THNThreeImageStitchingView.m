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
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

@end

@implementation THNThreeImageStitchingView

- (void)setThreeImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
                break;
            case 1:
                [self.rightTopImageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
            default:
                [self.rightBottomImageView sd_setImageWithURL:[NSURL URLWithString:obj]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
                break;
        }
    }];
}

@end
