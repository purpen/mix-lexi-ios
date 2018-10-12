//
//  THNLifeOrderInfoTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderInfoTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import <YYKit/YYKit.h>

static NSString *const kTextNumber = @"订单编号：";
static NSString *const kTextMoney  = @"预计收益：";

@interface THNLifeOrderInfoTableViewCell ()

// 订单编号
@property (nonatomic, strong) UILabel *numberLabel;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 金额
@property (nonatomic, strong) YYLabel *moneyLabel;

@end

@implementation THNLifeOrderInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setLifeOrderInfoData:(THNLifeOrderModel *)model {
    self.numberLabel.text = [NSString stringWithFormat:@"%@%@", kTextNumber, model.rid];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.created_at doubleValue]];
    self.timeLabel.text = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self thn_setLifeOrderMoney:model.pay_amount];
}

#pragma mark - private methods
- (void)thn_setLifeOrderMoney:(CGFloat)money {
    NSString *moneyStr = [NSString stringWithFormat:@"¥%.2f", money];
    NSMutableAttributedString *moneyAtt = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    moneyAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    moneyAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    moneyAtt.alignment = NSTextAlignmentRight;
    
    NSMutableAttributedString *hintAtt = [[NSMutableAttributedString alloc] initWithString:kTextMoney];
    hintAtt.color = [UIColor colorWithHexString:@"#999999"];
    hintAtt.font = [UIFont systemFontOfSize:12];
    hintAtt.alignment = NSTextAlignmentRight;
    
    [moneyAtt insertAttributedString:hintAtt atIndex:0];
    self.moneyLabel.attributedText = moneyAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.numberLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 12));
        make.left.mas_equalTo(20);
        make.bottom.equalTo(self.mas_centerY).with.offset(-3);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 12));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.mas_centerY).with.offset(3);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.timeLabel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(15);
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
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
    }
    return _timeLabel;
}

- (YYLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[YYLabel alloc] init];
    }
    return _moneyLabel;
}

@end
