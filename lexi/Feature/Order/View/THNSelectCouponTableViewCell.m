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

@interface THNSelectCouponTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
// 限制金额提示Label
@property (weak, nonatomic) IBOutlet UILabel *restrictionPromptLabel;
// 有效期
@property (weak, nonatomic) IBOutlet UILabel *validityPeriodLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation THNSelectCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectButton.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self drwaShadow];
}

- (void)setCouponModel:(THNCouponModel *)couponModel {
    _couponModel = couponModel;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", couponModel.amount];
    self.restrictionPromptLabel.text = [NSString stringWithFormat:@"满%.2f使用", couponModel.min_amount];
    NSString *startDate = [NSString timeConversion:couponModel.start_date initWithFormatterType:FormatterDay];
    NSString *endDate = [NSString timeConversion:couponModel.end_date initWithFormatterType:FormatterDay];
    self.validityPeriodLabel.text = [NSString stringWithFormat:@"有效期%@至%@",startDate,endDate];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 15;
    frame.size.height -= 15;
    [super setFrame:frame];
}

#pragma mark - getters and setters
- (void)setSelected:(BOOL)selected {
    self.selectButton.selected = selected;
}

@end
