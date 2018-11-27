//
//  THNLifeCountdownView.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCountdownView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "THNConst.h"
#import "THNMarco.h"
#import "NSString+Helper.h"
#import "THNCountdown.h"
#import <DateTools/DateTools.h>

static NSString *const kTextCountdown = @"实习倒计时";
// 实习的天数
static NSInteger const maxDay = 30;

@interface THNLifeCountdownView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) THNCountdown *countdown;

@end

@implementation THNLifeCountdownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeStoreCreatedAt:(NSString *)createdAt {
    WEAKSELF;
    
    NSString *endTime = [self thn_getEndTimestampWithCreatedAt:createdAt];
    [self.countdown thn_countDownWithStratTimeStamp:[self thn_longLongFromDate:[NSString getTimestamp]]
                                    finishTimeStamp:[self thn_longLongFromDate:endTime]
                                      completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                                          weakSelf.dayLabel.text = [NSString stringWithFormat:@"%zi", day];
                                          weakSelf.hourLabel.text = [NSString stringWithFormat:@"%zi", hour];
                                          weakSelf.minuteLabel.text = [NSString stringWithFormat:@"%zi", minute];
                                          weakSelf.secondLabel.text = [NSString stringWithFormat:@"%zi", second];
                                      }];
}

#pragma mark - private methods
- (void)thn_creatTimeTextLabel {
    NSArray *timeTexts = @[@"天", @"时", @"分", @"秒"];
    
    for (NSUInteger idx = 0; idx < timeTexts.count; idx ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(89 + 41 * idx, (CGRectGetHeight(self.frame) - 20) /2, 17, 20)];
        textLabel.textColor = [UIColor colorWithHexString:idx == 0 ? kColorMain : @"#FFFFFF"];
        textLabel.font = [UIFont systemFontOfSize:8];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = timeTexts[idx];
        
        [self addSubview:textLabel];
    }
}

// 结束的日期
- (NSString *)thn_getEndTimestampWithCreatedAt:(NSString *)createdAt {
    NSDate *startDate = [self thn_getDateWithTimestamp:createdAt];
    NSDate *endDate = [startDate dateByAddingDays:maxDay];
    NSInteger timeSp = [[NSNumber numberWithDouble:[endDate timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat:@"%zi", timeSp];
}

// string 转 date
- (NSDate *)thn_getDateWithTimestamp:(NSString *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    
    return date;
}

// date 转 string
- (NSString *)thn_getTimestampWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:date];
}

- (long long)thn_longLongFromDate:(NSString *)timestamp {
    NSDate *date = [self thn_getDateWithTimestamp:timestamp];
    
    return [date timeIntervalSince1970] * 1000;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    [self addSubview:self.secondLabel];
    [self thn_creatTimeTextLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
        _titleLabel.text = kTextCountdown;
    }
    return _titleLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame: \
                     CGRectMake(65, (CGRectGetHeight(self.frame) - 20) / 2, 24, 20)];
        _dayLabel.layer.cornerRadius = 4;
        _dayLabel.layer.masksToBounds = YES;
        _dayLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        _dayLabel.textColor = [UIColor colorWithHexString:kColorMain];
        _dayLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}

- (UILabel *)hourLabel {
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] initWithFrame: \
                      CGRectMake(CGRectGetMaxX(self.dayLabel.frame) + 17, (CGRectGetHeight(self.frame) - 20) / 2, 24, 20)];
        _hourLabel.layer.cornerRadius = 4;
        _hourLabel.layer.masksToBounds = YES;
        _hourLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        _hourLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _hourLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hourLabel;
}

- (UILabel *)minuteLabel {
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc] initWithFrame: \
                        CGRectMake(CGRectGetMaxX(self.hourLabel.frame) + 17, (CGRectGetHeight(self.frame) - 20) / 2, 24, 20)];
        _minuteLabel.layer.cornerRadius = 4;
        _minuteLabel.layer.masksToBounds = YES;
        _minuteLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        _minuteLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _minuteLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _minuteLabel;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] initWithFrame: \
                        CGRectMake(CGRectGetMaxX(self.minuteLabel.frame) + 17, (CGRectGetHeight(self.frame) - 20) / 2, 24, 20)];
        _secondLabel.layer.cornerRadius = 4;
        _secondLabel.layer.masksToBounds = YES;
        _secondLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        _secondLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _secondLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondLabel;
}


- (THNCountdown *)countdown {
    if (!_countdown) {
        _countdown = [[THNCountdown alloc] init];
    }
    return _countdown;
}

#pragma mark -
- (void)dealloc {
    [self.countdown destoryTimer];
}

@end
