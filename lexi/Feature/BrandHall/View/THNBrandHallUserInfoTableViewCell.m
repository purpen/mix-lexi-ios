//
//  THNBrandHallUserInfoTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/10/18.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallUserInfoTableViewCell.h"
#import "UIView+Helper.h"
#import "THNShopWindowModel.h"
#import "UIImageView+WebImage.h"

@interface THNBrandHallUserInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *identityView;
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *verifiedView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;


@end

@implementation THNBrandHallUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.identityView drawCornerWithType:0 radius:4];
    [self.verifiedView drawCornerWithType:0 radius:4];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setShowWindowModel:(THNShopWindowModel *)showWindowModel {
    _showWindowModel = showWindowModel;
    self.userNameLabel.text = showWindowModel.user_name;
    [self.avatarImageView loadImageWithUrl:[showWindowModel.user_avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                  circular:YES];
}

@end
