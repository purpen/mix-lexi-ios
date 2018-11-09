//
//  THNOrderPayTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/10/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderPayTableViewCell.h"
#import "THNOrderPayModel.h"
#import "NSString+Helper.h"

@interface THNOrderPayTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPayAmountLabel;

@end

@implementation THNOrderPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderPayModel:(THNOrderPayModel *)orderPayModel {
    _orderPayModel = orderPayModel;
    self.storeNameLabel.text = orderPayModel.store_name;
    self.productCountLabel.text = [NSString stringWithFormat:@"共%ld件",orderPayModel.total_quantity];
    self.totalPayAmountLabel.text = [NSString formatFloat:orderPayModel.user_pay_amount];
}

@end
