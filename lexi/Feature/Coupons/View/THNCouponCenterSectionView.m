//
//  THNCouponCenterSectionView.m
//  lexi
//
//  Created by FLYang on 2018/10/31.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponCenterSectionView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"

@interface THNCouponCenterSectionView ()

@property (nonatomic, strong) UIImageView *leftIconImageView;
@property (nonatomic, strong) UIImageView *rightIconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNCouponCenterSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
    
    [self addSubview:self.leftIconImageView];
    [self addSubview:self.rightIconImageView];
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(53, 19));
        make.left.mas_equalTo(55);
        make.centerY.equalTo(self);
    }];
    
    [self.rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(53, 19));
        make.right.mas_equalTo(-55);
        make.centerY.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)thn_hiddenView:(BOOL)hidden {
    self.titleLabel.hidden = hidden;
    self.leftIconImageView.hidden = hidden;
    self.rightIconImageView.hidden = hidden;
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    
    [self thn_hiddenView:self.bounds.size.height < 1];
}

- (UIImageView *)leftIconImageView {
    if (!_leftIconImageView) {
        _leftIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_section_left"]];
        _leftIconImageView.contentMode = UIViewContentModeCenter;
    }
    return _leftIconImageView;
}

- (UIImageView *)rightIconImageView {
    if (!_rightIconImageView) {
        _rightIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_section_right"]];
        _rightIconImageView.contentMode = UIViewContentModeCenter;
    }
    return _rightIconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightSemibold)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
