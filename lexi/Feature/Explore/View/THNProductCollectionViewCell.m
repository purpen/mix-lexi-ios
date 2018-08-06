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

@interface THNProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@end

@implementation THNProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
    
}

- (void)thn_setProductModel:(THNProductModel *)model {
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.productNameLabel.text = model.name;
    self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",model.min_sale_price];
}

//- (void)setProductMode:(THNProductModel *)productModel {
//    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
//    self.productNameLabel.text = productModel.name;
//    self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_sale_price];
//}

@end
