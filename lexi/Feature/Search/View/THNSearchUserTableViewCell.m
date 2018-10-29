//
//  THNSearchUserTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchUserTableViewCell.h"
#import "UIImageView+SDWedImage.h"
#import "UIView+Helper.h"
#import "THNUserModel.h"
#import "THNFollowUserButton+SelfManager.h"

@interface THNSearchUserTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *wishCountLabel;
@property (weak, nonatomic) IBOutlet THNFollowUserButton *followButton;

@end

@implementation THNSearchUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.followButton drawCornerWithType:0 radius:4];
    [self.followButton setupViewUI];
}

- (void)setUserModel:(THNUserModel *)userModel {
    _userModel = userModel;
    [self.userImageView thn_setCircleImageWithUrlString:userModel.avatar placeholder:[UIImage imageNamed:@"default_image_place"]];
    self.userNameLabel.text = userModel.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"喜欢%ld",userModel.user_like_counts];
    self.wishCountLabel.text = [NSString stringWithFormat:@"心愿单%ld",userModel.wish_list_counts];
    [self.followButton selfManagerFollowUserStatus:userModel.followed_status userModel:userModel];
}

- (IBAction)follow:(id)sender {
    
}

@end
