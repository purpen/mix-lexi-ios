//
//  THNMyCenterHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNMyCenterHeaderView.h"
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"
#import "UIImageView+SDWedImage.h"
#import "THNMyCenterDataButton.h"
#import "THNMarco.h"

static NSString *const kTextFollow   = @"关注";
static NSString *const kTextFans     = @"粉丝";
static NSString *const kTextLiked    = @"已喜欢";
static NSString *const kTextCollect  = @"收藏";
static NSString *const kTextStore    = @"设计馆";
static NSString *const kTextDynamic  = @"动态";
static NSString *const kTextOrder    = @"我的订单";
static NSInteger const kSelectedButtonTag = 452;

@interface THNMyCenterHeaderView ()

/// 喜欢、收藏等数据视图容器
@property (nonatomic, strong) UIView *dataContainer;
/// 头像
@property (nonatomic, strong) UIImageView *headerImageView;
/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
/// 关注数
@property (nonatomic, strong) YYLabel *followLabel;
@property (nonatomic, assign) CGFloat followWidth;
/// 粉丝数
@property (nonatomic, strong) YYLabel *fansLabel;
@property (nonatomic, assign) CGFloat fansWidth;
/// 签名
@property (nonatomic, strong) YYLabel *signatureLabel;
@property (nonatomic, assign) CGFloat signatureHeight;
/// 动态按钮
@property (nonatomic, strong) UIButton *dynamicButton;
/// 底部功能视图
@property (nonatomic, strong) UIView *bottomView;
/// 客服按钮
@property (nonatomic, strong) UIButton *serviceButton;
/// 优惠券按钮
@property (nonatomic, strong) UIButton *couponButton;
/// 优惠券提示
@property (nonatomic, strong) UIView *couponDotView;
/// 订单按钮
@property (nonatomic, strong) UIButton *orderButton;
/// 活动按钮
@property (nonatomic, strong) UIButton *activityButton;
/// 记录数据按钮
@property (nonatomic, strong) NSMutableArray *dataButtonArray;
@property (nonatomic, strong) THNMyCenterDataButton *selectedButton;
/// 分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation THNMyCenterHeaderView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setUserInfoModel:(THNUserModel *)model {
    self.nameLabel.text = model.username;
    [self.headerImageView downloadImage:model.avatar place:[UIImage new]];
    [self thn_setFollowLabelTextWithValue:model.followed_users_counts];
    [self thn_setFansLabelTextWithValue:model.fans_counts];
    [self thn_setSignatureLabelTextWith:model.about_me];
    [self thn_showCouponDot:YES];
    
    NSArray *valueArr = @[[NSString stringWithFormat:@"%zi", model.user_like_counts],
                          [NSString stringWithFormat:@"%zi", model.wish_list_counts],
                          [NSString stringWithFormat:@"%zi", model.followed_stores_counts]];
    
    for (NSUInteger idx = 0; idx < valueArr.count; idx ++) {
        THNMyCenterDataButton *dataButton = (THNMyCenterDataButton *)self.dataButtonArray[idx];
        [dataButton setDataValue:valueArr[idx]];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - private methods
/**
 设置关注人数量
 */
- (void)thn_setFollowLabelTextWithValue:(NSInteger)value {
    NSString *jointStr = [NSString stringWithFormat:@"%@ %zi", kTextFollow, value];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:jointStr];
    attStr.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    attStr.color = [UIColor colorWithHexString:@"#333333"];
    [attStr setTextHighlightRange:NSMakeRange(0, kTextFollow.length)
                               color:[UIColor colorWithHexString:@"#949EA6"]
                     backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                           tapAction:nil];
    self.followLabel.attributedText = attStr;
    
    // 关注人数的动态宽度
    self.followWidth = [self.followLabel thn_getLabelWidthWithMaxHeight:12];
}

/**
 设置粉丝数量
 */
- (void)thn_setFansLabelTextWithValue:(NSInteger)value {
    NSString *jointStr = [NSString stringWithFormat:@"%@ %zi", kTextFans, value];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:jointStr];
    attStr.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    attStr.color = [UIColor colorWithHexString:@"#333333"];
    [attStr setTextHighlightRange:NSMakeRange(0, kTextFans.length)
                                  color:[UIColor colorWithHexString:@"#949EA6"]
                        backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                              tapAction:nil];
    self.fansLabel.attributedText = attStr;
    
    // 粉丝人数的动态宽度
    self.fansWidth = [self.fansLabel thn_getLabelWidthWithMaxHeight:12];
}

/**
 设置用户签名
 */
- (void)thn_setSignatureLabelTextWith:(NSString *)signature {
    signature = !signature.length ? @"" : signature;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:signature];
    attStr.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
    attStr.lineSpacing = 6;
    attStr.color = [UIColor colorWithHexString:@"#555555"];
    self.signatureLabel.attributedText = attStr;
    
    // 签名的动态高度
    self.signatureHeight = [self.signatureLabel thn_getLabelHeightWithMaxWidth:SCREEN_WIDTH - 40];
    self.signatureHeight = self.signatureHeight > 44 ? 44 : self.signatureHeight;
}

/**
 显示优惠券提示小红点
 */
- (void)thn_showCouponDot:(BOOL)show {
    self.couponDotView.hidden = !show;
}

#pragma mark - event response
- (void)selectedButtonAction:(UIButton *)button {
    if (button.tag < kSelectedButtonTag + 3) {
        self.selectedButton.selected = NO;
        button.selected = YES;
        self.selectedButton = (THNMyCenterDataButton *)button;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_selectedButtonType:)]) {
        [self.delegate thn_selectedButtonType:(THNHeaderViewSelectedType)button.tag - kSelectedButtonTag];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.followLabel];
    [self addSubview:self.fansLabel];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.activityButton];
    [self.bottomView addSubview:self.orderButton];
    [self.bottomView addSubview:self.couponButton];
    [self.bottomView addSubview:self.couponDotView];
    [self.bottomView addSubview:self.serviceButton];
    [self addSubview:self.lineView];
    
    [self creatDataButtonWithTitles:@[kTextLiked, kTextCollect, kTextStore]];
    [self.dataContainer addSubview:self.dynamicButton];
    [self addSubview:self.dataContainer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(24);
    }];
    [self.headerImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:70/2];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.top.equalTo(self.headerImageView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(20);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(self.followWidth);
    }];
    
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followLabel.mas_right).with.offset(20);
        make.centerY.mas_equalTo(self.followLabel);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(self.fansWidth);
    }];
    
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(self.signatureHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];
    self.activityButton.layer.cornerRadius = 30/2;
    
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 30));
        make.left.equalTo(self.activityButton.mas_right).with.offset(15);
        make.bottom.mas_equalTo(-20);
    }];
    self.orderButton.layer.cornerRadius = 30/2;
    [self.orderButton drawViewBorderType:(UIViewBorderLineTypeAll) width:1 color:[UIColor colorWithHexString:@"#EDEDEF"]];
    
    [self.serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
    self.serviceButton.layer.cornerRadius = 30/2;
    [self.serviceButton drawViewBorderType:(UIViewBorderLineTypeAll) width:1 color:[UIColor colorWithHexString:@"#EDEDEF"]];
    
    [self.couponButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self.serviceButton.mas_left).with.offset(-15);
        make.bottom.mas_equalTo(-20);
    }];
    self.couponButton.layer.cornerRadius = 30/2;
    [self.couponButton drawViewBorderType:(UIViewBorderLineTypeAll) width:1 color:[UIColor colorWithHexString:@"#EDEDEF"]];
    
    [self.couponDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 7));
        make.right.equalTo(self.couponButton.mas_right).with.offset(-5);
        make.top.equalTo(self.couponButton.mas_top).with.offset(0);
    }];
    [self.couponDotView drawCornerWithType:(UILayoutCornerRadiusAll) radius:7/2];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.dataContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(kDeviceiPhone5 ? 30 : 40);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(28);
    }];
    
    [self.dataButtonArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    [self.dataButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
    
    [self.dynamicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.dataContainer);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.dynamicButton.layer.cornerRadius = 4;
    [self.dynamicButton drawViewBorderType:(UIViewBorderLineTypeAll) width:1 color:[UIColor colorWithHexString:@"#EDEDEF"]];
    
    // 调整视图的高度
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230 + self.signatureHeight);
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.backgroundColor = [UIColor colorWithHexString:@"#EDEDEF"];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (YYLabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[YYLabel alloc] init];
        _followLabel.font = [UIFont systemFontOfSize:12];
    }
    return _followLabel;
}

- (YYLabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [[YYLabel alloc] init];
        _fansLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fansLabel;
}

- (YYLabel *)signatureLabel {
    if (!_signatureLabel) {
        _signatureLabel = [[YYLabel alloc] init];
        _signatureLabel.font = [UIFont systemFontOfSize:13];
        _signatureLabel.displaysAsynchronously = YES;
        _signatureLabel.numberOfLines = 2;
    }
    return _signatureLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)activityButton {
    if (!_activityButton) {
        _activityButton = [[UIButton alloc] init];
        [_activityButton setImage:[UIImage imageNamed:@"icon_activity_white"] forState:(UIControlStateNormal)];
        _activityButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        _activityButton.tag = kSelectedButtonTag + 4;
        [_activityButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _activityButton;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [[UIButton alloc] init];
        [_orderButton setTitle:kTextOrder forState:(UIControlStateNormal)];
        _orderButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_orderButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _orderButton.tag = kSelectedButtonTag + 5;
        [_orderButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _orderButton;
}

- (UIButton *)couponButton {
    if (!_couponButton) {
        _couponButton = [[UIButton alloc] init];
        [_couponButton setImage:[UIImage imageNamed:@"icon_coupon_gray"] forState:(UIControlStateNormal)];
        _couponButton.tag = kSelectedButtonTag + 6;
        [_couponButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _couponButton;
}

- (UIView *)couponDotView {
    if (!_couponDotView) {
        _couponDotView = [[UIView alloc] init];
        _couponDotView.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        _couponDotView.hidden = YES;
    }
    return _couponDotView;
}

- (UIButton *)serviceButton {
    if (!_serviceButton) {
        _serviceButton = [[UIButton alloc] init];
        [_serviceButton setImage:[UIImage imageNamed:@"icon_service_gray"] forState:(UIControlStateNormal)];
        _serviceButton.tag = kSelectedButtonTag + 7;
        [_serviceButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _serviceButton;
}

#pragma mark -
- (UIView *)dataContainer {
    if (!_dataContainer) {
        _dataContainer = [[UIView alloc] init];
    }
    return _dataContainer;
}

- (void)creatDataButtonWithTitles:(NSArray *)titles {
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        THNMyCenterDataButton *dataButton = [[THNMyCenterDataButton alloc] init];
        dataButton.titleText = titles[idx];
        dataButton.tag = kSelectedButtonTag + idx;
        if (dataButton.tag == kSelectedButtonTag) {
            dataButton.selected = YES;
            self.selectedButton = dataButton;
        }
        [dataButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.dataContainer addSubview:dataButton];
        [self.dataButtonArray addObject:dataButton];
    }
}

- (UIButton *)dynamicButton {
    if (!_dynamicButton) {
        _dynamicButton = [[UIButton alloc] init];
        [_dynamicButton setTitle:kTextDynamic forState:(UIControlStateNormal)];
        _dynamicButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_dynamicButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _dynamicButton.tag = kSelectedButtonTag + 3;
        [_dynamicButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _dynamicButton;
}

- (NSMutableArray *)dataButtonArray {
    if (!_dataButtonArray) {
        _dataButtonArray = [NSMutableArray array];
    }
    return _dataButtonArray;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDEF"];
    }
    return _lineView;
}

@end
