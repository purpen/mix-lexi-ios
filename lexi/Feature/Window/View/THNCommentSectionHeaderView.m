//
//  THNSectionHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/11/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentSectionHeaderView.h"
#import "THNCommentModel.h"
#import "UIImageView+SDWedImage.h"

@interface THNCommentSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;

@end

@implementation THNCommentSectionHeaderView

- (void)setCommentModel:(THNCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.avatarImageView thn_setCircleImageWithUrlString:commentModel.user_avatar placeholder:[UIImage imageNamed:@"default_user_place"]];
    self.nameLabel.text = commentModel.user_name;
    self.contentlabel.text = commentModel.content;
}


// 赞
- (IBAction)reply:(id)sender {
    
}

// 回复
- (IBAction)awesome:(id)sender {
    
}


@end
