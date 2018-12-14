//
//  THNLifeActionView.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeActionView.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "SVProgressHUD+Helper.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

static NSString *const kTextHint        = @"待结算金额需用户确认签收订单后，7个工作日内未发生退款，则可入账并提现。如在7日内有退款行为，扣除相应收益。";
static NSString *const kTextHint1       = @"待结算奖励为好友销售订单还未完成交易，完成后即可入账，如交易失败奖励金额退还。";
static NSString *const kTextSaveImage   = @"保存图片";
static NSString *const kTextCash        = @"提现到微信零钱包";

@interface THNLifeActionView ()

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) THNLifeActionType actionType;
/// 提示文字
@property (nonatomic, strong) YYLabel *hintLabel;
/// 微信二维码图片
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIButton *saveImageButton;
/// 提现
@property (nonatomic, strong) UIButton *cashButton;
@property (nonatomic, strong) UILabel *cashMoneyLabel;
@property (nonatomic, strong) UILabel *cashServiceLabel;
@property (nonatomic, strong) UIImageView *cashIconImageView;

@end

@implementation THNLifeActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)showViewWithType:(THNLifeActionType)type {
    self.actionType = type ? type : THNLifeActionTypeText;
    [self thn_showView];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)thn_setCashMoney:(CGFloat)cashMoney serviceMoney:(CGFloat)serviceMoney {
    self.cashMoneyLabel.text = [NSString stringWithFormat:@"%.2f", cashMoney];
    self.cashServiceLabel.text = [NSString stringWithFormat:@"技术服务费：%.2f", serviceMoney];
}

#pragma mark - event response
- (void)saveImageButtonAction:(UIButton *)button {
    if (self.showImageView.image == nil) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_lifeStoreSaveImage:)]) {
        [self.delegate thn_lifeStoreSaveImage:self.showImageView.image];
    }
}

- (void)cashButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_lifeStoreCashMoney)]) {
        [self.delegate thn_lifeStoreCashMoney];
    }
}

- (void)dismissButtonAction:(UIButton *)button {
    [self thn_showTransform:NO];
    
    if ([self.delegate respondsToSelector:@selector(thn_lifeStoreDismissView)]) {
        [self.delegate thn_lifeStoreDismissView];
    }
}

#pragma mark - private methods
- (void)thn_showView {
    switch (self.actionType) {
        case THNLifeActionTypeText:
        case THNLifeActionTypeInvite: {
            self.hintLabel.hidden = NO;
            [self thn_showHintText];
        }
            break;
         
        case THNLifeActionTypeImage: {
            self.showImageView.hidden = NO;
            self.saveImageButton.hidden = NO;
        }
            break;
            
        case THNLifeActionTypeCash: {
            self.cashButton.hidden = NO;
            self.cashMoneyLabel.hidden = NO;
            self.cashServiceLabel.hidden = NO;
            self.cashIconImageView.hidden = NO;
        }
            break;
    }
}

- (void)thn_showTransform:(BOOL)show {
    CGFloat scale = show ? 1.0 : 0.2;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
        self.saveImageButton.alpha = 1;
    }];
}

- (CGFloat)getContainerWidth {
    if (self.actionType == THNLifeActionTypeImage) {
        return 230.0;
    }
    
    return 280.0;
}

- (CGFloat)getContainerHeight {
    NSDictionary *heightDict = @{@(THNLifeActionTypeText)   : @(115),
                                 @(THNLifeActionTypeInvite) : @(115),
                                 @(THNLifeActionTypeImage)  : @(284),
                                 @(THNLifeActionTypeCash)   : @(260)};
    
    CGFloat height = [(NSNumber *)heightDict[@(self.actionType)] floatValue];
    
    return height;
}

- (void)thn_showHintText {
    NSDictionary *hintText = @{@(THNLifeActionTypeText)   : kTextHint,
                               @(THNLifeActionTypeInvite) : kTextHint1};
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:hintText[@(self.actionType)]];
    att.font = [UIFont systemFontOfSize:12];
    att.color = [UIColor colorWithHexString:@"#333333"];
    att.lineSpacing = 5;
    
    self.hintLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
    
    [self addSubview:self.dismissButton];
    [self.containerView addSubview:self.hintLabel];
    [self.containerView addSubview:self.showImageView];
    [self.containerView addSubview:self.cashIconImageView];
    [self.containerView addSubview:self.cashMoneyLabel];
    [self.containerView addSubview:self.cashServiceLabel];
    [self.containerView addSubview:self.cashButton];
    [self addSubview:self.containerView];
    [self addSubview:self.saveImageButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([self getContainerWidth], [self getContainerHeight]));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    [self.showImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    [self.saveImageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(230, 40));
        make.top.equalTo(self.containerView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.containerView);
    }];
    
    [self.cashIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(57, 57));
        make.centerX.equalTo(self.containerView);
        make.top.mas_equalTo(30);
    }];
    
    [self.cashMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.cashServiceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(135);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.cashButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 40));
        make.bottom.mas_equalTo(-20);
        make.centerX.equalTo(self.containerView);
    }];
    
    [self thn_showTransform:YES];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    [self.saveImageButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

#pragma mark - getters and setters
- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] init];
        _dismissButton.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        [_dismissButton addTarget:self action:@selector(dismissButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _dismissButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    }
    return _containerView;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        _hintLabel.numberOfLines = 0;
        _hintLabel.hidden = YES;
    }
    return _hintLabel;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.image = [UIImage imageWithContentsOfFile: \
                                [[NSBundle mainBundle] pathForResource:@"image_life_wechat" ofType:@".png"]];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.hidden = YES;
    }
    return _showImageView;
}

- (UIButton *)saveImageButton {
    if (!_saveImageButton) {
        _saveImageButton = [[UIButton alloc] init];
        _saveImageButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_saveImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_saveImageButton setTitle:kTextSaveImage forState:(UIControlStateNormal)];
        _saveImageButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveImageButton addTarget:self action:@selector(saveImageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _saveImageButton.alpha = 0.5;
        _saveImageButton.hidden = YES;
    }
    return _saveImageButton;
}

- (UIButton *)cashButton {
    if (!_cashButton) {
        _cashButton = [[UIButton alloc] init];
        _cashButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_cashButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_cashButton setTitle:kTextCash forState:(UIControlStateNormal)];
        _cashButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cashButton.layer.cornerRadius = 4;
        [_cashButton addTarget:self action:@selector(cashButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _cashButton.hidden = YES;
    }
    return _cashButton;
}

- (UILabel *)cashMoneyLabel {
    if (!_cashMoneyLabel) {
        _cashMoneyLabel = [[UILabel alloc] init];
        _cashMoneyLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightMedium)];
        _cashMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _cashMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _cashMoneyLabel.hidden = YES;
    }
    return _cashMoneyLabel;
}

- (UILabel *)cashServiceLabel {
    if (!_cashServiceLabel) {
        _cashServiceLabel = [[UILabel alloc] init];
        _cashServiceLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _cashServiceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cashServiceLabel.textAlignment = NSTextAlignmentCenter;
        _cashServiceLabel.hidden = YES;
    }
    return _cashServiceLabel;
}

- (UIImageView *)cashIconImageView {
    if (!_cashIconImageView) {
        _cashIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cash_gold"]];
        _cashIconImageView.hidden = YES;
    }
    return _cashIconImageView;
}

@end
