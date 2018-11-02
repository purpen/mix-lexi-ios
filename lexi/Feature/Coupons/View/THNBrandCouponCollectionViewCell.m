//
//  THNBrandCouponCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBrandCouponCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIImageView+SDWedImage.h"
#import "UIColor+Extension.h"

@interface THNBrandCouponCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *storeImageView;
@property (nonatomic, strong) UIImageView *storeLogoImageView;
@property (nonatomic, strong) UIView *logoShadowView;
@property (nonatomic, strong) UIImageView *amountImageView;
@property (nonatomic, strong) YYLabel *storeNameLabel;
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *conditionLabel;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation THNBrandCouponCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setBrandCouponModel:(THNCouponSharedModel *)model {
    [self.storeImageView downloadImage:[model.storeBgcover loadImageUrlWithType:(THNLoadImageUrlTypeWindowMd)]
                                 place:[UIImage imageNamed:@"default_image_place"]];
    
    [self.storeLogoImageView downloadImage:[model.storeLogo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                     place:[UIImage imageNamed:@"default_image_place"]];
    
    self.storeNameLabel.text = model.storeName;
    [self thn_setCouponAmoutTextWithValue:model.amount];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%zi可用", model.minAmount];
}

#pragma mark - private methods
- (void)thn_setCouponAmoutTextWithValue:(NSInteger)value {
    NSMutableAttributedString *sysAtt = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    sysAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    sysAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    NSMutableAttributedString *amoutAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi", value]];
    amoutAtt.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightMedium)];
    amoutAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    [sysAtt appendAttributedString:amoutAtt];
    sysAtt.alignment = NSTextAlignmentCenter;
    self.moneyLabel.attributedText = sysAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self.containerView addSubview:self.storeImageView];
    [self.containerView addSubview:self.logoShadowView];
    [self.containerView addSubview:self.storeLogoImageView];
    [self.containerView addSubview:self.amountImageView];
    [self.containerView addSubview:self.storeNameLabel];
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.conditionLabel];
    [self.containerView addSubview:self.doneButton];
    [self addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.storeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(65);
    }];
    
    [self.logoShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.top.mas_equalTo(41);
        make.centerX.equalTo(self);
    }];
    
    [self.storeLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(40);
        make.centerX.equalTo(self);
    }];
    
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.storeLogoImageView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(16);
    }];
    
    [self.amountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(128, 43));
        make.top.equalTo(self.storeNameLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(self.amountImageView.mas_top).with.offset(5);
        make.height.mas_equalTo(21);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(3);
        make.height.mas_equalTo(11);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(133, 30));
        make.bottom.mas_equalTo(-15);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIImageView *)storeImageView {
    if (!_storeImageView) {
        _storeImageView = [[UIImageView alloc] init];
        _storeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeImageView.layer.masksToBounds = YES;
    }
    return _storeImageView;
}

- (UIImageView *)storeLogoImageView {
    if (!_storeLogoImageView) {
        _storeLogoImageView = [[UIImageView alloc] init];
        _storeLogoImageView.backgroundColor = [UIColor whiteColor];
        _storeLogoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeLogoImageView.layer.cornerRadius = 2;
        _storeLogoImageView.layer.masksToBounds = YES;
    }
    return _storeLogoImageView;
}

- (UIView *)logoShadowView {
    if (!_logoShadowView) {
        _logoShadowView = [[UIView alloc] init];
        _logoShadowView.backgroundColor = [UIColor whiteColor];
        _logoShadowView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
        _logoShadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _logoShadowView.layer.shadowRadius = 2;
        _logoShadowView.layer.shadowOpacity = 0.3;
    }
    return _logoShadowView;
}

- (UIImageView *)amountImageView {
    if (!_amountImageView) {
        _amountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_amout_bg"]];
    }
    return _amountImageView;
}

- (YYLabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[YYLabel alloc] init];
        _storeNameLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _storeNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _storeNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _storeNameLabel;
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
        _conditionLabel.font = [UIFont systemFontOfSize:10 weight:(UIFontWeightRegular)];
        _conditionLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _conditionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _conditionLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:@"#FF6B34"];
        [_doneButton setTitle:@"进店领券" forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_doneButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -20, 0, 0))];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        [_doneButton setImage:[UIImage imageNamed:@"icon_arrow_circle_0"] forState:(UIControlStateNormal)];
        [_doneButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 90, 0, 0))];
        _doneButton.layer.cornerRadius = 15;
    }
    return _doneButton;
}


@end
