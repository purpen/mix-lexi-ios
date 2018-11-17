//
//  THNImageCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNImageCollectionViewCell.h"
#import "UIImageView+WebImage.h"

@interface THNImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation THNImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setImageUrl:(NSString *)url {
    if (!url.length) return;
    
    [self.imageView loadImageWithUrl:[url loadImageUrlWithType:(THNLoadImageUrlTypeGoodsInfo)]];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.imageView];
}

#pragma mark - getters and setters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
