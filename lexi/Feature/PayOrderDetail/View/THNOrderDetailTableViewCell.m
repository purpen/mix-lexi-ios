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
#import "UIImageView+WebImage.h"
#import "THNSkuModelItem.h"
#import "THNFreightModelItem.h"
#import "THNTextTool.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "NSString+Helper.h"

NSString *const kSelectDelivery = @"kSelectDelivery";

@interface THNOrderDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *deliveryDesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UIView *deliveryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logisticsViewHeightConstraint;

@end

@implementation THNOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.logisticsButton drawCornerWithType:0 radius:4];
    self.productImageView.layer.masksToBounds = YES;
}

// 订单详情
- (void)setItemsModel:(THNOrdersItemsModel *)itemsModel {
    _itemsModel = itemsModel;
    
    [self.productImageView loadImageWithUrl:[itemsModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    self.productNameLabel.text = itemsModel.product_name;
    self.productCountLabel.text = [NSString stringWithFormat:@"x%ld", itemsModel.quantity];
    
    if (itemsModel.sale_price == 0) {
        self.saleMoneyLabel.text = [NSString formatFloat:itemsModel.price];
        self.originalMoneyLabel.hidden = YES;
    } else {
        self.originalMoneyLabel.hidden = NO;
        self.saleMoneyLabel.text = [NSString formatFloat:itemsModel.sale_price];
        self.originalMoneyLabel.attributedText = [THNTextTool setStrikethrough:itemsModel.price];
    }
    
    self.modeLabel.text = itemsModel.mode;
    self.deliveryMethodLabel.text = itemsModel.express_name;
    self.deliveryView.hidden = YES;
}

- (void)setPaySuccessProductView:(THNOrdersItemsModel *)itemsModel {
    [self.productImageView loadImageWithUrl:[itemsModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    self.productNameLabel.text = itemsModel.product_name;
    self.productCountLabel.text = [NSString stringWithFormat:@"x%ld", itemsModel.quantity];
    
    if (itemsModel.sale_price == 0) {
        self.saleMoneyLabel.text = [NSString formatFloat:itemsModel.price];
        self.originalMoneyLabel.hidden = YES;
    } else {
        self.originalMoneyLabel.hidden = NO;
        self.saleMoneyLabel.text = [NSString formatFloat:itemsModel.sale_price];
        self.originalMoneyLabel.attributedText = [THNTextTool setStrikethrough:itemsModel.price];
    }
    
    self.modeLabel.text = itemsModel.mode;
    self.deliveryMethodLabel.text = itemsModel.express_name;
    self.deliveryView.hidden = YES;
    self.logisticsView.hidden = YES;
    self.logisticsViewHeightConstraint.constant = 0;
}

// 提交订单界面
- (void)setSkuItemModel:(THNSkuModelItem *)skuItemModel {
    _skuItemModel = skuItemModel;
    
    [self.productImageView loadImageWithUrl:[skuItemModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    self.productNameLabel.text = skuItemModel.productName;
    if (skuItemModel.salePrice == 0) {
        self.saleMoneyLabel.text = [NSString formatFloat:skuItemModel.price];
        self.originalMoneyLabel.hidden = YES;
    } else {
        self.originalMoneyLabel.hidden = NO;
        self.saleMoneyLabel.text = [NSString formatFloat:skuItemModel.salePrice];
        self.originalMoneyLabel.attributedText = [THNTextTool setStrikethrough:skuItemModel.price];
    }
    self.modeLabel.text = skuItemModel.mode;
    self.logisticsButton.hidden = YES;
    self.deliveryDesLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.deliveryDesLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
}

- (void)setFreightModel:(THNFreightModelItem *)freightModel {
    _freightModel = freightModel;
    self.deliveryMethodLabel.text = freightModel.expressName;
    self.logisticsTimeLabel.text = [NSString stringWithFormat:@"%ld至%ld天送达",(long)freightModel.minDays,(long)freightModel.maxDays];
}

// 物流跟踪
- (IBAction)logisticsTracking:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderDetailLogisticsTracking object:nil userInfo:@{@"itemModel":self.itemsModel}];
}

// 选择配送方式
- (IBAction)selectDelivery:(id)sender {
    self.selectDeliveryBlcok(self.skuItemModel.fid);
//    [[NSNotificationCenter defaultCenter]postNotificationName:kSelectDelivery object:nil userInfo:@{@"selectProducIndex":@(self.tag), @"selectStoreIndex":@(self.superview.tag)}];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 15;
    frame.size.height -= 15;
    [super setFrame:frame];
}


@end
