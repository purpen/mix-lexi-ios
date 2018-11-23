//
//  THNOfficialCouponCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/1.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNOfficialCouponCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNCouponManager.h"
#import "SVProgressHUD+Helper.h"
#import "THNLoginManager.h"
#import "THNBaseTabBarController.h"

@interface THNOfficialCouponCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) YYLabel *hintLabel;
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *conditionLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIImageView *noneImageView;
@property (nonatomic, strong) THNCouponOfficialModel *couponModel;

@end

@implementation THNOfficialCouponCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setOfficialModel:(THNCouponOfficialModel *)model {
    self.couponModel = model;
    
    [self thn_setCouponAmoutTextWithValue:model.amount];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%.0f元可用", model.minAmount];
    [self thn_setCouponStatusWithCount:model.count];
    [self thn_setDoneButtonStatus:self.couponModel.isGrant];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }
    
    if (button.selected == NO) {
        if (!self.couponModel.code.length) {
            return;
        }
        
        [THNCouponManager getOfficialCouponWithRid:self.couponModel.code completion:^(BOOL success) {
            if (!success) {
                [SVProgressHUD thn_showInfoWithStatus:@"领取失败"];
                return ;
            }
            
            [SVProgressHUD thn_showSuccessWithStatus:@"领取成功"];
            [self thn_setDoneButtonStatus:success];
        }];
    
    } else {
        [self.currentVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - private methods
- (void)thn_setCouponAmoutTextWithValue:(CGFloat)value {
    NSMutableAttributedString *sysAtt = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    sysAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    sysAtt.color = [UIColor whiteColor];
    
    NSMutableAttributedString *amoutAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", value]];
    amoutAtt.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightMedium)];
    amoutAtt.color = [UIColor whiteColor];
    
    [sysAtt appendAttributedString:amoutAtt];
    sysAtt.alignment = NSTextAlignmentCenter;
    self.moneyLabel.attributedText = sysAtt;
}

- (void)thn_setCouponStatusWithCount:(NSInteger)count {
    self.noneImageView.hidden = count;
    self.containerView.alpha = count ? 1 : 0.4;
}

// 领取按钮的状态
- (void)thn_setDoneButtonStatus:(BOOL)status {
    self.couponModel.isGrant = status;
    self.doneButton.selected = status;
    self.doneButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:status ? 0 : 1];
    self.doneButton.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:status ? 1 : 0].CGColor;
    self.doneButton.layer.borderWidth = 1;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];

    [self addSubview:self.backgroundImageView];
    [self addSubview:self.hintLabel];
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.conditionLabel];
    [self.containerView addSubview:self.doneButton];
    [self addSubview:self.containerView];
    [self addSubview:self.noneImageView];
}

- (void)updateConstraints {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 128));
        make.left.top.mas_equalTo(0);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 10));
        make.top.mas_equalTo(6);
        make.centerX.equalTo(self);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(12);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 24));
        make.bottom.mas_equalTo(-15);
        make.centerX.equalTo(self);
    }];
    
    [self.noneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 52));
        make.top.right.mas_equalTo(0);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_official_bg_line"]];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backgroundImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F" alpha:0];
    }
    return _containerView;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:9 weight:(UIFontWeightMedium)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"乐喜券";
    }
    return _hintLabel;
}

- (YYLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[YYLabel alloc] init];
    }
    return _moneyLabel;
}

- (YYLabel *)conditionLabel {
    if (!_conditionLabel) {
        _conditionLabel = [[YYLabel alloc] init];
        _conditionLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
        _conditionLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _conditionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _conditionLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor whiteColor];
        [_doneButton setTitle:@"立即领取" forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"#FD7162"] forState:(UIControlStateNormal)];
        [_doneButton setTitle:@"去使用" forState:(UIControlStateSelected)];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateSelected)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
        _doneButton.layer.cornerRadius = 12;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (UIImageView *)noneImageView {
    if (!_noneImageView) {
        _noneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_none_white"]];
        _noneImageView.hidden = YES;
    }
    return _noneImageView;
}

@end
