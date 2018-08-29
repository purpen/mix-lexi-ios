//
//  THNFunctionButton.m
//  lexi
//
//  Created by FLYang on 2018/8/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionButton.h"
#import "UIColor+Extension.h"

@interface THNFunctionButton ()

/// 标题
@property (nonatomic, strong) UILabel *titleLable;
/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation THNFunctionButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat titleW = self.titleLabel.text.length * 15;
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, 0, titleW, height);
    self.iconImageView.frame = CGRectMake((width - titleW) / 2 + titleW, 0, 10, height);
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setIconImage:(UIImage *)iconImage {
    self.iconImageView.image = iconImage;
}

- (void)setIconHidden:(BOOL)iconHidden {
    self.iconImageView.hidden = iconHidden;
}

- (void)setSelected:(BOOL)selected {
    [UIView animateWithDuration:0.3f animations:^{
        self.iconImageView.transform = CGAffineTransformMakeRotation(selected ? M_PI : 0);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _titleLable;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
        _iconImageView.image = [UIImage imageNamed:@"icon_sort_down"];
    }
    return _iconImageView;
}

@end
