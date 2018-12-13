//
//  THNLivingHallHeadLineCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeadLineCollectionViewCell.h"
#import "UIView+Helper.h"

NSString *const livingHallHeadLineCellIdentifier = @"livingHallHeadLineCellIdentifier";

@interface THNLivingHallHeadLineCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *tintLabel;

@end

@implementation THNLivingHallHeadLineCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drawCornerWithType:0 radius:self.viewHeight / 2];
}



@end
