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
#import "YYLabel+Helper.h"
#import "THNTextTool.h"

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
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation THNCenterProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
    self.shelfButton.layer.cornerRadius = self.shelfButton.viewHeight / 2;
    self.sellButton.layer.cornerRadius = self.sellButton.viewHeight / 2;
}

- (void)setProductModel:(THNProductModel *)productModel {
 
    self.sallOutImageView.hidden = !productModel.is_sold_out;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
    self.productNameLabel.text = productModel.name;
    
    if (productModel.min_sale_price == 0) {
        
        if (productModel.like_count == 0) {
            self.producrOriginalPriceLabel.hidden = YES;
        } else {
            self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
        }
        
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f",productModel.min_price];
        self.likeCountLabel.hidden = YES;
    } else{
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f",productModel.min_sale_price];
        self.producrOriginalPriceLabel.attributedText = [THNTextTool setStrikethrough:productModel.min_price];
        
          if (productModel.commission_price == 0) {
              self.likeCountLabel.hidden = YES;
          } else {
              self.likeCountLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
          }
        
    }
    
    self.amountMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",productModel.commission_price];
    
}
- (IBAction)sell:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sell)]) {
        [self.delegate sell];
    }
}

- (IBAction)shelf:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shelf:)]) {
        [self.delegate shelf:self];
    }
}

@end
