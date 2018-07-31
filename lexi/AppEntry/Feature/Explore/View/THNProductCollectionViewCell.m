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

- (void)setOtherModel:(THNOtherModel *)otherModel {
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180702/3306FghyFReC2A0CWCUoZ4nTDV1KdhWT.jpg"]];
    self.productNameLabel.text = @"天使https://kg.erp.taihuoniao.com/20180702/3306FghyFReC2A0CWCUoZ4nTDV1KdhWT.jpg";
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥%@",@58];
}

@end
