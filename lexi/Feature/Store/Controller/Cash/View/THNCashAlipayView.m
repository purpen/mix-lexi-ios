//
//  THNCashAlipayView.m
//  lexi
//
//  Created by FLYang on 2018/12/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashAlipayView.h"
#import "THNCashHintView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "SVProgressHUD+Helper.h"

static NSString *const kTextCash    = @"立即提现";
static NSString *const kPlaAccount  = @"请输入您的支付宝账号";
static NSString *const kPlaName     = @"请输入您的真实姓名";

@interface THNCashAlipayView ()

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) THNCashHintView *hintView;
@property (nonatomic, assign) CGFloat amount;

@end

@implementation THNCashAlipayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setCanCashAmount:(CGFloat)amount {
    self.amount = amount;
    self.amountLabel.text = [NSString stringWithFormat:@"%.0f元", amount];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if (!self.accountField.text.length) {
        [SVProgressHUD thn_showInfoWithStatus:kPlaAccount];
        return;
    }
    
    if (!self.nameField.text.length) {
        [SVProgressHUD thn_showInfoWithStatus:kPlaName];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_cashAlipayAmount:account:name:)]) {
        [self.delegate thn_cashAlipayAmount:self.amount
                                    account:self.accountField.text
                                       name:self.nameField.text];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self thn_createCashContentViewWithTexts:@[@"提现金额", @"支付宝账号", @"支付宝姓名"]];
    [self.containerView addSubview:self.amountLabel];
    [self.containerView addSubview:self.accountField];
    [self.containerView addSubview:self.nameField];
    [self addSubview:self.containerView];
    [self addSubview:self.doneButton];
    [self addSubview:self.hintView];
    
    [self setMasonryLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

- (void)setMasonryLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(244);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(115);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(0);
    }];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(115);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.amountLabel.mas_bottom).with.offset(0);
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(115);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.accountField.mas_bottom).with.offset(0);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-20);
    }];
    
    [self.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(180);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.containerView.mas_bottom).with.offset(10);
    }];
}

#pragma mark - getters and setters
- (void)thn_createCashContentViewWithTexts:(NSArray *)texts {
    for (NSUInteger idx = 0; idx < texts.count; idx ++) {
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 50 * idx, CGRectGetWidth(self.frame), 50)];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:16];
        label.textContainerInset = UIEdgeInsetsMake(2, 20, 0, 0);
        label.text = texts[idx];
        [label drawViewBorderType:(UIViewBorderLineTypeBottom) width:0.5 color:[UIColor colorWithHexString:@"#E9E9E9"]];
        
        [self.containerView addSubview:label];
    }
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:kTextCash forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (THNCashHintView *)hintView {
    if (!_hintView) {
        _hintView = [[THNCashHintView alloc] initWithType:(THNCashHintViewTypeNotes)];
    }
    return _hintView;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _amountLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    }
    return _amountLabel;
}

- (UITextField *)accountField {
    if (!_accountField) {
        _accountField = [[UITextField alloc] init];
        _accountField.textColor = [UIColor colorWithHexString:@"#333333"];
        _accountField.font = [UIFont systemFontOfSize:16];
        _accountField.placeholder = kPlaAccount;
    }
    return _accountField;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc] init];
        _nameField.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameField.font = [UIFont systemFontOfSize:16];
        _nameField.placeholder = kPlaName;
    }
    return _nameField;
}

@end
