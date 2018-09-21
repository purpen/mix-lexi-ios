//
//  THNCartDefaultView.m
//  lexi
//
//  Created by FLYang on 2018/9/19.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCartDefaultView.h"
#import <YYKit/YYKit.h>

static NSString *kTextHint = @"您的购物车还没有任何礼品";

@interface THNCartDefaultView ()

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 提示信息
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNCartDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.hintLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake((kScreenWidth - 95) / 2, 40, 95, 95);
    self.hintLabel.frame = CGRectMake(20, CGRectGetMaxY(self.iconImageView.frame) + 20, kScreenWidth - 40, 16);
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cart_place"]];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightLight)];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

@end
