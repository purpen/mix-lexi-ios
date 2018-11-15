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
#import "THNUserPartieModel.h"
#import "THNProductModel.h"
#import "THNCollectionModel.h"

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
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:setModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

- (void)setCollectionModel:(THNCollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    self.setLabelsView.hidden = YES;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:collectionModel.cover] placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

- (void)setBannerModel:(THNBannerModel *)bannerModel {
    self.setLabelsView.hidden = YES;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.image]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

- (void)setUserPartieModel:(THNUserPartieModel *)userPartieModel {
    self.setLabelsView.hidden = YES;
    self.layer.cornerRadius = self.viewHeight / 2;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:userPartieModel.avatar]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

- (void)setProductModel:(THNProductModel *)productModel {
    _productModel = productModel;
    self.setLabelsView.hidden = YES;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

- (void)setProductModel:(NSString *)cover withNeedRadian:(BOOL)isNeedRadian {
    self.layer.cornerRadius = isNeedRadian ? 4 : 0;
    self.setLabelsView.hidden = YES;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
}

@end
