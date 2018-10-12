//
//  THNSettingInfoTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNSettingInfoTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNConst.h"
#import "UIBarButtonItem+Helper.h"
#import <DateTools/DateTools.h>

static NSString *kSettingInfoCellId = @"THNSettingInfoTableViewCellId";
/// text
static NSString *const kTextName        = @"用户名";
static NSString *const kHintName        = @"请输入用户名";
static NSString *const kTextSlogan      = @"个人介绍";
static NSString *const kHintSlogan      = @"给自己添加一个solgan吧";
static NSString *const kTextEmail       = @"邮箱";
static NSString *const kHintEmail       = @"定期为你推荐好设计";
static NSString *const kTextLocation    = @"位置";
static NSString *const kHintLocation    = @"请输入您的位置";
static NSString *const kTextDate        = @"出生日期";
static NSString *const kHintDate        = @"请输入出生日期";
static NSString *const kTextSex         = @"性别";
static NSString *const kHintSex         = @"请选择性别";
///
static NSString *const kToolbarItemDone     = @"完成";
static NSString *const kToolbarItemCancel   = @"取消";

@interface THNSettingInfoTableViewCell () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UITextField *infoTextField;
/// 日期选择器
@property (nonatomic, strong) UIDatePicker *dayDatePicker;
/// 日期选择器工具栏
@property (nonatomic, strong) UIToolbar *dayToolbar;
/// 性别选择器
@property (nonatomic, strong) UIPickerView *sexPicker;
/// 性别
@property (nonatomic, strong) NSArray *sexArr;

@end

@implementation THNSettingInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style tyep:(THNSettingInfoType)type {
    THNSettingInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingInfoCellId];
    if (!cell) {
        cell = [[THNSettingInfoTableViewCell alloc] initWithStyle:style reuseIdentifier:kSettingInfoCellId];
        cell.tableView = tableView;
        cell.type = type;
    }
    return cell;
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView tyep:(THNSettingInfoType)type {
    return [self initCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault) tyep:type];
}

#pragma mark - public methods
- (void)thn_setUserInfoData:(THNUserDataModel *)model {
    switch (self.type) {
        case THNSettingInfoTypeName: {
            [self thn_setUserInfoText:model.username];
        }
            break;
            
        case THNSettingInfoTypeSlogan: {
            [self thn_setUserInfoText:model.about_me];
        }
            break;
            
        case THNSettingInfoTypeEmail: {
            [self thn_setUserInfoText:model.mail];
        }
            break;
            
        case THNSettingInfoTypeLocation: {
            [self thn_setUserInfoText:model.street_address];
        }
            break;
            
        case THNSettingInfoTypeDate: {
            [self thn_setUserInfoText:model.date];
        }
            break;
            
        case THNSettingInfoTypeSex: {
            [self thn_setUserInfoText:model.gender == 0 ? @"女" : @"男"];
        }
            break;
    }
}

- (void)setType:(THNSettingInfoType)type {
    _type = type;
    
    NSArray *titleTexts = @[kTextName, kTextSlogan, kTextEmail, kTextLocation, kTextDate, kTextSex];
    self.titleLable.text = titleTexts[(NSUInteger)type];
    
    NSArray *placeholders = @[kHintName, kHintSlogan, kHintEmail, kHintLocation, kHintDate, kHintSex];
    self.infoTextField.placeholder = placeholders[(NSUInteger)type];
    
    if (type == THNSettingInfoTypeDate) {
        self.infoTextField.inputView = self.dayDatePicker;
        self.infoTextField.inputAccessoryView = self.dayToolbar;
        
    } else if (type == THNSettingInfoTypeSex) {
        self.infoTextField.inputView = self.sexPicker;
    }
}

#pragma mark - event response
- (void)toolbarItemCancel {
    [self endEditing:YES];
}

- (void)toolbarItemDone {
    [self endEditing:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dayString = [formatter stringFromDate:self.dayDatePicker.date];
    
    self.infoTextField.text = dayString;
    self.editInfo = dayString;
}

#pragma mark - textfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.editInfo = textField.text;
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? @"女" : @"男";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *sex = row == 0 ? @"女" : @"男";
    self.infoTextField.text = sex;
    self.editInfo = sex;
}

#pragma mark - private methods
- (void)thn_setUserInfoText:(NSString *)text {
    if (text.length) {
        self.infoTextField.text = text;
    }
    
    NSString *infoStr = self.type == THNSettingInfoTypeSex ? [self thn_getSexInfo] : self.infoTextField.text;
    self.editInfo = infoStr.length ? infoStr : @"";
}

- (NSString *)thn_getSexInfo {
    NSString *sexStr = [self.infoTextField.text isEqualToString:@"女"] ? @"0" : @"1";
    
    return sexStr;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLable];
    [self addSubview:self.infoTextField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(18);
    }];
    
    [self.infoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLable.font = [UIFont systemFontOfSize:13];
    }
    return _titleLable;
}

- (UITextField *)infoTextField {
    if (!_infoTextField) {
        _infoTextField = [[UITextField alloc] init];
        _infoTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _infoTextField.font = [UIFont systemFontOfSize:14];
        _infoTextField.delegate = self;
    }
    return _infoTextField;
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

- (UIPickerView *)sexPicker {
    if (!_sexPicker) {
        _sexPicker = [[UIPickerView alloc] init];
        _sexPicker.dataSource = self;
        _sexPicker.delegate = self;
    }
    return _sexPicker;
}

#pragma mark -
- (BOOL)willDealloc {
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf assertNotDealloc];
    });
    return YES;
}

- (void)assertNotDealloc {
    NSAssert(NO, @"");
}

- (void)dealloc {
    [self.infoTextField resignFirstResponder];
}

@end
