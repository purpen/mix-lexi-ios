//
//  THNCartButton.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCartButton.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"

static NSString *const kTitleText = @"购物车";

@interface THNCartButton ()

/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题
@property (nonatomic, strong) UILabel *textLable;
/// 数量
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation THNCartButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.textLable];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 18));
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icon_cart_gray"];
    }
    return _iconImageView;
}

- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] init];
        _textLable.font = [UIFont systemFontOfSize:11];
        _textLable.textColor = [UIColor colorWithHexString:@"#949EA6"];
        _textLable.textAlignment = NSTextAlignmentCenter;
        _textLable.text = kTitleText;
    }
    return _textLable;
}

@end
