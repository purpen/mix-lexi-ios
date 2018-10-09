//
//  THNLifeCashBillTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

static NSString *const kTextPrice   = @"提现金额";
static NSString *const kTextLoding  = @"审核中";
static NSString *const kTextError   = @"提现失败";

@interface THNLifeCashBillTableViewCell ()

// 提现金额
@property (nonatomic, strong) UILabel *priceLabel;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 金额
@property (nonatomic, strong) UILabel *moneyLabel;
// 状态
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation THNLifeCashBillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
        [self thn_setData];
    }
    return self;
}

- (void)thn_setData {
    self.timeLabel.text = @"2018-08-07 12:39:21";
    self.moneyLabel.text = @"+4.96";
    self.statusLabel.text = @"提现失败";
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.priceLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.statusLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 14));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(6);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(18);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(13);
    }];
}

#pragma mark - getters and setters
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _priceLabel.text = kTextPrice;
    }
    return _priceLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

@end
