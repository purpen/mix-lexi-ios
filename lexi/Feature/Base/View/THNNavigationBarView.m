//
//  THNNavigationBarView.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNavigationBarView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UILable+Frame.h"
#import "THNConst.h"
#import "THNMarco.h"

static const NSInteger kRightButtonTag = 123;

@interface THNNavigationBarView ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 左边功能按钮
@property (nonatomic, strong) UIButton *leftButton;
/// 右边功能按钮
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray *rightButtonArr;
/// 返回按钮
@property (nonatomic, strong) UIButton *backButton;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 背景透明时的渐变遮罩
@property (nonatomic, strong) UIView *shadow;
/// 导航栏功能按钮操作
@property (nonatomic, copy) void (^leftButtonActionBlock)(void);
@property (nonatomic, copy) void (^rightButtonActionBlock)(void);

@end

@implementation THNNavigationBarView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - set methods
/**
 设置导航栏透明
 */
- (void)setNavigationTransparent:(BOOL)transparent showShadow:(BOOL)show {
    self.transparent = transparent;
    self.shadow.hidden = !show;
}

/**
 设置标题属性
 */
- (void)setNavigationTitleHidden:(BOOL)hidden {
    self.titleLabel.hidden = hidden;
}

- (void)setNavigationTitle:(NSString *)title {
    [self setNavigationTitle:title textHexColor:kColorNavTitle fontSize:17];
}

- (void)setNavigationTitle:(NSString *)title fontSize:(CGFloat)size {
    [self setNavigationTitle:title textHexColor:kColorNavTitle fontSize:size];
}

- (void)setNavigationTitle:(NSString *)title textHexColor:(NSString *)hexColor {
    [self setNavigationTitle:title textHexColor:hexColor fontSize:17];
}

- (void)setNavigationTitle:(NSString *)title textHexColor:(NSString *)hexColor fontSize:(CGFloat)size {
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:size weight:(UIFontWeightRegular)];
    self.titleLabel.textColor = [UIColor colorWithHexString:hexColor];
}

/**
 设置左边按钮
 */
- (void)setNavigationLeftButtonOfImageNamed:(NSString *)imageName {
    self.leftButton.hidden = NO;
    [self.leftButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [self.leftButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateHighlighted)];
}

- (void)setNavigationLeftButtonOfText:(NSString *)text {
    [self setNavigationLeftButtonOfText:text textHexColor:kColorNavTitle fontSize:17];
}

- (void)setNavigationLeftButtonOfText:(NSString *)text fontSize:(CGFloat)size {
    [self setNavigationLeftButtonOfText:text textHexColor:kColorNavTitle fontSize:size];
}

- (void)setNavigationLeftButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor {
    [self setNavigationLeftButtonOfText:text textHexColor:hexColor fontSize:17];
}

- (void)setNavigationLeftButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor fontSize:(CGFloat)size {
    self.leftButton.hidden = NO;
    [self.leftButton setTitle:text forState:(UIControlStateNormal)];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:hexColor] forState:(UIControlStateNormal)];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:size weight:(UIFontWeightRegular)];
    
    [self setNeedsUpdateConstraints];
}

- (void)didNavigationLeftButtonCompletion:(THNNavigationBarLeftButtonCompletion)completion {
    self.leftButtonActionBlock = completion;
}

/**
 设置右边按钮
 */
- (void)setNavigationRightButtonOfImageNamed:(NSString *)imageName {
    self.rightButton.hidden = NO;
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateHighlighted)];
}

- (void)setNavigationRightButtonOfImageNamedArray:(NSArray *)imageNames {
    if (self.rightButtonArr.count) {
        [self.rightButtonArr removeAllObjects];
    }
    
    for (NSUInteger idx = 0; idx < imageNames.count; idx ++) {
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton setImage:[UIImage imageNamed:imageNames[idx]] forState:(UIControlStateNormal)];
        [rightButton setImage:[UIImage imageNamed:imageNames[idx]] forState:(UIControlStateHighlighted)];
        rightButton.tag = kRightButtonTag + idx;
        [rightButton addTarget:self action:@selector(rightButtonItemsAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.rightButtonArr addObject:rightButton];
    }
    
    [self layoutIfNeeded];
}

- (void)setNavigationRightButtonOfText:(NSString *)text {
    [self setNavigationRightButtonOfText:text textHexColor:kColorNavTitle fontSize:14];
}

- (void)setNavigationRightButtonOfText:(NSString *)text fontSize:(CGFloat)size {
    [self setNavigationRightButtonOfText:text textHexColor:kColorNavTitle fontSize:size];
}

- (void)setNavigationRightButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor {
    [self setNavigationRightButtonOfText:text textHexColor:hexColor fontSize:14];
}

- (void)setNavigationRightButtonOfText:(NSString *)text textHexColor:(NSString *)hexColor fontSize:(CGFloat)size {
    if (!text.length) {
        self.rightButton.hidden = YES;
    }
    
    self.rightButton.hidden = NO;
    [self.rightButton setTitle:text forState:(UIControlStateNormal)];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:hexColor] forState:(UIControlStateNormal)];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:size weight:(UIFontWeightRegular)];
    
    [self setNeedsUpdateConstraints];
}

- (void)didNavigationRightButtonCompletion:(THNNavigationBarRightButtonCompletion)completion {
    self.rightButtonActionBlock = completion;
}

/**
 设置返回按钮
 */
- (void)setNavigationBackButton {
    self.backButton.hidden = NO;
    [self setNavigationButton:self.backButton imageName:@"icon_back_gray"];
}

- (void)setNavigationBackButtonHidden:(BOOL)hidden {
    self.backButton.hidden = hidden;
}

/**
 设置关闭按钮
 */
- (void)setNavigationCloseButton {
    [self setNavigationCloseButtonOfImageNamed:@"icon_close_white"];
}

- (void)setNavigationCloseButtonOfImageNamed:(NSString *)imageName {
    self.closeButton.hidden = NO;
    [self setNavigationButton:self.closeButton imageName:imageName];
}

- (void)setNavigationCloseButtonHidden:(BOOL)hidden {
    self.closeButton.hidden = hidden;
}

#pragma mark - private methods
/**
 设置按钮图片
 
 @param button 指定的按钮
 @param imageName 图片名称
 */
- (void)setNavigationButton:(UIButton *)button imageName:(NSString *)imageName {
    [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateHighlighted)];
    
    [self setNeedsUpdateConstraints];
}

/**
 按钮是否显示标题
 */
- (BOOL)isButtonTitleText:(UIButton *)button {
    return button.titleLabel.text.length;
}

/**
 获取按钮标题的文字宽度
 */
- (CGFloat)getButtonTextWidth:(UIButton *)button {
    if ([self isButtonTitleText:button]) {
        return [button.titleLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 44)].width + 15;
    }
    
    return 44;
}

#pragma mark - event response
- (void)leftButtonAction:(UIButton *)button {
    if (self.leftButtonActionBlock) {
        self.leftButtonActionBlock();
    }
}

- (void)rightButtonAction:(UIButton *)button {
    if (self.rightButtonActionBlock) {
        self.rightButtonActionBlock();
    }
}

- (void)rightButtonItemsAction:(UIButton *)button {
    NSInteger buttonIndex = button.tag - kRightButtonTag;
    
    if ([self.delegate respondsToSelector:@selector(didNavigationRightButtonOfIndex:)]) {
        [self.delegate didNavigationRightButtonOfIndex:buttonIndex];
    }
}

- (void)backButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didNavigationBackButtonEvent)]) {
        [self.delegate didNavigationBackButtonEvent];
    }
}

- (void)closeButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didNavigationCloseButtonEvent)]) {
        [self.delegate didNavigationCloseButtonEvent];
    }
}

#pragma mark - UI & Layout
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:kColorWhite];
    
    [self addSubview:self.shadow];
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.backButton];
    [self addSubview:self.closeButton];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(self);
    }];
    
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([self getButtonTextWidth:self.leftButton], 44));
        make.bottom.left.mas_equalTo(0);
    }];
    
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([self getButtonTextWidth:self.rightButton], 44));
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.rightButtonTrailing);
    }];
    
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.bottom.left.mas_equalTo(0);
    }];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.bottom.right.mas_equalTo(0);
    }];
    
    if (self.rightButtonArr.count) {
        for (UIView *view in self.rightButtonArr) {
            [self addSubview:(UIButton *)view];
        }
        
        [self.rightButtonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal)
                                      withFixedItemLength:40
                                              leadSpacing:SCREEN_WIDTH - 10 - self.rightButtonArr.count * 40
                                              tailSpacing:10];
        [self.rightButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setTransparent:(BOOL)transparent {
    if (transparent) {
        self.shadow.hidden = NO;
        [self setNavigationButton:self.backButton imageName:@"icon_back_white"];
        self.backgroundColor = [UIColor colorWithHexString:kColorWhite alpha:0];
        
    } else {
        self.shadow.hidden = YES;
        [self setNavigationButton:self.backButton imageName:@"icon_back_gray"];
        self.backgroundColor = [UIColor colorWithHexString:kColorWhite alpha:1];
    }
}

- (UIView *)shadow {
    if (!_shadow) {
        _shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        _shadow.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        
        CAGradientLayer *shadowLayer = [CAGradientLayer layer];
        shadowLayer.frame = _shadow.bounds;
        shadowLayer.startPoint = CGPointMake(0, 2);
        shadowLayer.endPoint = CGPointMake(0, 0);
        shadowLayer.locations = @[@(0.5f), @(2.5f)];
        shadowLayer.colors = @[(__bridge id)[UIColor colorWithHexString:kColorBlack alpha:0].CGColor,
                               (__bridge id)[UIColor colorWithHexString:kColorBlack alpha:1].CGColor];
        [_shadow.layer addSublayer:shadowLayer];
        
        _shadow.hidden = YES;
    }
    return _shadow;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.titleLabel.textColor = titleColor;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
        _titleLabel.textColor = [UIColor colorWithHexString:kColorNavTitle];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.hidden = YES;
        [_rightButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.hidden = YES;
        [_rightButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightButton;
}

- (NSMutableArray *)rightButtonArr {
    if (!_rightButtonArr) {
        _rightButtonArr = [NSMutableArray array];
    }
    return _rightButtonArr;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.hidden = YES;
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.hidden = YES;
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

@end
