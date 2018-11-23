//
//  THNLifeCashBillInfoView.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillInfoView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import <DateTools/DateTools.h>

static NSString *const kTextTitle   = @"乐喜生活馆";
static NSString *const kTextSuccess = @"提现成功";
static NSString *const kTextLoding  = @"审核中";
static NSString *const kTextFailure = @"提现失败";
static NSString *const kTextService = @"技术服务费";
static NSString *const kTextPlace   = @"提现到";
static NSString *const kTextTime    = @"提现时间";
static NSString *const kTextDetail  = @"提现明细";

@interface THNLifeCashBillInfoView ()

// 生活馆icon
@property (nonatomic, strong) UIImageView *iconImageView;
// 标题名称
@property (nonatomic, strong) UILabel *titleLabel;
// 金额
@property (nonatomic, strong) UILabel *moneyLabel;
// 提现状态
@property (nonatomic, strong) UILabel *statusLabel;
// 提现明细
@property (nonatomic, strong) YYLabel *detailLaebl;

@end

@implementation THNLifeCashBillInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeCashBillDetailData:(THNLifeCashBillModel *)model {
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", model.actual_amount];
    NSArray *statusArr = @[@"审核中", @"提现成功", @"提现失败"];
    self.statusLabel.text = statusArr[model.status - 1];
    
    NSString *serviceFee = [NSString stringWithFormat:@"%.2f", model.service_fee];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.created_at doubleValue]];
    NSString *time = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self thn_creatInfoTextWithData:@[serviceFee, @"微信零钱包", time]];
}

// 提现明细信息
- (void)thn_creatInfoTextWithData:(NSArray *)data {
    NSArray *hintTexts = @[kTextService, kTextPlace, kTextTime];
    
    for (NSUInteger idx = 0; idx < data.count; idx ++) {
        CGFloat originY = idx > 0 ? 20 : 0;
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 135 + 30 * idx + originY, 75, 15)];
        hintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        hintLabel.font = [UIFont systemFontOfSize:14];
        hintLabel.text = hintTexts[idx];
        [self addSubview:hintLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 170, 135 + 30 * idx + originY, 150, 15)];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.text = data[idx];
        [self addSubview:textLabel];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.detailLaebl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 54, CGRectGetWidth(self.frame), 10)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    [self addSubview:lineView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 15));
        make.top.mas_equalTo(30);
        make.centerX.equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel.mas_left).with.offset(-2);
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
    
    [self.detailLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(0, 169))
                          end:(CGPointMake(CGRectGetWidth(self.frame), 169))
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_life_store_logo"]];
    }
    return _iconImageView;
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

- (YYLabel *)detailLaebl {
    if (!_detailLaebl) {
        _detailLaebl = [[YYLabel alloc] init];
        _detailLaebl.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _detailLaebl.textColor = [UIColor colorWithHexString:@"#333333"];
        _detailLaebl.text = kTextDetail;
        _detailLaebl.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return _detailLaebl;
}

@end
