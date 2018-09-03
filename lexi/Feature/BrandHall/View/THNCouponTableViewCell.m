//
//  THNCouponTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCouponTableViewCell.h"
#import "THNCouponModel.h"
#import "UIColor+Extension.h"
#import "NSString+Helper.h"
#import "UIView+Helper.h"

@interface THNCouponTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
// ¥样式
@property (weak, nonatomic) IBOutlet UILabel *moneyMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
// 限制金额提示Label
@property (weak, nonatomic) IBOutlet UILabel *restrictionPromptLabel;
// 有效期
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTitleLabel;

@end

@implementation THNCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCouponModel:(THNCouponModel *)couponModel {
    _couponModel = couponModel;
    // 0、未领取 1、已领取
    if (couponModel.status == 0) {
        self.moneyMarkLabel.textColor = [UIColor colorWithHexString:@"FF6934"];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"FF6934"];
        self.restrictionPromptLabel.textColor = [UIColor colorWithHexString:@"5FE4B1"];
        self.validityPeriodLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.backgroundImageView.image = [UIImage imageNamed:@"icon_coupon_background_unaccalimed"];
        self.receiveTitleLabel.text = @"分享领取";
    } else {
        self.moneyMarkLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.restrictionPromptLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.validityPeriodLabel.textColor = [UIColor colorWithHexString:@"B2B2B2"];
        self.backgroundImageView.image = [UIImage imageNamed:@"icon_coupon_background_received"];
        self.receiveTitleLabel.text = @"已领取";
        
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", couponModel.amount];
    self.restrictionPromptLabel.text = [NSString stringWithFormat:@"满%.2f使用", couponModel.min_amount];
    NSString *startDate = [NSString timeConversion:couponModel.start_date];
    NSString *endDate = [NSString timeConversion:couponModel.end_date];
    self.validityPeriodLabel.text = [NSString stringWithFormat:@"有效期%@至%@",startDate,endDate];
    
    
}

- (IBAction)receive:(id)sender {
    
}

@end
