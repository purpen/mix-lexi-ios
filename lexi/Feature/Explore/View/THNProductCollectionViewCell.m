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
#import "NSString+Helper.h"
#import "UIColor+Extension.h"

@interface THNProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *producrOriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shippingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *sallOutImageView;
@property (weak, nonatomic) IBOutlet UIView *centerButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonViewComstraint;
@property (weak, nonatomic) IBOutlet UIButton *shelfButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UILabel *amountMoneyLabel;

@end

@implementation THNProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
    self.shelfButton.layer.cornerRadius = self.shelfButton.viewHeight / 2;
    self.sellButton.layer.cornerRadius = self.sellButton.viewHeight / 2;
}

- (void)setProductModel:(THNProductModel *)productModel initWithType:(THNHomeType)homeType {

    switch (homeType) {
        case THNHomeTypeExplore: {
            self.centerButtonViewComstraint.constant = 0;
            self.centerButtonView.hidden = YES;
            [self setProductAttributes:productModel.min_sale_price initWithOriginPrice:productModel.min_price initWithLikeCount:productModel.like_count];
            break;
        }
        case THNHomeTypeFeatured: {
            self.centerButtonViewComstraint.constant = 0;
            self.centerButtonView.hidden = YES;
            [self setProductAttributes:productModel.min_sale_price initWithOriginPrice:productModel.min_price initWithLikeCount:productModel.like_count];
            break;
        }
        case THNHomeTypeCenter:{
            self.centerButtonViewComstraint.constant = 52;
            self.centerButtonView.hidden = NO;
            self.amountMoneyLabel.text = [NSString formatFloat:productModel.commission_price];
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

           [self setProductAttributes:productModel.real_sale_price initWithOriginPrice:productModel.real_price initWithLikeCount:productModel.like_count];

            break;
        }

        case THNHomeTypeBrandHall: {
            self.centerButtonViewComstraint.constant = 0;
            self.centerButtonView.hidden = YES;
            self.producrOriginalPriceLabel.hidden = YES;
            [self setProductAttributes:productModel.min_sale_price initWithOriginPrice:productModel.min_price initWithLikeCount:productModel.like_count];
            break;
        }
    }
    

    if (productModel.is_free_postage) {
        self.shippingImageView.hidden = NO;
        self.nameLabelLeftConstraint.constant = 5;
    } else {
        self.shippingImageView.hidden = YES;
        self.nameLabelLeftConstraint.constant = -20;
    }

    self.sallOutImageView.hidden = !productModel.is_sold_out;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    self.productNameLabel.text = productModel.name;
}

- (void)setProductAttributes:(CGFloat)salePrice
         initWithOriginPrice:(CGFloat)originPrice
           initWithLikeCount:(NSInteger)likeCount {
    if (salePrice == 0 && likeCount == 0) {
        self.productPriceLabel.text = [NSString formatFloat:originPrice];
        self.producrOriginalPriceLabel.hidden = YES;
        self.likeCountLabel.hidden = YES;
    } else if (salePrice == 0) {
        self.likeCountLabel.hidden = YES;
        self.producrOriginalPriceLabel.hidden = NO;
        self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",likeCount];
        self.productPriceLabel.text = [NSString formatFloat:originPrice];
    } else if (likeCount == 0) {
        self.likeCountLabel.hidden = YES;
        self.producrOriginalPriceLabel.hidden = NO;
        self.productPriceLabel.text = [NSString formatFloat:salePrice];
        self.producrOriginalPriceLabel.attributedText = [THNTextTool setStrikethrough:originPrice];
    } else {
        self.producrOriginalPriceLabel.hidden = NO;
        self.likeCountLabel.hidden = NO;
        self.productPriceLabel.text = [NSString formatFloat:salePrice];
        self.producrOriginalPriceLabel.attributedText = [THNTextTool setStrikethrough:originPrice];
        self.likeCountLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",likeCount];
    }
}

- (IBAction)shelf:(id)sender {
    if (self.shelfBlock) {
       self.shelfBlock(self);
    }
}

- (IBAction)sell:(id)sender {
    
}
@end
