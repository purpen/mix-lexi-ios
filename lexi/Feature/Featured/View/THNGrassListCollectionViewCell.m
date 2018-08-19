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
    self.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
    [self.avatarImageView drawCornerWithType:0 radius:self.avatarImageView.viewHeight / 2];
}

-  (void)setGrassListModel:(THNGrassListModel *)grassListModel {
    _grassListModel = grassListModel;
    self.contentLabel.text = grassListModel.content;
    self.titleLabel.text = grassListModel.title;
    self.nameLabel.text = grassListModel.user_name;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:grassListModel.user_avator]];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:grassListModel.cover]];
}



@end
