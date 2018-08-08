//
//  THNBannnerCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBannnerCollectionViewCell.h"
#import "UIView+Helper.h"
#import "UIImageView+WebCache.h"
#import "THNSetModel.h"
#import "THNBannerModel.h"

@interface THNBannnerCollectionViewCell()


@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation THNBannnerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}

- (void)setSetModel:(THNSetModel *)setModel {
    self.setLabelsView.hidden = NO;
    self.titleLabel.text = setModel.name;
    self.subTitleLabel.text = setModel.sub_name;
    [self.backGroundView drawCornerWithType:0 radius:2];
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:setModel.cover]];
}

- (void)setBannerModel:(THNBannerModel *)bannerModel {
    self.setLabelsView.hidden = YES;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.image]];
}

@end
