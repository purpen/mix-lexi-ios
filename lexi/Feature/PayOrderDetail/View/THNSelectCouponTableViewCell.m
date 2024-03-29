//
//  THNSelectCouponTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectCouponTableViewCell.h"
#import "THNCouponModel.h"
#import "NSString+Helper.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

@interface THNSelectCouponTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
// 限制金额提示Label
@property (weak, nonatomic) IBOutlet UILabel *restrictionPromptLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *diamondImageView;

@end

@implementation THNSelectCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectButton.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self drawShadow:1.0];
}


- (void)setCouponModel:(THNCouponModel *)couponModel {
    _couponModel = couponModel;
    
    if (self.couponType == CouponTypeStore) {
        self.backGroundImageView.image = [UIImage imageNamed:@"icon_coupon_select"];
        self.diamondImageView.image = [UIImage imageNamed:@"icon_coupon_diamond"];
        self.restrictionPromptLabel.textColor = [UIColor colorWithHexString:@"FF6934"];
    } else {
        self.backGroundImageView.image = [UIImage imageNamed:@"icon_officalCoupon_select"];
        self.diamondImageView.image = [UIImage imageNamed:@"icon_officalCoupon_diamond"];
        self.restrictionPromptLabel.textColor = [UIColor colorWithHexString:@"DAB867"];
        NSString *startDate = [NSString timeConversion:couponModel.start_at initWithFormatterType:FormatterDay];
        NSString *endDate = [NSString timeConversion:couponModel.expired_at initWithFormatterType:FormatterDay];
        self.validityPeriodLabel.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
    }
    
    self.moneyLabel.text = [[NSString formatFloat:couponModel.amount] substringFromIndex:1];
    self.restrictionPromptLabel.text = [NSString stringWithFormat:@"满%@使用", [NSString formatFloat:couponModel.min_amount]];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 15;
    frame.size.height -= 15;
    [super setFrame:frame];
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.selectButton.selected = isSelect;
}



@end
