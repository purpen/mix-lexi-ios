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

@interface THNSettingInfoTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UITextField *infoTextField;

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
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.type == THNSettingInfoTypeDate || self.type == THNSettingInfoTypeSex) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.editInfo = textField.text;
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
