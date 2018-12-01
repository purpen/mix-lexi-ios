//
//  THNAdvertCouponTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertCouponTableViewCell.h"
#import "UIColor+Extension.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import "UIView+Helper.h"

/// 红包有效期
static NSInteger const kMaxCouponDay = 14;

@interface THNAdvertCouponTableViewCell ()

@property (nonatomic, strong) UIImageView *couponImageView;
@property (nonatomic, strong) YYLabel *amountLabel;
@property (nonatomic, strong) YYLabel *conditionLabel;
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) YYLabel *typeLabel;

@end

@implementation THNAdvertCouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setAdvertCouponAmount:(CGFloat)amount minAmount:(CGFloat)minAmount typeText:(NSString *)typeText {
    [self thn_setAmountLabelTextWithValue:amount minAmount:minAmount];
    [self thn_setTypeLabelTextWithText:typeText];
    [self thn_setTimeLabelText];
}

#pragma mark - private methods
// 优惠券金额
- (void)thn_setAmountLabelTextWithValue:(CGFloat)value minAmount:(CGFloat)minAmount {
    NSMutableAttributedString *yuanAtt = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    yuanAtt.color = [UIColor colorWithHexString:@"#363838"];
    yuanAtt.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", value]];
    att.color = [UIColor colorWithHexString:@"#363838"];
    att.font = [UIFont systemFontOfSize:32 weight:(UIFontWeightBold)];
    
    [att insertAttributedString:yuanAtt atIndex:0];
    att.alignment = NSTextAlignmentCenter;
    
    self.amountLabel.attributedText = att;
    self.conditionLabel.text = [NSString stringWithFormat:@"满%.0f元使用", minAmount];
}

// 时间
- (void)thn_setTimeLabelText {
    // 开始时间
    NSDate *startDate = [NSDate date];
    NSString *startTimeStr = [NSString stringWithFormat:@"%zi.%zi.%zi", startDate.year, startDate.month, startDate.day];
    
    // 结束时间
    NSDate *endDate = [startDate dateByAddingDays:kMaxCouponDay];
    NSString *endTimeStr = [NSString stringWithFormat:@"%zi.%zi.%zi", endDate.year, endDate.month, endDate.day];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ 至 %@", startTimeStr, endTimeStr];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:timeStr];
    att.color = [UIColor colorWithHexString:@"#666666"];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];

    self.timeLabel.attributedText = att;
}

// 使用类型
- (void)thn_setTypeLabelTextWithText:(NSString *)text {
    UILabel *iconLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 15)];
    iconLable.backgroundColor = [UIColor colorWithHexString:@"#FFE8AD"];
    iconLable.text = @"乐喜券";
    iconLable.textColor = [UIColor colorWithHexString:@"#595344"];
    iconLable.font = [UIFont systemFontOfSize:11];
    iconLable.textAlignment = NSTextAlignmentCenter;
    [iconLable drawCornerWithType:(UILayoutCornerRadiusAll) radius:2];
    
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:iconLable
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(33, 13)
                                                                                    alignToFont:[UIFont systemFontOfSize:12]
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", text]];
    att.color = [UIColor colorWithHexString:@"#333333"];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [att insertAttributedString:iconAtt atIndex:0];
    
    self.typeLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    
    [self addSubview:self.couponImageView];
    [self addSubview:self.amountLabel];
    [self addSubview:self.conditionLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.typeLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.couponImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(75);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 35));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 15));
        make.left.mas_equalTo(10);
        make.top.equalTo(self.amountLabel.mas_bottom).with.offset(5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(120);
        make.top.mas_equalTo(17);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(120);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(9);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)couponImageView {
    if (!_couponImageView) {
        _couponImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advert_coupon_cell"]];
        _couponImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _couponImageView;
}

- (YYLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[YYLabel alloc] init];
    }
    return _amountLabel;
}

- (YYLabel *)conditionLabel {
    if (!_conditionLabel) {
        _conditionLabel = [[YYLabel alloc] init];
        _conditionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _conditionLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _conditionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _conditionLabel;
}

- (YYLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc] init];
    }
    return _timeLabel;
}

- (YYLabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[YYLabel alloc] init];
    }
    return _typeLabel;
}

@end
