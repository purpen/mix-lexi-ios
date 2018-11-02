//
//  THNStoreCouponCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNStoreCouponCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIImageView+SDWedImage.h"
#import "UIColor+Extension.h"
#import "THNCouponGoodsView.h"
#import "THNMarco.h"

@interface THNStoreCouponCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *storeLogoImageView;
@property (nonatomic, strong) YYLabel *storeNameLabel;
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *hintLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *goodsView;

@end

@implementation THNStoreCouponCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setStoreCouponModel:(THNCouponSharedModel *)model {
    [self.storeLogoImageView downloadImage:[model.storeLogo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                     place:[UIImage imageNamed:@"default_image_place"]];
    
    self.storeNameLabel.text = model.storeName;
    [self thn_setCouponAmoutTextWithValue:model.amount minAmout:model.minAmount];
    [self thn_createGoodsViewWithSkus:model.productSku];
}

#pragma mark - private methods
- (void)thn_setCouponAmoutTextWithValue:(NSInteger)value minAmout:(NSInteger)minAmout {
    NSMutableAttributedString *sysAtt = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    sysAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    sysAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    NSMutableAttributedString *amoutAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi", value]];
    amoutAtt.font = [UIFont systemFontOfSize:28 weight:(UIFontWeightMedium)];
    amoutAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    [sysAtt appendAttributedString:amoutAtt];
    
    NSString *minAmoutStr = [NSString stringWithFormat:@"  满%zi可用", minAmout];
    NSMutableAttributedString *minAmoutAtt = [[NSMutableAttributedString alloc] initWithString:minAmoutStr];
    minAmoutAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    minAmoutAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    
    [sysAtt appendAttributedString:minAmoutAtt];
    
    self.moneyLabel.attributedText = sysAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self.containerView addSubview:self.storeLogoImageView];
    [self.containerView addSubview:self.storeNameLabel];
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.hintLabel];
    [self.containerView addSubview:self.doneButton];
    [self.containerView addSubview:self.goodsView];
    [self addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.storeLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.top.left.mas_equalTo(10);
    }];
    
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(16);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.right.mas_equalTo(-100);
        make.bottom.equalTo(self.storeLogoImageView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 14));
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(20);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 24));
        make.bottom.equalTo(self.storeLogoImageView.mas_bottom).with.offset(0);
        make.right.mas_equalTo(-10);
    }];
    
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(75);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#FFF0EA"];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIImageView *)storeLogoImageView {
    if (!_storeLogoImageView) {
        _storeLogoImageView = [[UIImageView alloc] init];
        _storeLogoImageView.backgroundColor = [UIColor whiteColor];
        _storeLogoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeLogoImageView.layer.cornerRadius = 5;
        _storeLogoImageView.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
        _storeLogoImageView.layer.borderWidth = 0.5;
        _storeLogoImageView.layer.masksToBounds = YES;
    }
    return _storeLogoImageView;
}

- (YYLabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[YYLabel alloc] init];
        _storeNameLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _storeNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _storeNameLabel;
}

- (YYLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[YYLabel alloc] init];
    }
    return _moneyLabel;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#FF6B34"];
        _hintLabel.textAlignment = NSTextAlignmentRight;
        _hintLabel.text = @"正在疯抢";
    }
    return _hintLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:@"#FF6B34"];
        [_doneButton setTitle:@"进店领券" forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_doneButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -25, 0, 0))];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
        [_doneButton setImage:[UIImage imageNamed:@"icon_arrow_circle_0"] forState:(UIControlStateNormal)];
        [_doneButton setImageEdgeInsets:(UIEdgeInsetsMake(6, 64, 7, 13))];
        _doneButton.layer.cornerRadius = 12;
    }
    return _doneButton;
}

- (UIView *)goodsView {
    if (!_goodsView) {
        _goodsView = [[UIView alloc] init];
        _goodsView.backgroundColor = [UIColor whiteColor];
    }
    return _goodsView;
}

- (void)thn_createGoodsViewWithSkus:(NSArray *)skus {
    if (self.goodsView.subviews.count > 1) {
        return;
    }
    
    CGFloat viewW = (SCREEN_WIDTH - 72) / skus.count;
    
    for (NSUInteger idx = 0; idx < skus.count; idx ++) {
        THNCouponSharedModelProductSku *skuModel = (THNCouponSharedModelProductSku *)skus[idx];
        THNCouponGoodsView *goodsView = [[THNCouponGoodsView alloc] initWithFrame: \
                                         CGRectMake(11 + (viewW + 10) * idx, 15, viewW, viewW * 1.53)];
        [goodsView thn_setStoreCouponGoodsSku:skuModel];
        [self.goodsView addSubview:goodsView];
    }
}

@end
