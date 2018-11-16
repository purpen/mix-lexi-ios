//
//  THNBrandHallFeaturedCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallFeaturedCollectionViewCell.h"
#import "UIImageView+WebImage.h"
#import "THNFeaturedBrandModel.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

@interface THNBrandHallFeaturedCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountTextLabel;

@end

@implementation THNBrandHallFeaturedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.brandImageView drawCornerWithType:0 radius:4];
    self.brandImageView.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    self.brandImageView.layer.borderWidth = 1;
    self.brandImageView.layer.cornerRadius = 4;
    self.brandImageView.layer.masksToBounds = YES;
}

- (void)setBrandModel:(THNFeaturedBrandModel *)brandModel {
    _brandModel = brandModel;

    [self.brandImageView loadImageWithUrl:[brandModel.logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    self.nameLabel.text = brandModel.name;
    self.productCountTextLabel.text = [NSString stringWithFormat:@"%ld件商品",brandModel.store_products_counts];
}

@end
