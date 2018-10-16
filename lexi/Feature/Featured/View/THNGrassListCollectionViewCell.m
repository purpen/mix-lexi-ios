//
//  THNGrassListCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGrassListCollectionViewCell.h"
#import "THNGrassListModel.h"
#import "UIImageView+WebCache.h"
#import "THNGrassListModel.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"


@interface THNGrassListCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation THNGrassListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
    [self.avatarImageView drawCornerWithType:0 radius:self.avatarImageView.viewHeight / 2];
}

-  (void)setGrassListModel:(THNGrassListModel *)grassListModel {
    _grassListModel = grassListModel;
    
    if (self.showTextType == ShowTextTypeTheme) {
        self.contentLabel.text = grassListModel.title;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        if ([grassListModel.channel_name isEqualToString:grassNote]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:@"75AB9A"];
        } else if ([grassListModel.channel_name isEqualToString:creatorStoryTitle]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:@"829D7A"];
        } else if ([grassListModel.channel_name isEqualToString:lifeRememberTitle]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:@"8C7A6E"];
        } else if ([grassListModel.channel_name isEqualToString:handTeachTitle]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:@"E3B395"];

        }

        self.titleLabel.text = grassListModel.channel_name;
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    } else {
        self.contentLabel.text = grassListModel.des;
        self.titleLabel.text = grassListModel.title;
    }
    
    self.nameLabel.text = grassListModel.user_name;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:grassListModel.user_avator]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:grassListModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}



@end
