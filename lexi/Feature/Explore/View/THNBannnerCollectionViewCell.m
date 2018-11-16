//
//  THNBannnerCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBannnerCollectionViewCell.h"
#import "UIView+Helper.h"
#import "UIImageView+WebImage.h"
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
    
    [self.cellImageView loadImageWithUrl:[setModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeDefault)]];
}

- (void)setCollectionModel:(THNCollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    self.setLabelsView.hidden = YES;
    
    [self.cellImageView loadImageWithUrl:[collectionModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeDefault)]];
}

- (void)setBannerModel:(THNBannerModel *)bannerModel {
    self.setLabelsView.hidden = YES;
    
    [self.cellImageView loadImageWithUrl:[bannerModel.image loadImageUrlWithType:(THNLoadImageUrlTypeDefault)]];
}

- (void)setUserPartieModel:(THNUserPartieModel *)userPartieModel {
    self.setLabelsView.hidden = YES;
    self.layer.cornerRadius = self.viewHeight / 2;
    
    [self.cellImageView loadImageWithUrl:[userPartieModel.avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
}

- (void)setProductModel:(THNProductModel *)productModel {
    _productModel = productModel;
    self.setLabelsView.hidden = YES;
    
    [self.cellImageView loadImageWithUrl:[productModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];
}

- (void)setProductModel:(NSString *)cover withNeedRadian:(BOOL)isNeedRadian {
    self.layer.cornerRadius = isNeedRadian ? 4 : 0;
    self.setLabelsView.hidden = YES;
    
    [self.cellImageView loadImageWithUrl:[cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];
}

@end
