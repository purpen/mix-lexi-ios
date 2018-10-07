//
//  THNOrderProductTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderProductTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "THNOrdersItemsModel.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

@interface THNOrderProductTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProductCountLabel;

@end


@implementation THNOrderProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self borderButtonStyle];
}

- (void)setItemModel:(THNOrdersItemsModel *)itemModel {
    _itemModel = itemModel;
   [self.productImageView sd_setImageWithURL:[NSURL URLWithString:itemModel.cover]];
    self.productNameLabel.text = itemModel.product_name;
    self.ProductCountLabel.text = [NSString stringWithFormat:@"x%ld", itemModel.quantity];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 15;
    frame.size.height -= 15;
    [super setFrame:frame];
}

// 边框按钮样式
- (void)borderButtonStyle {
    [self.borderButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    self.borderButton.layer.borderWidth = 1;
    self.borderButton.layer.cornerRadius = 8;
    self.borderButton.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
    self.borderButton.backgroundColor = [UIColor whiteColor];
    [self.borderButton setTitle:@"物流追踪" forState:UIControlStateNormal];
}

@end
