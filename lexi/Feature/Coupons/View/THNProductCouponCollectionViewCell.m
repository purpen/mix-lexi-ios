//
//  THNProductCouponCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNProductCouponCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIImageView+WebImage.h"
#import "UIColor+Extension.h"
#import "NSString+Helper.h"
#import "THNCouponManager.h"
#import "SVProgressHUD+Helper.h"
#import "THNGoodsInfoViewController.h"
#import "THNLoginManager.h"

@interface THNProductCouponCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UIImageView *hintImageView;
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *conditionLabel;
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) YYLabel *priceLabel;
@property (nonatomic, strong) YYLabel *oriPriceLabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIImageView *noneImageView;
@property (nonatomic, strong) UIView *noneView;
@property (nonatomic, strong) THNCouponSingleModel *couponModel;

@end

@implementation THNProductCouponCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setProductCouponModel:(THNCouponSingleModel *)model {
    self.couponModel = model;
    
    [self.goodsImageView loadImageWithUrl:[model.productCover loadImageUrlWithType:(THNLoadImageUrlTypeWindowMd)]];
    self.titleLabel.text = model.productName;
    self.priceLabel.text = [NSString formatFloat:model.productAmount];
    [self thn_setCouponAmoutTextWithValue:model.amount];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%zi可用", model.minAmount];
    [self thn_setOriginalPriceWithValue:model.productCouponAmount];
    [self thn_setNoneCouponStyleWithCount:model.surplusCount];
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
        if (!self.couponModel.couponCode.length && !self.couponModel.storeRid.length) {
            return;
        }
        
        [THNCouponManager getCouponWithRid:self.couponModel.couponCode
                                   storeId:self.couponModel.storeRid
                                completion:^(BOOL success) {
                                    if (!success) {
                                        [SVProgressHUD thn_showInfoWithStatus:@"领取失败"];
                                        return ;
                                    }
                                    
                                    [SVProgressHUD thn_showSuccessWithStatus:@"领取成功"];
                                    [self thn_setDoneButtonStatus:success];
                                }];
        
    } else {
        [self thn_openGoodsInfoControllerWithRid:self.couponModel.productRid];
    }
}

- (void)goodsImageViewAction:(UITapGestureRecognizer *)tap {
    if (!self.couponModel.couponCode.length && !self.couponModel.storeRid.length) {
        return;
    }
    
    [self thn_openGoodsInfoControllerWithRid:self.couponModel.productRid];
}

#pragma mark - private methods
/**
 打开商品详情
 */
- (void)thn_openGoodsInfoControllerWithRid:(NSString *)goodsId {
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:goodsId];
    [self.currentVC.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)thn_setNoneCouponStyleWithCount:(NSInteger)count {
    self.headerView.alpha = count ? 1 : 0.4;
    self.noneView.hidden = count;
    self.noneImageView.hidden = count;
}

- (void)thn_setCouponAmoutTextWithValue:(NSInteger)value {
    NSMutableAttributedString *sysAtt = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    sysAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    sysAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    NSMutableAttributedString *amoutAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi", value]];
    amoutAtt.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightMedium)];
    amoutAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    [sysAtt appendAttributedString:amoutAtt];
    self.moneyLabel.attributedText = sysAtt;
}

- (void)thn_setOriginalPriceWithValue:(CGFloat)value {
    if (value == 0) {
        self.oriPriceLabel.hidden = YES;
        return;
    }
    
    NSString *originalPriceStr = [NSString formatFloat:value];
    NSMutableAttributedString *originalPriceAtt = [[NSMutableAttributedString alloc] initWithString:originalPriceStr];
    originalPriceAtt.color = [UIColor colorWithHexString:@"#999999"];
    originalPriceAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    originalPriceAtt.alignment = NSTextAlignmentRight;
    originalPriceAtt.textStrikethrough = [YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle)];
    
    self.oriPriceLabel.hidden = NO;
    self.oriPriceLabel.attributedText = originalPriceAtt;
}

// 领取按钮的状态
- (void)thn_setDoneButtonStatus:(BOOL)status {
    self.couponModel.isGrant = status;
    self.doneButton.selected = status;
    
    self.doneButton.backgroundColor = [UIColor colorWithHexString:@"#FF6B34" alpha:status ? 0 : 1];
    self.doneButton.layer.borderColor = [UIColor colorWithHexString:@"#FF6B34" alpha:status ? 1 : 0].CGColor;
    self.doneButton.layer.borderWidth = 1;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self.containerView addSubview:self.goodsImageView];
    [self.containerView addSubview:self.hintImageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.priceLabel];
    [self.containerView addSubview:self.oriPriceLabel];
    [self.headerView addSubview:self.doneButton];
    [self.headerView addSubview:self.moneyLabel];
    [self.headerView addSubview:self.conditionLabel];
    [self.containerView addSubview:self.headerView];
    [self addSubview:self.containerView];
    [self addSubview:self.noneView];
    [self addSubview:self.noneImageView];
}

- (void)updateConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.top.right.mas_equalTo(0);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-90);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(21);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-90);
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(3);
        make.height.mas_equalTo(12);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 24));
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.bounds) - 20, CGRectGetWidth(self.bounds) - 20));
        make.top.mas_equalTo(54);
        make.centerX.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_offset(-10);
        make.top.equalTo(self.goodsImageView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(16);
    }];
    
    [self.hintImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 13));
        make.left.mas_equalTo(10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(7);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(-65);
    }];
    
    [self.oriPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(14);
        make.left.equalTo(self.priceLabel.mas_right).with.offset(5);
    }];
    
    [self.noneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 52));
        make.top.right.equalTo(self.goodsImageView).with.offset(0);
    }];
    
    [self.noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.bounds) - 20, CGRectGetWidth(self.bounds) - 20));
        make.top.mas_equalTo(54);
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#FFF0EA"];
    }
    return _headerView;
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.backgroundColor = [UIColor whiteColor];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.cornerRadius = 2;
        _goodsImageView.layer.masksToBounds = YES;
        _goodsImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsImageViewAction:)];
        [_goodsImageView addGestureRecognizer:tap];
    }
    return _goodsImageView;
}

- (UIImageView *)hintImageView {
    if (!_hintImageView) {
        _hintImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price_tag_1"]];
    }
    return _hintImageView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    return _priceLabel;
}

- (YYLabel *)oriPriceLabel {
    if (!_oriPriceLabel) {
        _oriPriceLabel = [[YYLabel alloc] init];
    }
    return _oriPriceLabel;
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
    }
    return _conditionLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:@"#FF6B34"];
        [_doneButton setTitle:@"立即领取" forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_doneButton setTitle:@"去使用" forState:(UIControlStateSelected)];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"#FF6B34"] forState:(UIControlStateSelected)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
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

- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] init];
        _noneView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        _noneView.hidden = YES;
    }
    return _noneView;
}

@end
