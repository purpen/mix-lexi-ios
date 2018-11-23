//
//  THNPaymentTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaymentTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

static NSString *const kPaymentTableViewCellId = @"kPaymentTableViewCellId";
///
static NSString *const kTextWechatPay       = @"微信支付";
static NSString *const kTextWechatPayHint   = @"微信钱包快捷付款，需5.0以上版本";
static NSString *const kTextAlipay          = @"支付宝支付";
static NSString *const kTextAlipayHint      = @"推荐有支付宝账号的用户使用";
static NSString *const kTextHuabei          = @"蚂蚁花呗支付";
static NSString *const kTextHuabeiHint      = @"花呗支付轻松付款，推荐开通花呗的用户使用";

@interface THNPaymentTableViewCell ()

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 名称
@property (nonatomic, strong) UILabel *nameLabel;
/// 提示
@property (nonatomic, strong) UILabel *hintLabel;
/// 选择按钮
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation THNPaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initPaymentCellWithTableView:(UITableView *)tableView {
    THNPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentTableViewCellId];
    if (!cell) {
        cell = [[THNPaymentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kPaymentTableViewCellId];
    }
    return cell;
}

- (void)thn_setPaymentTypeWithType:(THNPaymentType)type {
    NSArray *titleArr = @[kTextWechatPay, kTextAlipay, kTextHuabei];
    NSArray *hintArr = @[kTextWechatPayHint, kTextAlipayHint, kTextHuabeiHint];
    NSArray *iconArr = @[@"icon_pay_wechat", @"icon_pay_alipay", @"icon_pay_huabei"];
    NSInteger index = (NSInteger)type;
    
    [self thn_setNameLabelText:titleArr[index] hintText:hintArr[index] iconName:iconArr[index]];
}

- (void)setIsSelectedPayment:(BOOL)isSelectedPayment {
    _isSelectedPayment = isSelectedPayment;
    
    self.selectButton.selected = isSelectedPayment;
}

#pragma mark - private methods
- (void)thn_setNameLabelText:(NSString *)name hintText:(NSString *)hint iconName:(NSString *)iconName {
    self.nameLabel.text = name;
    self.hintLabel.text = hint;
    self.iconImageView.image = [UIImage imageNamed:iconName];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.selectButton];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.hintLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(54);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.iconImageView.mas_top).with.offset(0);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(54);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(5);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.bounds) - 1)
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_none"] forState:(UIControlStateNormal)];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_main"] forState:(UIControlStateSelected)];
        _selectButton.imageView.contentMode = UIViewContentModeCenter;
        _selectButton.userInteractionEnabled = NO;
        _selectButton.selected = NO;
    }
    return _selectButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightLight)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _hintLabel;
}

@end
