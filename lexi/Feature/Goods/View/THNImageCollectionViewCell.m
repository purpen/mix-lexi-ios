//
//  THNImageCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNImageCollectionViewCell.h"
#import "UIImageView+WebImage.h"

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
    
    [self.showImageView loadImageWithUrl:[url loadImageUrlWithType:(THNLoadImageUrlTypeGoodsInfo)]];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.showImageView];
}

#pragma mark - getters and setters
- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.layer.masksToBounds = YES;
    }
    return _showImageView;
}

@end
