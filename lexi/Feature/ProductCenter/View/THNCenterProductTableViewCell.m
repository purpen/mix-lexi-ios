//
//  THNCenterProductTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCenterProductTableViewCell.h"
#import "THNProductModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"

@interface THNCenterProductTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *producrOriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shippingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sallOutImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *shelfButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;

@end

@implementation THNCenterProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shelfButton.layer.cornerRadius = 4;
    self.sellButton.layer.cornerRadius = 4;
}

- (void)setProductModel:(THNProductModel *)productModel {
 
    self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
    
    self.sallOutImageView.hidden = !productModel.is_sold_out;
//    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
    self.productNameLabel.text = productModel.name;
    
    if (productModel.min_sale_price == 0) {
        self.producrOriginalPriceLabel.hidden = YES;
        self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_price];
    } else{
        self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_sale_price];
    }
}
- (IBAction)sell:(id)sender {
    
}
- (IBAction)shelf:(id)sender {
    
}

@end
