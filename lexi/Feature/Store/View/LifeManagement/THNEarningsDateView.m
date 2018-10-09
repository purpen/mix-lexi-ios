//
//  THNEarningsDateView.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNEarningsDateView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "THNConst.h"

static NSString *const kTextRecord  = @"交易记录";
static NSString *const kTextDate    = @"选择日期";
static NSString *const kTextWeek    = @"近7天";
static NSString *const kTextMonth   = @"近30天";
static NSInteger const kDateButtonTag = 4361;

@interface THNEarningsDateView ()

@property (nonatomic, strong) UILabel *titleLabel;
// 选择日期
@property (nonatomic, strong) UIButton *selectedDate;
@property (nonatomic, strong) UIButton *seletedtButton;

@end

@implementation THNEarningsDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setSelectedDate:(NSString *)dateString {
    [self.selectedDate setTitle:dateString forState:(UIControlStateNormal)];
}

#pragma mark - event response
- (void)selectedDateAction:(UIButton *)button {
    self.selectedDate.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedDate)]) {
        [self.delegate thn_didSelectedDate];
    }
}

- (void)dateButtonAction:(UIButton *)button {
    self.seletedtButton.selected = NO;
    button.selected = YES;
    self.seletedtButton = button;
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedDateWithDefaultIndex:)]) {
        [self.delegate thn_didSelectedDateWithDefaultIndex:button.tag - kDateButtonTag];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectedDate];
    [self thn_creatDateButtonWithTitles:@[kTextWeek, kTextMonth]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 15));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
    }];
    
    [self.selectedDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(78, 25));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
    }];
}

#pragma mark - getters and setters
- (void)thn_creatDateButtonWithTitles:(NSArray *)titles {
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(100 + 55 * idx, 30, 50, 25)];
        [dateButton setTitle:titles[idx] forState:(UIControlStateNormal)];
        dateButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [dateButton setTitleColor:[UIColor colorWithHexString:@"#959FA7"] forState:(UIControlStateNormal)];
        [dateButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateSelected)];
        dateButton.tag = kDateButtonTag + idx;
        
        if (idx == 0) {
            dateButton.selected = YES;
            self.seletedtButton = dateButton;
        }
        
        [dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:dateButton];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = kTextRecord;
    }
    return _titleLabel;
}

- (UIButton *)selectedDate {
    if (!_selectedDate) {
        _selectedDate = [[UIButton alloc] init];
        [_selectedDate setTitle:kTextDate forState:(UIControlStateNormal)];
        [_selectedDate setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [_selectedDate setTitleEdgeInsets:(UIEdgeInsetsMake(0, -17, 0, 0))];
        _selectedDate.titleLabel.font = [UIFont systemFontOfSize:12];
        [_selectedDate setImage:[UIImage imageNamed:@"icon_sort_down"] forState:(UIControlStateNormal)];
        [_selectedDate setImage:[UIImage imageNamed:@"icon_sort_up"] forState:(UIControlStateSelected)];
        [_selectedDate setImageEdgeInsets:(UIEdgeInsetsMake(0, 64, 0, 0))];
        _selectedDate.selected = NO;
        _selectedDate.layer.borderWidth = 1;
        _selectedDate.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        _selectedDate.layer.cornerRadius = 4;
        [_selectedDate addTarget:self action:@selector(selectedDateAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectedDate;
}

@end
