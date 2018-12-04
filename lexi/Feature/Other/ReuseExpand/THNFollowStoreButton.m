//
//  THNFollowStoreButton.m
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowStoreButton.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>

static NSString *const kTitleNormal     = @"关注";
static NSString *const kTitleSelected   = @"已关注";

@interface THNFollowStoreButton ()

/// 加载动画
@property (nonatomic, strong) UIView *loadView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation THNFollowStoreButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithType:(THNFollowButtonType)type {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)setFollowStoreStatus:(BOOL)follow {
    self.selected = follow;
    [self setTitleEdgeInsets:(UIEdgeInsetsMake(0, self.selected ? 0 : 5, 0, 0))];
    
    self.backgroundColor = follow ? self.selectedBgColor : self.normalBgColor;
}

#pragma mark - 显示加载动画
- (void)startLoading {
    [self thn_showLoadingView:YES];
    [self.loadingView startAnimating];
}

- (void)endLoading {
    [self thn_showLoadingView:NO];
    [self.loadingView stopAnimating];
}

- (void)thn_showLoadingView:(BOOL)show {
    self.userInteractionEnabled = !show;
    self.loadView.hidden = !show;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.selected = NO;
    
    [self setTitle:kTitleNormal forState:(UIControlStateNormal)];
    [self setTitle:kTitleSelected forState:(UIControlStateSelected)];
    [self setTitleColor:self.normalTitleColor forState:(UIControlStateNormal)];
    [self setTitleColor:self.selectedTitleColor forState:(UIControlStateSelected)];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setImage:[UIImage imageNamed:@"icon_store_feature"] forState:(UIControlStateNormal)];
    [self setImage:[UIImage new] forState:(UIControlStateSelected)];
    [self setImageEdgeInsets:(UIEdgeInsetsMake(8, -1, 8, 0))];
    self.layer.masksToBounds = YES;
    
    [self.loadView addSubview:self.loadingView];
    [self addSubview:self.loadView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.loadView);
    }];
}

#pragma mark - colors
- (UIColor *)normalTitleColor {
    return _normalTitleColor ? _normalTitleColor : [UIColor colorWithHexString:kColorWhite];
}

- (UIColor *)selectedTitleColor {
    return _selectedTitleColor ? _selectedTitleColor : [UIColor colorWithHexString:@"#949EA6"];
}

- (UIColor *)normalBgColor {
    return _normalBgColor ? _normalBgColor : [UIColor colorWithHexString:kColorMain alpha:1];
}

- (UIColor *)selectedBgColor {
    return _selectedBgColor ? _selectedBgColor : [UIColor colorWithHexString:@"#EFF3F2" alpha:1];
}

#pragma mark - getters and setters
- (UIView *)loadView {
    if (!_loadView) {
        _loadView = [[UIView alloc] init];
        _loadView.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _loadView.hidden = YES;
    }
    return _loadView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        _loadingView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _loadingView;
}

@end
