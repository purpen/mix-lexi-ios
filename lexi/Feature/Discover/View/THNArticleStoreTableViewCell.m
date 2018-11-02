//
//  THNArticleStoreTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleStoreTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "THNLifeOrderStoreModel.h"
#import "UIView+Helper.h"
#import "THNFollowStoreButton+SelfManager.h"


@interface THNArticleStoreTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet THNFollowStoreButton *followButton;
@property (weak, nonatomic) IBOutlet UIView *borderBackgroundView;

@end

@implementation THNArticleStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.followButton drawCornerWithType:0 radius:14.5];
    [self.followButton setupViewUI];
    self.borderBackgroundView.layer.cornerRadius = 4;
}

- (void)setFeaturedBrandModel:(THNFeaturedBrandModel *)featuredBrandModel {
    _featuredBrandModel = featuredBrandModel;
    self.storeNameLabel.text = featuredBrandModel.store_name;
    self.productCountLabel.text = [NSString stringWithFormat:@"%ld件商品",featuredBrandModel.product_counts];
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:featuredBrandModel.store_logo]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    [self.followButton selfManagerFollowBrandStatus:featuredBrandModel.is_follow_store brandModel:featuredBrandModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
