//
//  THNFollowUserButton.m
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowUserButton.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "THNConst.h"

static NSString *const kTitleNot      = @"关注";
static NSString *const kTitleYet      = @"已关注";
static NSString *const kTitleMutually = @"互相关注";

@interface THNFollowUserButton ()

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题
@property (nonatomic, strong) YYLabel *textLabel;
/// 是否显示图标
@property (nonatomic, assign) BOOL showIcon;
/// 加载动画
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation THNFollowUserButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)setFollowUserStatus:(THNUserFollowStatus)status {
    self.followStatus = status;
    
    switch (status) {
        case THNUserFollowStatusNot: {
            [self thn_setBackgroundColorHex:kColorMain title:kTitleNot titleColorHex:kColorWhite];
            self.showIcon = YES;
        }
            break;
        
        case THNUserFollowStatusYet: {
            [self thn_setBackgroundColorHex:@"#EFF3F2" title:kTitleYet titleColorHex:@"#949EA6"];
            self.showIcon = NO;
        }
            break;
        
        case THNUserFollowStatusMutually: {
            [self thn_setBackgroundColorHex:@"#EFF3F2" title:kTitleMutually titleColorHex:@"#949EA6"];
            self.showIcon = NO;
        }
            break;
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)thn_setBackgroundColorHex:(NSString *)hex title:(NSString *)title titleColorHex:(NSString *)titleHex {
    self.backgroundColor = [UIColor colorWithHexString:hex];
    self.textLabel.text = title;
    self.textLabel.textColor = [UIColor colorWithHexString:titleHex];
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
    
    self.iconImageView.hidden = show;
    self.textLabel.hidden = show;
    
    self.backgroundColor = [UIColor colorWithHexString:kColorMain];
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.loadingView];
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.showIcon ? CGSizeMake(10, 10) : CGSizeMake(0, 0));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.showIcon ? 11 : 0);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.showIcon ? 16 : 0);
    }];
    
    [self.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_white"]];
    }
    return _iconImageView;
}

- (YYLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[YYLabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textContainerInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _textLabel.userInteractionEnabled = NO;
    }
    return _textLabel;
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
