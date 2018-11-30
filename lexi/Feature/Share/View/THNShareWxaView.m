//
//  THNShareWxaView.m
//  lexi
//
//  Created by FLYang on 2018/11/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareWxaView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "THNMarco.h"
#import "UIImageView+WebImage.h"

static NSString *const kTextSellGoods   = @"朋友通过你分享的此链接和图片购买商品，你即可赚取相应收益! 收益仅自己可见";
static NSString *const kTextHintWechat  = @"点击直接分享好友样式";
static NSString *const kTextWechat      = @"微信好友";
static NSString *const kTextHintImage   = @"保存分享朋友圈海报";
static NSString *const kTextImage       = @"保存分享";
static NSString *const kTextCancel      = @"取消";

@interface THNShareWxaView ()

/// 销售商品时显示
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *sellHintLabel;
/// 小程序
@property (nonatomic, strong) UIView *wxaContainerView;
@property (nonatomic, strong) UIImageView *wxaImageView;
@property (nonatomic, strong) YYLabel *wxaHintLabel;
@property (nonatomic, strong) UIButton *wxaButton;
/// 预览图片
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *saveImageView;
@property (nonatomic, strong) YYLabel *saveHintLabel;
@property (nonatomic, strong) UIButton *saveButton;
/// 取消
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation THNShareWxaView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(THNShareWxaViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = type;
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setSellGoodsMoeny:(CGFloat)money {
    self.moneyLabel.text = [NSString stringWithFormat:@"赚 ￥%.2f", money];
    self.moneyLabel.hidden = NO;
    self.sellHintLabel.hidden = NO;
}

- (void)thn_setSharePosterImageUrl:(NSString *)imageUrl {
    [self.saveImageView downloadImage:imageUrl];
}

#pragma mark - event response
- (void)cancelButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_cancelShare)]) {
        [self.delegate thn_cancelShare];
    }
}

- (void)thn_wxaImageViewTap:(UITapGestureRecognizer *)tap {
    if (!self.wxaImageView.image) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_reviewSharePosterImage:)]) {
        [self.delegate thn_reviewSharePosterImage:self.wxaImageView.image];
    }
}

- (void)thn_saveImageViewTap:(UITapGestureRecognizer *)tap {
    if (!self.saveImageView.image) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_reviewSharePosterImage:)]) {
        [self.delegate thn_reviewSharePosterImage:self.saveImageView.image];
    }
}

- (void)wxaButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_shareToWechat)]) {
        [self.delegate thn_shareToWechat];
    }
}

- (void)saveButtonAction:(UIButton *)button {
    if (!self.saveImageView.image) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_savePosterImage:)]) {
        [self.delegate thn_savePosterImage:self.saveImageView.image];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.moneyLabel];
    [self addSubview:self.sellHintLabel];
    
    [self.wxaContainerView addSubview:self.wxaImageView];
    [self.wxaContainerView addSubview:self.wxaHintLabel];
    [self addSubview:self.wxaContainerView];
    [self addSubview:self.wxaButton];
    
    [self.imageContainerView addSubview:self.saveImageView];
    [self.imageContainerView addSubview:self.saveHintLabel];
    [self addSubview:self.imageContainerView];
    [self addSubview:self.saveButton];
    
    [self addSubview:self.cancelButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    CGFloat containerW = (kScreenWidth - 30) / 2;
    
    /// 微信小程序
    [self.wxaContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(containerW, containerW));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo([self originY]);
    }];
    
    
    [self.wxaHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.left.mas_equalTo(10);
        make.bottom.right.mas_equalTo(-10);
    }];
    
    [self.wxaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.wxaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 70));
        make.centerX.equalTo(self.wxaContainerView);
        make.top.equalTo(self.wxaContainerView.mas_bottom).with.offset(25);
    }];
    
    /// 保存图片
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(containerW, containerW));
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo([self originY]);
    }];
    
    [self.saveHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.left.mas_equalTo(10);
        make.bottom.right.mas_equalTo(-10);
    }];
    
    [self.saveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 70));
        make.centerX.equalTo(self.imageContainerView);
        make.top.equalTo(self.imageContainerView.mas_bottom).with.offset(25);
    }];
    
    /// 取消
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kDeviceiPhoneX ? 72 : 40);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    /// 卖货
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280, 15));
        make.top.mas_equalTo(15);
        make.centerX.equalTo(self);
    }];
    
    [self.sellHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 35));
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.wxaContainerView drawViewBorderType:(UIViewBorderLineTypeAll) width:1 color:[UIColor colorWithHexString:@"#E9E9E9"]];
    [self.imageContainerView drawViewBorderType:(UIViewBorderLineTypeAll) width:1 color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

- (CGFloat)originY {
    return self.viewType == THNShareWxaViewTypeSellGoods ? 90 : 20;
}

#pragma mark - getters and setters
- (YYLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[YYLabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _moneyLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightBold)];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.hidden = YES;
    }
    return _moneyLabel;
}

- (YYLabel *)sellHintLabel {
    if (!_sellHintLabel) {
        _sellHintLabel = [[YYLabel alloc] init];
        _sellHintLabel.numberOfLines = 2;
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextSellGoods];
        att.font = [UIFont systemFontOfSize:12];
        att.color = [UIColor colorWithHexString:@"#999999"];
        att.lineSpacing = 5;
        
        _sellHintLabel.attributedText = att;
        _sellHintLabel.hidden = YES;
    }
    return _sellHintLabel;
}

- (UIView *)wxaContainerView {
    if (!_wxaContainerView) {
        _wxaContainerView = [[UIView alloc] init];
        _wxaContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _wxaContainerView;
}

- (UIImageView *)wxaImageView {
    if (!_wxaImageView) {
        _wxaImageView = [[UIImageView alloc] init];
        _wxaImageView.contentMode = UIViewContentModeScaleAspectFit;
        _wxaImageView.backgroundColor = [UIColor whiteColor];
        _wxaImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thn_wxaImageViewTap:)];
        [_wxaImageView addGestureRecognizer:tap];
    }
    return _wxaImageView;
}

- (YYLabel *)wxaHintLabel {
    if (!_wxaHintLabel) {
        _wxaHintLabel = [[YYLabel alloc] init];
        _wxaHintLabel.font = [UIFont systemFontOfSize:11];
        _wxaHintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _wxaHintLabel.textAlignment = NSTextAlignmentCenter;
        _wxaHintLabel.text = kTextHintWechat;
    }
    return _wxaHintLabel;
}

- (UIButton *)wxaButton {
    if (!_wxaButton) {
        _wxaButton = [[UIButton alloc] init];
        [_wxaButton setImage:[UIImage imageNamed:@"icon_wechat_circle"] forState:(UIControlStateNormal)];
        [_wxaButton setTitle:kTextWechat forState:(UIControlStateNormal)];
        [_wxaButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _wxaButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_wxaButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 10, 0, 0)];
        [_wxaButton setTitleEdgeInsets:(UIEdgeInsetsMake(50, -40, 0, 0))];
        [_wxaButton addTarget:self action:@selector(wxaButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _wxaButton;
}

- (UIView *)imageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _imageContainerView;
}

- (UIImageView *)saveImageView {
    if (!_saveImageView) {
        _saveImageView = [[UIImageView alloc] init];
        _saveImageView.contentMode = UIViewContentModeScaleAspectFit;
        _saveImageView.backgroundColor = [UIColor whiteColor];
        _saveImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thn_saveImageViewTap:)];
        [_saveImageView addGestureRecognizer:tap];
    }
    return _saveImageView;
}

- (YYLabel *)saveHintLabel {
    if (!_saveHintLabel) {
        _saveHintLabel = [[YYLabel alloc] init];
        _saveHintLabel.font = [UIFont systemFontOfSize:11];
        _saveHintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _saveHintLabel.textAlignment = NSTextAlignmentCenter;
        _saveHintLabel.text = kTextHintImage;
    }
    return _saveHintLabel;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setImage:[UIImage imageNamed:@"icon_share_save"] forState:(UIControlStateNormal)];
        [_saveButton setTitle:kTextImage forState:(UIControlStateNormal)];
        [_saveButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_saveButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 10, 0, 0)];
        [_saveButton setTitleEdgeInsets:(UIEdgeInsetsMake(50, -40, 0, 0))];
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:kTextCancel forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleEdgeInsets:(UIEdgeInsetsMake(kDeviceiPhoneX ? -25 : 0, 0, 0, 0))];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelButton;
}

@end
