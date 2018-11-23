//
//  THNNoneCouponView.m
//  lexi
//
//  Created by FLYang on 2018/11/5.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNNoneCouponView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

static NSString *const kTextHint = @"该分类暂无优惠券";

@interface THNNoneCouponView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNNoneCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(10);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_coupon_white_0"]];
        _iconImageView.contentMode = UIViewContentModeCenter;
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"#FFC8AE"];
        _iconImageView.layer.cornerRadius = 30;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextHint;
    }
    return _titleLabel;
}

@end
