//
//  THNCashInfoView.m
//  lexi
//
//  Created by FLYang on 2018/12/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashInfoView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import <DateTools/DateTools.h>
#import "THNCashHintView.h"

static NSString *const kTextTitle   = @"提现金额";
static NSString *const kTextSuccess = @"提现成功";
static NSString *const kTextLoding  = @"审核中";
static NSString *const kTextFailure = @"提现失败";
static NSString *const kTextMode    = @"提现方式";
static NSString *const kTextAccount = @"提现账号";
static NSString *const kTextTime    = @"提现时间";

@interface THNCashInfoView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) THNCashHintView *hintView;

@end

@implementation THNCashInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setWinCashInfoModel:(THNCashInfoModel *)model {
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", model.actualAmount];
    NSArray *statusArr = @[@"提现成功", @"提现失败", @"审核中"];
    self.statusLabel.text = statusArr[model.status - 1];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%zi", model.createdAt] doubleValue]];
    NSString *time = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSArray *cashMode = @[@"微信", @"支付宝"];
    [self thn_creatInfoTextWithData:@[cashMode[(model.receiveTarget - 1)], model.userAccount, time]];
}

/**
 提现明细信息
 */
- (void)thn_creatInfoTextWithData:(NSArray *)data {
    NSArray *hintTexts = @[kTextMode, kTextAccount, kTextTime];
    CGFloat originY = 165;
    
    for (NSUInteger idx = 0; idx < data.count; idx ++) {
        YYLabel *hintLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, originY + 31 * idx, 80, 15)];
        hintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        hintLabel.font = [UIFont systemFontOfSize:14];
        hintLabel.text = hintTexts[idx];
        hintLabel.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 0);
        [self.containerView addSubview:hintLabel];
        
        YYLabel *textLabel = [[YYLabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 170, originY + 31 * idx, 150, 15)];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.text = data[idx];
        [self.containerView addSubview:textLabel];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, CGRectGetWidth(self.frame) - 40, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9" alpha:0.7];
    [self.containerView addSubview:line];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.statusLabel];
    [self addSubview:self.containerView];
    [self addSubview:self.hintView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(260);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 15));
        make.top.mas_equalTo(30);
        make.centerX.equalTo(self);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 26));
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(14);
        make.centerX.equalTo(self);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 14));
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(14);
        make.centerX.equalTo(self);
    }];
    
    [self.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(115);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.containerView.mas_bottom).with.offset(10);
    }];
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextTitle;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (THNCashHintView *)hintView {
    if (!_hintView) {
        _hintView = [[THNCashHintView alloc] initWithType:(THNCashHintViewTypeQuery)];
    }
    return _hintView;
}

@end
