//
//  THNFunctionPopupView.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionPopupView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"

static NSString *const kTitleSort    = @"排序";
static NSString *const kTitleScreen  = @"筛选";

@interface THNFunctionPopupView () {
    THNFunctionPopupViewType _viewType;
}

/// 背景遮罩
@property (nonatomic, strong) UIView *backgroudMaskView;
/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNFunctionPopupView

- (instancetype)initWithFrame:(CGRect)frame functionType:(THNFunctionPopupViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _viewType = type;
        [self setupViewUI];
    }
    return self;
}

+ (instancetype)initWithFunctionType:(THNFunctionPopupViewType)type {
    THNFunctionPopupView *popupView = [[THNFunctionPopupView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                     functionType:type];
    
    return popupView;
}

#pragma mark - public methods
- (void)thn_showFunctionViewWithType:(THNFunctionPopupViewType)type {
    _viewType = type;
    self.titleText = type == THNFunctionPopupViewTypeSort ? kTitleSort : kTitleScreen;
    [self thn_showView:YES];
    
    [self layoutIfNeeded];
}

#pragma mark - private methods
- (void)thn_showView:(BOOL)show {
    CGFloat backgroudAlpha = show ? 1 : 0;
    CGRect selfRect = CGRectMake(0, show ? 0 : SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:(NSTimeInterval)0.3 animations:^{
        self.backgroudMaskView.hidden = YES;
        self.frame = selfRect;
        self.backgroudMaskView.alpha = backgroudAlpha;

    } completion:^(BOOL finished) {
        self.backgroudMaskView.hidden = !show;
    }];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self thn_showView:NO];
}

- (void)closeView:(UITapGestureRecognizer *)tap {
    [self thn_showView:NO];
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.backgroudMaskView];
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.titleLabel];
    [self addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroudMaskView.frame = self.bounds;
    
    CGFloat containerViewH = _viewType == THNFunctionPopupViewTypeSort ? 250 : 376;
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - containerViewH, CGRectGetWidth(self.bounds), containerViewH);
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(6);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(0);
    }];
}

#pragma mark - getters and setters
- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

- (UIView *)backgroudMaskView {
    if (!_backgroudMaskView) {
        _backgroudMaskView = [[UIView alloc] init];
        _backgroudMaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
        [_backgroudMaskView addGestureRecognizer:tap];
    }
    return _backgroudMaskView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_gray"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - shared
+ (THNFunctionPopupView *)sharedView {
    static dispatch_once_t once;
    
    static THNFunctionPopupView *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

@end
