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
#import "NSString+Helper.h"

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
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    self.productNameLabel.text = productModel.name;
    
    if (productModel.min_sale_price == 0) {
        
        if (productModel.like_count == 0) {
            self.producrOriginalPriceLabel.hidden = YES;
        } else {
            self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
        }
        
        self.productPriceLabel.text = [NSString formatFloat:productModel.min_price];
        self.likeCountLabel.hidden = YES;
    } else{
        self.productPriceLabel.text = [NSString formatFloat:productModel.min_sale_price];
        self.producrOriginalPriceLabel.attributedText = [THNTextTool setStrikethrough:productModel.min_price];
        
          if (productModel.commission_price == 0) {
              self.likeCountLabel.hidden = YES;
          } else {
              self.likeCountLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
          }
        
    }
    
    
    if (!productModel.have_distributed) {
        self.shelfButton.backgroundColor = [UIColor colorWithHexString:@"2D343A"];
        [self.shelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shelfButton setTitle:@"上架" forState:UIControlStateNormal];
        self.shelfButton.enabled = YES;
    } else {
        self.shelfButton.enabled = NO;
        self.shelfButton.backgroundColor = [UIColor colorWithHexString:@"EFF3F2"];
        [self.shelfButton setTitle:@"已上架" forState:UIControlStateNormal];
        [self.shelfButton setTitleColor:[UIColor colorWithHexString:@"949EA6"] forState:UIControlStateNormal];
    }
    
    self.amountMoneyLabel.text = [NSString formatFloat:productModel.commission_price];
    
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
