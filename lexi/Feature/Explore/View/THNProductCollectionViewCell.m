//
//  THNProductCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNProductCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"
#import "THNProductModel.h"
#import "THNTextTool.h"

@interface THNProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *producrOriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shippingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *sallOutImageView;

@end

@implementation THNProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
}

- (void)setProductModel:(THNProductModel *)productModel initWithType:(THNHomeType)homeType {
    
    if (homeType == THNHomeTypeFeatured) {
        self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
    } else {
        self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"%.2f",productModel.min_price];
        self.producrOriginalPriceLabel.attributedText = [THNTextTool setStrikethrough:productModel.min_price];
    }
    
    if (productModel.is_free_postage) {
        self.shippingImageView.hidden = NO;
    } else {
        self.shippingImageView.hidden = YES;
        self.nameLabelLeftConstraint.constant = -20;
    }
    
    self.sallOutImageView.hidden = !productModel.is_sold_out;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
    self.productNameLabel.text = productModel.name;
    
    if (productModel.min_sale_price == 0) {
        self.producrOriginalPriceLabel.hidden = YES;
        self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_price];
    } else{
        self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_sale_price];
    }
}

@end
