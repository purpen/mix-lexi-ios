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

@property (weak, nonatomic) IBOutlet UIImageView *leftTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightMiddleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

@end

@implementation THNFiveImagesStitchView

- (void)setFiveImageStitchingView:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                [self.leftTopImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                break;
            case 1:
                [self.rightTopImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
            case 2:
                [self.rightMiddleImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                break;
            case 3:
                [self.leftBottomImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                break;
            default:
                [self.rightBottomImageView sd_setImageWithURL:[NSURL URLWithString:obj]];
                break;
                
        }
    }];
}

@end
