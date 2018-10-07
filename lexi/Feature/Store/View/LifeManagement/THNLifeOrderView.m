//
//  THNLifeOrderView.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

static NSString *const kTextTitle       = @"总计成交订单";
static NSString *const kTextTitleSub    = @"（笔）";
static NSString *const kTextTotay       = @"今日成交：";

@interface THNLifeOrderView ()

// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
// 总订单
@property (nonatomic, strong) UILabel *totalLabel;
// 今日订单
@property (nonatomic, strong) YYLabel *todayLabel;

@end

@implementation THNLifeOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeOrdersCollect:(THNLifeOrdersCollectModel *)model {
    self.totalLabel.text = [NSString stringWithFormat:@"%zi", model.all_count];
    [self thn_setTodatCountWithValue:model.today_count];
}

#pragma mark - private methods
- (void)thn_setTodatCountWithValue:(NSInteger)value {
    NSString *todayCountStr = [NSString stringWithFormat:@"%zi", value];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextTotay];
    att.color = [UIColor colorWithHexString:@"#FFFFFF"];
    att.font = [UIFont systemFontOfSize:12];
    att.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *todayAtt = [[NSMutableAttributedString alloc] initWithString:todayCountStr];
    todayAtt.color = [UIColor colorWithHexString:@"#FFFFFF"];
    todayAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
    todayAtt.alignment = NSTextAlignmentCenter;
    
    [att appendAttributedString:todayAtt];
    self.todayLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self.layer addSublayer:[UIColor colorGradientWithView:self colors:@[@"#5FE4B1", @"#4DD0BC"]]];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.totalLabel];
    [self addSubview:self.todayLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(16);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(12);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(26);
    }];
    
    [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextTitle];
        titleAtt.color = [UIColor colorWithHexString:@"#FFFFFF"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextTitleSub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#FFFFFF"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _titleLabel.attributedText = titleAtt;
    }
    return _titleLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightSemibold)];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (YYLabel *)todayLabel {
    if (!_todayLabel) {
        _todayLabel = [[YYLabel alloc] init];
    }
    return _todayLabel;
}

@end
