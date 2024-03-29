//
//  THNCenterProductTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCenterProductTableViewCell.h"
#import "THNProductModel.h"
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"
#import "THNTextTool.h"
#import "NSString+Helper.h"
#import "THNConst.h"

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIButton *seeDetailButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shippingImageViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *earnTextLabel;

@end

@implementation THNCenterProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.layer.cornerRadius = 4;
    self.productImageView.layer.masksToBounds = YES;
    self.shelfButton.layer.cornerRadius = self.shelfButton.viewHeight / 2;
    self.sellButton.layer.cornerRadius = self.sellButton.viewHeight / 2;
    self.seeDetailButton.layer.cornerRadius = 15;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setProductModel:(THNProductModel *)productModel {
    _productModel = productModel;
    
    if (self.isFromGrassList) {
        [self setProductAttributes:productModel.min_sale_price initWithOriginPrice:productModel.min_price initWithLikeCount:productModel.like_count];
        self.seeDetailButton.hidden = NO;
    } else {
        [self setProductAttributes:productModel.real_sale_price initWithOriginPrice:productModel.real_price initWithLikeCount:productModel.like_count];
        self.seeDetailButton.hidden = YES;
    }
    
    self.buttonView.hidden = self.isFromGrassList;
    self.amountMoneyLabel.hidden = self.isFromGrassList;
    self.earnTextLabel.hidden = self.isFromGrassList;
    
    self.shippingImageViewTopConstraint.constant = self.isFromGrassList ? 0 : 7;
    self.sallOutImageView.hidden = !productModel.is_sold_out;
    [self.productImageView loadImageWithUrl:[productModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];

    if (productModel.is_free_postage) {
        self.nameLabelLeftConstraint.constant = 5;
        self.shippingImageView.hidden = NO;
    } else {
        self.nameLabelLeftConstraint.constant = -20;
        self.shippingImageView.hidden = YES;
    }

    self.productNameLabel.text = productModel.name;
    
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

- (void)setCenterProductCell:(THNProductModel *)productModel
      withIsShowDetailButton:(BOOL)isShowDetailButton {
    
    
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
- (IBAction)seeProductDetail:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:THNGoodInfoVCSeeProductDetail
                                                        object:nil
                                                      userInfo:@{@"goodInfoRid" : self.productModel.rid}];
}

@end
