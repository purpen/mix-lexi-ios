//
//  THNOrderDetailPayView.m
//  mixcash
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailPayView.h"
#import "THNOrderDetailModel.h"

@interface THNOrderDetailPayView()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payMethodImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end

@implementation THNOrderDetailPayView

- (void)setDetailModel:(THNOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.orderNumberLabel.text = detailModel.outside_target_id;
    self.payMethodLabel.text = @"微信在线支付";
    self.payMethodImageView.image = [UIImage imageNamed:@"icon_order_wechat"];
    self.subtotalLabel.text = [NSString stringWithFormat:@"¥%.2f",detailModel.total_amount];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",detailModel.pay_amount];
    
    if (detailModel.freight == 0) {
        self.deliveryMethodLabel.text  = @"包邮";
    } else {
        self.deliveryMethodLabel.text = [NSString stringWithFormat:@"¥%.2f",detailModel.freight];
    }
}

@end
