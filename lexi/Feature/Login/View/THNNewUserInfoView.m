//
//  THNNewUserInfoView.m
//  lexi
//
//  Created by FLYang on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewUserInfoView.h"
#import "THNDoneButton.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+Helper.h"
#import "UIBarButtonItem+Helper.h"

static NSString *const kTitleLabelText      = @"欢迎来到乐喜";
static NSString *const kHintLabelText       = @"有个真实头像，会增加辨识度哦！";
static NSString *const kNamePlaceholder     = @"输入用户名";
static NSString *const kDayPlaceholder      = @"输入生日信息";
static NSString *const kSexLabelText        = @"性别:";
static NSString *const kDoneButtonTitle     = @"确认";
static NSString *const kToolbarItemDone     = @"完成";
static NSString *const kToolbarItemCancel   = @"取消";
static NSInteger const kOptionButtonTag     = 1632;
/// 设置信息上传参数
static NSString *const kParamAvatarId   = @"avatar_id";
static NSString *const kParamName       = @"username";
static NSString *const kParamDate       = @"date";
static NSString *const kParamGender     = @"gender";

@interface THNNewUserInfoView () <UITextFieldDelegate> {
    NSInteger _selectSex; // 0:女生 & 1:男生
    NSInteger _imagaIdx;  // 图片id
}

/// 用户头像
@property (nonatomic, strong) UIImageView *headImageView;
/// 相机，选择照片按钮
@property (nonatomic, strong) UIButton *cameraButton;
/// 头像更换提示文字
@property (nonatomic, strong) UILabel *hintLabel;
/// 用户名输入框
@property (nonatomic, strong) UITextField *nameTextField;
/// 选择生日
@property (nonatomic, strong) UITextField *dayTextField;
/// 日期选择器
@property (nonatomic, strong) UIDatePicker *dayDatePicker;
/// 日期选择器工具栏
@property (nonatomic, strong) UIToolbar *dayToolbar;
/// 性别选择视图
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) UIButton *selectButton;
/// 完成（确认）按钮
@property (nonatomic, strong) THNDoneButton *doneButton;

@end

@implementation THNNewUserInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)setHeaderImage:(UIImage *)image withIdx:(NSInteger)idx {
    _imagaIdx = idx;

    self.headImageView.image = image;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.cameraButton.hidden = NO;
}

#pragma mark - private methods
/**
 获取用户设置信息
 */
- (NSDictionary *)getUserInfoParam {
    NSDictionary *infoDict = @{
                               kParamName: [self getUserNickname],
                               kParamDate: [self getUserBirthday],
                               kParamGender: [self getUserGender],
                               kParamAvatarId: [self getUserAvatarId]};
    
    return infoDict;
}

- (NSString *)getUserNickname {
    return self.nameTextField.text;
}

- (NSString *)getUserBirthday {
    return self.dayTextField.text;
}

- (NSString *)getUserAvatarId {
    return _imagaIdx ? [NSString stringWithFormat:@"%zi", _imagaIdx] : @"";
}

- (NSString *)getUserGender {
    return _selectSex ? [NSString stringWithFormat:@"%zi", _selectSex] : @"0";
}

#pragma mark - event response
- (void)setUserInfoDone {
    [self endEditing:YES];
    
    if (!_imagaIdx) {
        [SVProgressHUD showInfoWithStatus:kHintLabelText];
        return;
    }
    
    if (![self getUserNickname].length) {
        [SVProgressHUD showInfoWithStatus:kNamePlaceholder];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_setUserInfoEditDoneWithParam:)]) {
        [self.delegate thn_setUserInfoEditDoneWithParam:[self getUserInfoParam]];
    }
}

- (void)selectedHeadImage:(UITapGestureRecognizer *)tap {
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(thn_setUserInfoSelectHeader)]) {
        [self.delegate thn_setUserInfoSelectHeader];
    }
}

- (void)cameraButtonAction:(UIButton *)button {
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(thn_setUserInfoSelectHeader)]) {
        [self.delegate thn_setUserInfoSelectHeader];
    }
}

- (void)optionButtonAction:(UIButton *)button {
    [self endEditing:YES];
    
    self.selectButton.selected = NO;
    button.selected = !button.selected;
    self.selectButton = button;
    
    _selectSex = button.tag - kOptionButtonTag;
}

- (void)toolbarItemCancel {
    [self endEditing:YES];
}

- (void)toolbarItemDone {
    [self endEditing:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dayString = [formatter stringFromDate:self.dayDatePicker.date];
    
    self.dayTextField.text = dayString;
}

#pragma mark - textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.dayTextField) {
        return NO;
    }
    return YES;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    self.title = kTitleLabelText;
    
    [self addSubview:self.headImageView];
    [self addSubview:self.cameraButton];
    [self addSubview:self.hintLabel];
    [self addSubview:self.nameTextField];
    [self addSubview:self.dayTextField];
    
    [self thn_initMultipleOptionButtons:@[@"女生", @"男生"]];
    [self addSubview:self.sexView];
    [self addSubview:self.doneButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(kDeviceiPhoneX ? 174 : 154);
    }];
    [self.headImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:90/2];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.bottom.equalTo(self.headImageView.mas_bottom).with.offset(-2);
        make.right.equalTo(self.headImageView.mas_right).with.offset(-2);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 15));
        make.centerX.equalTo(self);
        make.top.equalTo(self.headImageView.mas_bottom).with.offset(20);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(46);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(30);
    }];
    
    [self.dayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(46);
        make.top.equalTo(self.nameTextField.mas_bottom).with.offset(20);
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.dayTextField.mas_bottom).with.offset(20);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.sexView.mas_bottom).with.offset(30);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"icon_camera_main"];
        _headImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FB"];
        _headImageView.contentMode = UIViewContentModeCenter;
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedHeadImage:)];
        [_headImageView addGestureRecognizer:tapGesture];
    }
    return _headImageView;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] init];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_head"] forState:(UIControlStateNormal)];
        [_cameraButton addTarget:self action:@selector(cameraButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _cameraButton.hidden = YES;
    }
    return _cameraButton;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = kHintLabelText;
    }
    return _hintLabel;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = kNamePlaceholder;
        _nameTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameTextField.font = [UIFont systemFontOfSize:16];
        _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nameTextField.delegate = self;
        _nameTextField.layer.cornerRadius = 4;
        _nameTextField.layer.borderColor = [UIColor colorWithHexString:@"#DADADA"].CGColor;
        _nameTextField.layer.borderWidth = 0.5;
    }
    return _nameTextField;
}

- (UITextField *)dayTextField {
    if (!_dayTextField) {
        _dayTextField = [[UITextField alloc] init];
        _dayTextField.placeholder = kDayPlaceholder;
        _dayTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _dayTextField.font = [UIFont systemFontOfSize:16];
        _dayTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _dayTextField.leftViewMode = UITextFieldViewModeAlways;
        _dayTextField.delegate = self;
        
        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 46)];
        [iconButton setImage:[UIImage imageNamed:@"icon_down_gray"] forState:(UIControlStateNormal)];
        [iconButton setImageEdgeInsets:(UIEdgeInsetsMake(17, 15, 17, 15))];
        _dayTextField.rightView = iconButton;
        _dayTextField.rightViewMode = UITextFieldViewModeAlways;
        
        _dayTextField.layer.cornerRadius = 4;
        _dayTextField.layer.borderColor = [UIColor colorWithHexString:@"#DADADA"].CGColor;
        _dayTextField.layer.borderWidth = 0.5;
        
        _dayTextField.inputView = self.dayDatePicker;
        _dayTextField.inputAccessoryView = self.dayToolbar;
    }
    return _dayTextField;
}

- (UIDatePicker *)dayDatePicker {
    if (!_dayDatePicker) {
        _dayDatePicker = [[UIDatePicker alloc] init];
        _dayDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _dayDatePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _dayDatePicker;
}

- (UIToolbar *)dayToolbar {
    if (!_dayToolbar) {
        _dayToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
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

- (UIView *)sexView {
    if (!_sexView) {
        _sexView = [[UIView alloc] init];
        _sexView.backgroundColor = [UIColor whiteColor];
    }
    return _sexView;
}

/**
 创建多个选项按钮

 @param titles 按钮标题
 */
- (void)thn_initMultipleOptionButtons:(NSArray *)titles {
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    leftLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.text = kSexLabelText;
    [self.sexView addSubview:leftLabel];
    
    // 保存选项按钮
    NSMutableArray *optionButtonArr = [NSMutableArray array];
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *optionButton = [[UIButton alloc] init];
        [optionButton setTitle:titles[idx] forState:(UIControlStateNormal)];
        [optionButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        [optionButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [optionButton setImage:[UIImage imageNamed:@"icon_selected_none"] forState:(UIControlStateNormal)];
        [optionButton setImage:[UIImage imageNamed:@"icon_selected_main"] forState:(UIControlStateSelected)];
        [optionButton setImageEdgeInsets:(UIEdgeInsetsMake(0, -8, 0, 0))];
        optionButton.tag = kOptionButtonTag + idx;
        if (idx == 0) {
            optionButton.selected = YES;
            self.selectButton = optionButton;
        }
        
        [optionButton addTarget:self action:@selector(optionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.sexView addSubview:optionButton];
        [optionButtonArr addObject:optionButton];
    }
    
    [optionButtonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal)
                              withFixedItemLength:70
                                      leadSpacing:SCREEN_WIDTH - 196
                                      tailSpacing:0];
    [optionButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexView);
    }];
}

- (THNDoneButton *)doneButton {
    if (!_doneButton) {
        WEAKSELF;
        _doneButton = [THNDoneButton thn_initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 75)
                                             withTitle:kDoneButtonTitle
                                            completion:^{
                                                [weakSelf setUserInfoDone];
                                            }];
    }
    return _doneButton;
}

@end
