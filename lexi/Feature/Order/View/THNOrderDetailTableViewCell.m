//
//  THNOrderDetailTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/9/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailTableViewCell.h"
#import "UIView+Helper.h"
#import "THNOrdersItemsModel.h"
#import "UIImageView+WebCache.h"

@interface THNOrderDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
// 物流跟踪
@property (weak, nonatomic) IBOutlet UIButton *logisticsButton;
// 配送方式
@property (weak, nonatomic) IBOutlet UILabel *deliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UIView *deliveryView;
@property (weak, nonatomic) IBOutlet UIButton *selectDeliveryButton;
@property (weak, nonatomic) IBOutlet UILabel *logisticsTimeLabel;

@end

@implementation THNOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.logisticsButton drawCornerWithType:0 radius:4];
}

- (void)setItemsModel:(THNOrdersItemsModel *)itemsModel {
    _itemsModel = itemsModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:itemsModel.cover]];
    self.productNameLabel.text = itemsModel.product_name;
    self.productCountLabel.text = [NSString stringWithFormat:@"x%ld", itemsModel.quantity];
    self.saleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",itemsModel.sale_price];
    self.originalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",itemsModel.price];
    self.modeLabel.text = itemsModel.mode;
    self.deliveryMethodLabel.text = itemsModel.express_name;
}

// 物流跟踪
- (IBAction)logisticsTracking:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OrderDetailLogisticsTracking" object:nil userInfo:@{@"itemModel":self.itemsModel}];
}

// 选择配送方式
- (IBAction)selectDelivery:(id)sender {
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 15;
    frame.size.height -= 15;
    [super setFrame:frame];
}

@end
