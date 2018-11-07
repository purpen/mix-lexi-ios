//
//  THNSecondLevelCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSecondLevelCommentTableViewCell.h"
#import "UIView+Helper.h"

@interface THNSecondLevelCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *praisesButton;

@end

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
