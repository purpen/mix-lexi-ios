//
//  THNLifeCashBillInfoTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillInfoTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>

static NSString *const kTextNumber = @"订单编号：";
static NSString *const kTextDetail = @"详情";
static NSString *const kTextMoney  = @"收益：￥";

@interface THNLifeCashBillInfoTableViewCell ()

// 订单编号
@property (nonatomic, strong) UILabel *numberLabel;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 金额
@property (nonatomic, strong) UILabel *moneyLabel;
// 详情
@property (nonatomic, strong) UIButton *detailButton;

@end

@implementation THNLifeCashBillInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setLifeCashBillOrderData:(THNLifeCashBillOrderModel *)model {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.created_at doubleValue]];
    self.timeLabel.text = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%.2f", kTextMoney, model.commission_price];
    self.numberLabel.text = [NSString stringWithFormat:@"%@%@", kTextNumber, model.order_id];
}

- (void)setShowDetail:(BOOL)showDetail {
    self.detailButton.hidden = !showDetail;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.numberLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.detailButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(17);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(-100);
        make.left.mas_equalTo(20);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(-100);
        make.left.mas_equalTo(20);
        make.top.equalTo(self.numberLabel.mas_bottom).with.offset(8);
    }];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(35, 15));
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
        _moneyLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _moneyLabel;
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [[UIButton alloc] init];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_detailButton setTitle:kTextDetail forState:(UIControlStateNormal)];
        [_detailButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateNormal)];
        [_detailButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
        _detailButton.userInteractionEnabled = NO;
    }
    return _detailButton;
}

@end
