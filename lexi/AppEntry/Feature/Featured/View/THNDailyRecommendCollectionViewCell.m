//
//  THNDailyRecommendCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDailyRecommendCollectionViewCell.h"
#import "THNDailyRecommendModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"

@interface THNDailyRecommendCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation THNDailyRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backImageView.layer.cornerRadius = 4;
    self.backImageView.layer.masksToBounds = YES;
}

- (void)setDailyRecommendModel:(THNDailyRecommendModel *)dailyRecommendModel {
    _dailyRecommendModel = dailyRecommendModel;
    self.titleLabel.text = dailyRecommendModel.recommend_label;
    self.subTitleLabel.text = dailyRecommendModel.recommend_title;
    self.contentLabel.text = dailyRecommendModel.recommend_description;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:dailyRecommendModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}
@end
