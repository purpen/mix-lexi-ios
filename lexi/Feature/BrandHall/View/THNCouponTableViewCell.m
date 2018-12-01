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
#import "THNAPI.h"
#import "THNConst.h"
#import "THNSaveTool.h"
#import "THNMarco.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SVProgressHUD+Helper.h"

static NSString *const kUrlCouponsGrant = @"/market/coupons/grant";

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
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveLabelXConstraint;

@end

@implementation THNCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
       self.receiveLabelXConstraint.constant = 5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCouponModel:(THNCouponModel *)couponModel {
    _couponModel = couponModel;
    // 0、未领取 1、已领取
    if (self.couponModel.status == 0) {
        self.moneyMarkLabel.textColor = [UIColor colorWithHexString:@"FF6934"];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"FF6934"];
        self.restrictionPromptLabel.textColor = [UIColor colorWithHexString:@"5FE4B1"];
        self.validityPeriodLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.backgroundImageView.image = [UIImage imageNamed:@"icon_coupon_background_unaccalimed"];
        self.receiveTitleLabel.text = @"领取";
        self.receiveButton.enabled = YES;
    } else {
        [self receivedStyle];
    }
    
    self.moneyLabel.text = [[NSString formatFloat:couponModel.amount] substringFromIndex:1];
    self.restrictionPromptLabel.text = [NSString stringWithFormat:@"满%.2f使用", couponModel.min_amount];
    NSString *startDate = [NSString timeConversion:couponModel.start_date initWithFormatterType:FormatterDay];
    NSString *endDate = [NSString timeConversion:couponModel.end_date initWithFormatterType:FormatterDay];
    self.validityPeriodLabel.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
}

// 已领取优惠券样式
- (void)receivedStyle {
    self.moneyMarkLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.moneyLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.restrictionPromptLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.validityPeriodLabel.textColor = [UIColor colorWithHexString:@"B2B2B2"];
    self.backgroundImageView.image = [UIImage imageNamed:@"icon_coupon_background_received"];
    self.receiveTitleLabel.text = @"已领取";
    self.receiveButton.enabled = NO;
}

// 调用领取优惠券接口
- (void)receiveCoupon {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.couponModel.code;
    params[@"store_rid"] = [THNSaveTool objectForKey:kBrandHallRid];
    THNRequest *request = [THNAPI postWithUrlString:kUrlCouponsGrant requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        self.couponModel.status = 1;
        [self receivedStyle];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)receive:(id)sender {
    [self receiveCoupon];
}

@end
