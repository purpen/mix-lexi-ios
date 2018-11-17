//
//  THNSelectPruductCoverCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/11/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectPruductCoverCollectionViewCell.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

@implementation THNSelectPruductCoverCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImageView.layer.masksToBounds = YES;
    self.photoImageView.layer.borderColor = [[UIColor colorWithHexString:@"e9e9e9"] CGColor];
    self.photoImageView.layer.borderWidth = 0.5;
}


- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.selectButton.selected = isSelect;
}

@end
