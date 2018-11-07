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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 62;
    frame.size.width -= 82;
    [super setFrame:frame];
}

@end
