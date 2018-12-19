//
//  THNCashCertificationView.m
//  lexi
//
//  Created by FLYang on 2018/12/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashCertificationView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "SVProgressHUD+Helper.h"
#import "UIView+Helper.h"
#import "THNConst.h"
#import "THNMarco.h"

static NSString *const kTextHint     = @"根据监管需求，首次提现前需完成实名认证。";
static NSString *const kTextName     = @"请输入您的真实姓名";
static NSString *const kTextCard     = @"请输入身份证号";
static NSString *const kTextHintImg  = @"上传本人身份证照片";
static NSString *const kTextFront    = @"清晰正面照片";
static NSString *const kTextOverleaf = @"清晰反面照片";
static NSString *const kTextDone     = @"提交";

@interface THNCashCertificationView ()

@property (nonatomic, strong) YYLabel *hintLabel;
@property (nonatomic, strong) UIView *textContainer;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *cardTextField;
@property (nonatomic, strong) UIView *imageContainer;
@property (nonatomic, strong) YYLabel *imgHintLabel;
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) YYLabel *frontHintLabel;
@property (nonatomic, strong) YYLabel *backHintLabel;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation THNCashCertificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setFrontIDCardImageData:(NSData *)imageData {
    self.frontImageView.image = [UIImage imageWithData:imageData];
    self.frontImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)thn_setBackIDCardImageData:(NSData *)imageData {
    self.backImageView.image = [UIImage imageWithData:imageData];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    NSString *name = self.nameTextField.text;
    NSString *card = self.cardTextField.text;
    
    if (!name.length) {
        [SVProgressHUD thn_showInfoWithStatus:kTextName];
        return;
    }
    
    if (!card.length) {
        [SVProgressHUD thn_showInfoWithStatus:kTextCard];
        return;
    }
    
    if (!self.frontImageView.image || !self.backImageView.image) {
        [SVProgressHUD thn_showInfoWithStatus:kTextHintImg];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_cashCommitCertificationInfo:)]) {
        [self.delegate thn_cashCommitCertificationInfo:@{@"name"    : name,
                                                         @"id_card" : card}];
    }
}

- (void)uploadFrontImageAction:(UITapGestureRecognizer *)tap {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(thn_cashUploadFrontIDCardImage)]) {
        [self.delegate thn_cashUploadFrontIDCardImage];
    }
}

- (void)uploadBackImageAction:(UITapGestureRecognizer *)tap {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(thn_cashUploadBackIDCardImage)]) {
        [self.delegate thn_cashUploadBackIDCardImage];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.hintLabel];
    [self.textContainer addSubview:self.nameTextField];
    [self.textContainer addSubview:self.cardTextField];
    [self addSubview:self.textContainer];
    [self.imageContainer addSubview:self.imgHintLabel];
    [self.imageContainer addSubview:self.frontImageView];
    [self.imageContainer addSubview:self.frontHintLabel];
    [self.imageContainer addSubview:self.backImageView];
    [self.imageContainer addSubview:self.backHintLabel];
    [self addSubview:self.imageContainer];
    [self addSubview:self.doneButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.textContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(96);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(30);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.cardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.nameTextField.mas_bottom).with.offset(0);
    }];
    
    [self.imageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(140);
    }];
    
    [self.imgHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 16));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
    }];
    
    CGFloat imageW = (kScreenWidth - 55) / 2;
    
    [self.frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageW, 105));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(53);
    }];
    
    [self.frontHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageW, 15));
        make.centerX.equalTo(self.frontImageView);
        make.top.equalTo(self.frontImageView.mas_bottom).with.offset(10);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageW, 105));
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(53);
    }];
    
    [self.backHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageW, 15));
        make.centerX.equalTo(self.backImageView);
        make.top.equalTo(self.backImageView.mas_bottom).with.offset(10);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.imageContainer.mas_bottom).with.offset(30);
    }];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameTextField drawViewBorderType:(UIViewBorderLineTypeBottom) width:0.5 color:[UIColor colorWithHexString:@"#E9E9E9"]];
    [self.cardTextField drawViewBorderType:(UIViewBorderLineTypeBottom) width:0.5 color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        _hintLabel.backgroundColor = [UIColor colorWithHexString:@"#FFEDDA"];
        _hintLabel.text = kTextHint;
        _hintLabel.font = [UIFont systemFontOfSize:11];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return _hintLabel;
}

- (UIView *)textContainer {
    if (!_textContainer) {
        _textContainer = [[UIView alloc] init];
        _textContainer.backgroundColor = [UIColor whiteColor];
    }
    return _textContainer;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = kTextName;
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameTextField;
}

- (UITextField *)cardTextField {
    if (!_cardTextField) {
        _cardTextField = [[UITextField alloc] init];
        _cardTextField.placeholder = kTextCard;
        _cardTextField.font = [UIFont systemFontOfSize:14];
        _cardTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _cardTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        _cardTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _cardTextField;
}

- (UIView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[UIView alloc] init];
        _imageContainer.backgroundColor = [UIColor whiteColor];
    }
    return _imageContainer;
}

- (YYLabel *)imgHintLabel {
    if (!_imgHintLabel) {
        _imgHintLabel = [[YYLabel alloc] init];
        _imgHintLabel.font = [UIFont systemFontOfSize:14];
        _imgHintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _imgHintLabel.text = kTextHintImg;
    }
    return _imgHintLabel;
}

- (UIImageView *)frontImageView {
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_order_addCard"]];
        _frontImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _frontImageView.contentMode = UIViewContentModeCenter;
        _frontImageView.userInteractionEnabled = YES;
        _frontImageView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadFrontImageAction:)];
        [_frontImageView addGestureRecognizer:tap];
        
    }
    return _frontImageView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_order_addCard"]];
        _backImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _backImageView.contentMode = UIViewContentModeCenter;
        _backImageView.userInteractionEnabled = YES;
        _backImageView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadBackImageAction:)];
        [_backImageView addGestureRecognizer:tap];
    }
    return _backImageView;
}

- (YYLabel *)frontHintLabel {
    if (!_frontHintLabel) {
        _frontHintLabel = [[YYLabel alloc] init];
        _frontHintLabel.font = [UIFont systemFontOfSize:12];
        _frontHintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _frontHintLabel.textAlignment = NSTextAlignmentCenter;
        _frontHintLabel.text = kTextFront;
    }
    return _frontHintLabel;
}

- (YYLabel *)backHintLabel {
    if (!_backHintLabel) {
        _backHintLabel = [[YYLabel alloc] init];
        _backHintLabel.font = [UIFont systemFontOfSize:12];
        _backHintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _backHintLabel.textAlignment = NSTextAlignmentCenter;
        _backHintLabel.text = kTextOverleaf;
    }
    return _backHintLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton setTitle:kTextDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
