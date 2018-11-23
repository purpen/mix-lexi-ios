//
//  THNLifeOrderRecordTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeTransactionRecordTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>

static NSString *const kTextNumber = @"订单编号：";

@interface THNLifeTransactionRecordTableViewCell ()

// 订单编号
@property (nonatomic, strong) UILabel *numberLabel;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 金额
@property (nonatomic, strong) UILabel *moneyLabel;
// 状态
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation THNLifeTransactionRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setLifeTransactionsData:(NSDictionary *)data {
    THNTransactionsModel *model = [THNTransactionsModel mj_objectWithKeyValues:data];
    NSArray *statusArr = @[@"待结算", @"成功", @"已退款"];
    NSArray *statusColors = @[@"#FB880C", @"#5FE4B1", @"#B2B2B2"];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@%@", kTextNumber, model.order_rid];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.payed_at doubleValue]];
    self.timeLabel.text = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", model.actual_amount];
    self.statusLabel.text = statusArr[model.status - 1];
    self.statusLabel.textColor = [UIColor colorWithHexString:statusColors[model.status - 1]];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.numberLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.statusLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 12));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 13));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.numberLabel.mas_bottom).with.offset(8);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(12);
    }];
}

#pragma mark - getters and setters
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:11];
        _numberLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _numberLabel;
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
        _moneyLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:11];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

@end
