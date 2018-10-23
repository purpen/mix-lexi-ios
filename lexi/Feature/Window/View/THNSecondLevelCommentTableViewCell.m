//
//  THNSecondLevelCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSecondLevelCommentTableViewCell.h"
#import "UIView+Helper.h"

@implementation THNSecondLevelCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drawCornerWithType:0 radius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
