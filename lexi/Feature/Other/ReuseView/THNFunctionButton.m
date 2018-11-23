//
//  THNFunctionButton.m
//  lexi
//
//  Created by FLYang on 2018/8/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionButton.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>

@interface THNFunctionButton ()

/// 标题
@property (nonatomic, strong) UILabel *textLabel;
/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation THNFunctionButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        self.title = title;
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.textLabel];
    [self addSubview:self.iconImageView];
}

- (void)updateConstraints {
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.title.length * 15);
        make.top.bottom.mas_equalTo(0);
        make.centerX.equalTo(self);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(self.textLabel.mas_right).with.offset(5);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.textLabel.text = title;
    
    [self setNeedsUpdateConstraints];
}

- (void)setIconImage:(UIImage *)iconImage {
    self.iconImageView.image = iconImage;
}

- (void)setIconHidden:(BOOL)iconHidden {
    self.iconImageView.hidden = iconHidden;
}

- (void)setIsBold:(BOOL)isBold {
    _isBold = isBold;
    
    self.textLabel.font = [UIFont systemFontOfSize:14 weight:isBold ? UIFontWeightBold : UIFontWeightRegular];
    self.textLabel.textColor = [UIColor colorWithHexString:isBold ? kColorMain : @"#555555"];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.iconImageView.transform = CGAffineTransformMakeRotation(isSelected ? M_PI : 0);
    }];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _textLabel;
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
