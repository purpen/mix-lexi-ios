//
//  THNDiscoverSetCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDiscoverSetCollectionViewCell.h"
#import "UIView+Helper.h"

@implementation THNDiscoverSetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundImageView.layer.cornerRadius = 4;
    self.backgroundImageView.layer.masksToBounds = YES;
}

@end
