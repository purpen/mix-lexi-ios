//
//  THNArticleHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleHeaderView.h"
#import "THNGrassListModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+SDWedImage.h"
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import "UIColor+Extension.h"

@interface THNArticleHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
// 主题Label
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorsNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end

@implementation THNArticleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.followButton drawCornerWithType:0 radius:13];
}

- (void)setGrassListModel:(THNGrassListModel *)grassListModel {
    _grassListModel = grassListModel;
    self.userNameLabel.text = grassListModel.user_name;
    [self.avatarImageView thn_setCircleImageWithUrlString:grassListModel.user_avator placeholder:[UIImage imageNamed:@"default_image_place"]];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:grassListModel.cover]];
    if (grassListModel.channel_name.length == 0) {
        self.themeLabel.text = @"种草笔记";
        self.themeLabel.textColor = [UIColor colorWithHexString:@"75AB9A"];
    } else if ([grassListModel.channel_name isEqualToString:creatorStoryTitle]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"829D7A"];
        self.themeLabel.text = grassListModel.channel_name;
    } else if ([grassListModel.channel_name isEqualToString:lifeRememberTitle]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"8C7A6E"];
        self.themeLabel.text = grassListModel.channel_name;
    } else if ([grassListModel.channel_name isEqualToString:handTeachTitle]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"E3B395"];
        self.themeLabel.text = grassListModel.channel_name;
    }
    self.titleLabel.text = grassListModel.title;
    self.visitorsNumberLabel.text = [NSString stringWithFormat:@"%ld",grassListModel.browse_count];
    self.dateLabel.text = [NSString timeConversion:grassListModel.created_at initWithFormatterType:FormatterDay];
}

@end
