//
//  THNBrandHallFeaturedCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallFeaturedCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "THNFeaturedBrandModel.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "UIView+Helper.h"

@interface THNBrandHallFeaturedCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountTextLabel;

@end

@implementation THNBrandHallFeaturedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.brandImageView drawCornerWithType:0 radius:4];
    
}

- (void)setBrandModel:(THNFeaturedBrandModel *)brandModel {
    _brandModel = brandModel;
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logo]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    self.nameLabel.text = brandModel.name;
    self.productCountTextLabel.text = [NSString stringWithFormat:@"%ld件商品",brandModel.store_products_counts];
}

@end