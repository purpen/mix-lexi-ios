//
//  THNMyCouponTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNMyCouponTableViewCell.h"
#import "UIColor+Extension.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import "UIImageView+SDWedImage.h"
#import "UIView+Helper.h"

static NSString *const kTextUse     = @"去\n使\n用";
static NSString *const kTextUseType = @" 全场通用";

@interface THNMyCouponTableViewCell ()

@property (nonatomic, strong) UIImageView *couponImageView;
@property (nonatomic, strong) YYLabel *amountLabel;
@property (nonatomic, strong) YYLabel *conditionLabel;
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) UIImageView *storeIconImageView;
@property (nonatomic, strong) YYLabel *storeLabel;
@property (nonatomic, strong) YYLabel *typeLabel;
@property (nonatomic, strong) YYLabel *useLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, assign) THNUserCouponType couponType;

@end

@implementation THNMyCouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(THNUserCouponType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.couponType = type;
        
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setMyBrandCouponInfoData:(THNCouponDataModel *)model {
    [self thn_reloadCellViewWithType:(THNUserCouponTypeBrand)];
    [self thn_setCouponBackgroundImage:@"icon_coupon_brand"];
    [self thn_setUseLabelTextWithType:(THNUserCouponTypeBrand)];
    
    THNCouponModel *infoModel = [THNCouponModel mj_objectWithKeyValues:model.coupon];
    
    [self thn_setAmountLabelTextWithValue:infoModel.amount minAmount:infoModel.min_amount];
    [self thn_setTimeLabelTextWithStartTime:model.get_at endTime:model.end_at type:(THNUserCouponTypeBrand)];
    [self thn_setStoreLabelTextWithName:model.store_name logoUrl:model.store_logo];
}

- (void)thn_setMyOfficialCouponInfoData:(THNCouponModel *)model {
    [self thn_reloadCellViewWithType:(THNUserCouponTypeOfficial)];
    [self thn_setCouponBackgroundImage:@"icon_coupon_official"];
    [self thn_setUseLabelTextWithType:(THNUserCouponTypeOfficial)];
    
    [self thn_setAmountLabelTextWithValue:model.amount minAmount:model.min_amount];
    [self thn_setTimeLabelTextWithStartTime:model.start_at endTime:model.expired_at type:(THNUserCouponTypeOfficial)];
    [self thn_setTypeLabelTextWithText:kTextUseType type:(THNUserCouponTypeOfficial)];
    [self thn_setSourceLabelTextWithText:[self thn_getCouponSourceTextType:model.source]];
}

- (void)thn_setMyFailCouponInfoData:(THNCouponModel *)model {
    THNUserCouponType couponType = (THNUserCouponType)(model.type - 1);
    
    [self thn_reloadCellViewWithType:couponType];
    NSArray *images = @[@"icon_coupon_brand_fail", @"icon_coupon_official_fail"];
    [self thn_setCouponBackgroundImage:images[(NSUInteger)couponType]];
    [self thn_setUseLabelTextWithType:(THNUserCouponTypeFail)];
    
    [self thn_setAmountLabelTextWithValue:model.amount minAmount:model.min_amount];
    [self thn_setTimeLabelTextWithStartTime:model.start_at endTime:model.expired_at type:(THNUserCouponTypeFail)];
    
    if (couponType == THNUserCouponTypeBrand) {
        [self thn_setStoreLabelTextWithName:model.store_name logoUrl:model.store_logo];
        
    } else if (couponType == THNUserCouponTypeOfficial) {
        [self thn_setTypeLabelTextWithText:kTextUseType type:(THNUserCouponTypeFail)];
        [self thn_setSourceLabelTextWithText:[self thn_getCouponSourceTextType:model.source]];
    }
}

#pragma mark - private methods
// 背景图片
- (void)thn_setCouponBackgroundImage:(NSString *)imageName {
    self.couponImageView.image = [UIImage imageNamed:imageName];
}

// 去使用
- (void)thn_setUseLabelTextWithType:(THNUserCouponType)type {
    NSArray *colors = @[@"#FF733B", @"#DAB867", @"#B8B8B8"];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextUse];
    att.color = [UIColor colorWithHexString:colors[(NSUInteger)type]];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    att.lineSpacing = 2;
    
    self.useLabel.attributedText = att;
}

// 优惠券金额
- (void)thn_setAmountLabelTextWithValue:(CGFloat)value minAmount:(CGFloat)minAmount {
    NSMutableAttributedString *yuanAtt = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    yuanAtt.color = [UIColor colorWithHexString:@"#FFFFFF"];
    yuanAtt.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightSemibold)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", value]];
    att.color = [UIColor colorWithHexString:@"#FFFFFF"];
    att.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightBold)];
    
    [att insertAttributedString:yuanAtt atIndex:0];
    att.alignment = NSTextAlignmentCenter;
    
    self.amountLabel.attributedText = att;
    self.conditionLabel.text = [NSString stringWithFormat:@"满%.0f元使用", minAmount];
}

// 品牌信息
- (void)thn_setStoreLabelTextWithName:(NSString *)name logoUrl:(NSString *)logoUrl {
    [self.storeIconImageView downloadImage:[logoUrl loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                     place:[UIImage imageNamed:@"default_image_place"]];
    self.storeIconImageView.hidden = NO;
    
    self.storeLabel.text = name;
    self.storeLabel.hidden = NO;
}

// 时间
- (void)thn_setTimeLabelTextWithStartTime:(NSString *)startTime endTime:(NSString *)endTime type:(THNUserCouponType)type {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTime doubleValue]];
    NSString *startStr = [startDate formattedDateWithFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]];
    NSString *endStr = [endDate formattedDateWithFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [NSString stringWithFormat:@"%@至%@", startStr, endStr];
    
    NSArray *images = @[@"icon_coupon_diamond", @"icon_officalCoupon_diamond", @"icon_coupon_fail_diamond"];
    NSString *iconName = images[(NSUInteger)type];
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:iconName]
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(12, 12)
                                                                                    alignToFont:[UIFont systemFontOfSize:11]
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:timeStr];
    att.color = [UIColor colorWithHexString:@"#999999"];
    att.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
    
    [att insertAttributedString:iconAtt atIndex:0];
    self.timeLabel.attributedText = att;
}

// 使用类型
- (void)thn_setTypeLabelTextWithText:(NSString *)text type:(THNUserCouponType)type {
    UILabel *iconLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 33, 13)];
    iconLable.backgroundColor = [UIColor colorWithHexString:type == THNUserCouponTypeOfficial ? @"#DAB867" : @"#B2B2B2"];
    iconLable.text = @"乐喜券";
    iconLable.textColor = [UIColor colorWithHexString:@"#FFFCFB"];
    iconLable.font = [UIFont systemFontOfSize:10];
    iconLable.textAlignment = NSTextAlignmentCenter;
    [iconLable drawCornerWithType:(UILayoutCornerRadiusAll) radius:2];
    
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:iconLable
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(33, 13)
                                                                                    alignToFont:[UIFont systemFontOfSize:12]
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.color = [UIColor colorWithHexString:type == THNUserCouponTypeOfficial ? @"#333333" : @"#999999"];
    att.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [att insertAttributedString:iconAtt atIndex:0];
    self.typeLabel.attributedText = att;
    self.typeLabel.hidden = NO;
}

// 优惠券来源
- (void)thn_setSourceLabelTextWithText:(NSString *)text {
    self.sourceLabel.text = text;
    self.sourceLabel.hidden = NO;
}

- (NSString *)thn_getCouponSourceTextType:(NSInteger)type {
    NSDictionary *sourceTextData = @{@(1): @"分享领红包",
                                     @(2): @"猜图赢现金",
                                     @(3): @"赠送",
                                     @(4): @"新人奖励",
                                     @(11): @"领券中心"};
    
    return sourceTextData[@(type)];
}

// 刷新视图
- (void)thn_reloadCellViewWithType:(THNUserCouponType)type {
    BOOL reloadView = type == THNUserCouponTypeBrand;
    
    self.storeIconImageView.hidden = !reloadView;
    self.storeLabel.hidden = !reloadView;
    
    self.typeLabel.hidden = reloadView;
    self.sourceLabel.hidden = reloadView;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.couponImageView];
    [self addSubview:self.useLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.conditionLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.storeIconImageView];
    [self addSubview:self.storeLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.sourceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 48));
        make.right.mas_equalTo(-34);
        make.centerY.equalTo(self.couponImageView);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 32));
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(19);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 15));
        make.left.mas_equalTo(30);
        make.top.equalTo(self.amountLabel.mas_bottom).with.offset(5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 12));
        make.left.mas_equalTo(158);
        make.top.mas_equalTo(21);
    }];
    
    [self.storeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(158);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(13);
    }];
    
    [self.storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.equalTo(self.storeIconImageView.mas_right).with.offset(5);
        make.right.mas_equalTo(-90);
        make.centerY.equalTo(self.storeIconImageView);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.left.mas_equalTo(158);
        make.right.mas_equalTo(-90);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(9);
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.left.mas_equalTo(158);
        make.right.mas_equalTo(-90);
        make.top.equalTo(self.typeLabel.mas_bottom).with.offset(9);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)couponImageView {
    if (!_couponImageView) {
        _couponImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, 85)];
        _couponImageView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.4].CGColor;
        _couponImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _couponImageView.layer.shadowRadius = 5;
        _couponImageView.layer.shadowOpacity = 0.1;
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
        _conditionLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _conditionLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
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

- (UIImageView *)storeIconImageView {
    if (!_storeIconImageView) {
        _storeIconImageView = [[UIImageView alloc] init];
        _storeIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeIconImageView.layer.cornerRadius = 3;
        _storeIconImageView.layer.borderWidth = 0.5;
        _storeIconImageView.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        _storeIconImageView.layer.masksToBounds = YES;
        _storeIconImageView.hidden = YES;
    }
    return _storeIconImageView;
}

- (YYLabel *)storeLabel {
    if (!_storeLabel) {
        _storeLabel = [[YYLabel alloc] init];
        _storeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _storeLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _storeLabel.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
        _storeLabel.hidden = YES;
    }
    return _storeLabel;
}

- (YYLabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[YYLabel alloc] init];
        _typeLabel.hidden = YES;
    }
    return _typeLabel;
}

- (YYLabel *)sourceLabel {
    if (!_sourceLabel) {
        _sourceLabel = [[YYLabel alloc] init];
        _sourceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _sourceLabel.font = [UIFont systemFontOfSize:10 weight:(UIFontWeightRegular)];
        _sourceLabel.hidden = YES;
    }
    return _sourceLabel;
}

- (YYLabel *)useLabel {
    if (!_useLabel) {
        _useLabel = [[YYLabel alloc] init];
        _useLabel.numberOfLines = 0;
    }
    return _useLabel;
}

@end
