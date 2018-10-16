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
#import "UIBarButtonItem+Helper.h"
#import <DateTools/DateTools.h>

static NSString *const kTextRecord          = @"交易记录";
static NSString *const kTextDate            = @"选择日期";
static NSString *const kTextWeek            = @"近7天";
static NSString *const kTextMonth           = @"近30天";
static NSString *const kToolbarItemDone     = @"完成";
static NSString *const kToolbarItemCancel   = @"取消";
///
static NSInteger const kDateButtonTag       = 4361;

@interface THNEarningsDateView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
/// 选择日期
@property (nonatomic, strong) UITextField *dateTextField;
/// 日期选择器
@property (nonatomic, strong) UIDatePicker *dayDatePicker;
/// 日期选择器工具栏
@property (nonatomic, strong) UIToolbar *dayToolbar;
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
    self.dateTextField.text = dateString;
}

#pragma mark - event response
- (void)dateButtonAction:(UIButton *)button {
    self.seletedtButton.selected = NO;
    button.selected = YES;
    self.seletedtButton = button;
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedDateWithDefaultIndex:)]) {
        [self.delegate thn_didSelectedDateWithDefaultIndex:button.tag - kDateButtonTag];
    }
}

- (void)toolbarItemCancel {
    [self endEditing:YES];
}

- (void)toolbarItemDone {
    [self endEditing:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *dayString = [formatter stringFromDate:self.dayDatePicker.date];
    
    self.dateTextField.text = dayString;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.dateTextField];
    [self thn_creatDateButtonWithTitles:@[kTextWeek, kTextMonth]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 15));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
    }];
    
    [self.dateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(78, 25));
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
    }];
}

#pragma mark - textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
    upImageView.image = [UIImage imageNamed:@"icon_sort_up"];
    upImageView.contentMode = UIViewContentModeLeft;
    
    self.dateTextField.rightView = upImageView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
    downImageView.image = [UIImage imageNamed:@"icon_sort_down"];
    downImageView.contentMode = UIViewContentModeLeft;
    
    self.dateTextField.rightView = downImageView;
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

- (UITextField *)dateTextField {
    if (!_dateTextField) {
        _dateTextField = [[UITextField alloc] init];
        _dateTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _dateTextField.placeholder = kTextDate;
        _dateTextField.font = [UIFont systemFontOfSize:12];
        _dateTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
        _dateTextField.leftViewMode = UITextFieldViewModeAlways;
    
        UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
        downImageView.image = [UIImage imageNamed:@"icon_sort_down"];
        downImageView.contentMode = UIViewContentModeLeft;
        _dateTextField.rightView = downImageView;
        _dateTextField.rightViewMode = UITextFieldViewModeAlways;
        _dateTextField.inputView = self.dayDatePicker;
        _dateTextField.inputAccessoryView = self.dayToolbar;
        _dateTextField.layer.borderWidth = 1;
        _dateTextField.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        _dateTextField.layer.cornerRadius = 4;
        _dateTextField.delegate = self;
    }
    return _dateTextField;
}

- (UIDatePicker *)dayDatePicker {
    if (!_dayDatePicker) {
        _dayDatePicker = [[UIDatePicker alloc] init];
        _dayDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _dayDatePicker.datePickerMode = UIDatePickerModeDate;
        [_dayDatePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        [_dayDatePicker setMinimumDate:[[NSDate date] dateBySubtractingYears:100]];
    }
    return _dayDatePicker;
}

- (UIToolbar *)dayToolbar {
    if (!_dayToolbar) {
        _dayToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
        _dayToolbar.backgroundColor = [UIColor colorWithHexString:@"#DEDFE0"];
        
        UIBarButtonItem *cancelItem = [UIBarButtonItem itemWithTitle:kToolbarItemCancel
                                                         normalColor:[UIColor colorWithHexString:@"#333333"]
                                                    highlightedColor:[UIColor colorWithHexString:@"#333333"]
                                                              target:self
                                                              action:@selector(toolbarItemCancel)];
        
        UIBarButtonItem *doneItem = [UIBarButtonItem itemWithTitle:kToolbarItemDone
                                                       normalColor:[UIColor colorWithHexString:@"#4DA1FF"]
                                                  highlightedColor:[UIColor colorWithHexString:@"#4DA1FF"]
                                                            target:self
                                                            action:@selector(toolbarItemDone)];
        _dayToolbar.items = @[cancelItem, doneItem];
    }
    return _dayToolbar;
}

@end
