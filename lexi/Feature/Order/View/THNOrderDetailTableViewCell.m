//
//  THNOrderDetailTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/9/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailTableViewCell.h"
#import "UIView+Helper.h"

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
// 物流信息的View
@property (weak, nonatomic) IBOutlet UIView *logisticsView;

@end

@implementation THNOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.logisticsButton drawCornerWithType:0 radius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
