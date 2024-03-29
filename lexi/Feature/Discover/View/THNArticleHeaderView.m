//
//  THNArticleHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleHeaderView.h"
#import "THNGrassListModel.h"
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import "UIColor+Extension.h"
#import "THNFollowUserButton.h"
#import "THNFollowUserButton+SelfManager.h"
#import "THNFollowStoreButton.h"
#include "THNFollowStoreButton+SelfManager.h"

@interface THNArticleHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
// 主题Label
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorsNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet THNFollowUserButton *userFollowButton;
@property (weak, nonatomic) IBOutlet THNFollowStoreButton *storeFollowButton;

@end

@implementation THNArticleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.userFollowButton drawCornerWithType:0 radius:13];
    [self.userFollowButton setupViewUI];
    [self.storeFollowButton drawCornerWithType:0 radius:self.storeFollowButton.viewHeight / 2];
    [self.storeFollowButton setupViewUI];
    self.backgroundImageView.layer.masksToBounds = YES;
    
}

- (void)setGrassListModel:(THNGrassListModel *)grassListModel {
    _grassListModel = grassListModel;
    self.userNameLabel.text = grassListModel.user_name;
    [self.avatarImageView loadImageWithUrl:[grassListModel.user_avator loadImageUrlWithType:(THNLoadImageUrlTypeAvatarSmall)]
                                  circular:YES];
    
    [self.backgroundImageView loadImageWithUrl:[grassListModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeBannerDefault)]];
    if ([grassListModel.channel_name isEqualToString:grassNote]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"75AB9A"];
    } else if ([grassListModel.channel_name isEqualToString:creatorStoryTitle]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"829D7A"];
    } else if ([grassListModel.channel_name isEqualToString:lifeRememberTitle]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"8C7A6E"];
    } else if ([grassListModel.channel_name isEqualToString:handTeachTitle]) {
        self.themeLabel.textColor = [UIColor colorWithHexString:@"E3B395"];
    }

    self.themeLabel.text = grassListModel.channel_name;
    self.titleLabel.text = grassListModel.title;
    self.visitorsNumberLabel.text = [NSString stringWithFormat:@"%ld",grassListModel.browse_count];
    self.dateLabel.text = [NSString timeConversion:grassListModel.created_at initWithFormatterType:FormatterDay];
    
    if (grassListModel.is_user) {
        self.userFollowButton.hidden = NO;
        self.storeFollowButton.hidden = YES;
        [self.userFollowButton selfManagerFollowUserStatus:grassListModel.is_follow grassListModel:grassListModel];
    } else {
        self.storeFollowButton.hidden = NO;
        self.userFollowButton.hidden = YES;
        [self.storeFollowButton selfManagerFollowBrandStatus:grassListModel.is_follow grassListModel:grassListModel];
    }
    
    
    
}

@end
