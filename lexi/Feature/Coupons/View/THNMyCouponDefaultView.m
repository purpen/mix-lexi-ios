//
//  THNMyCouponDefaultView.m
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNMyCouponDefaultView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

static NSString *const kTextHint = @"当前没有任何优惠卷红包";

@interface THNMyCouponDefaultView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNMyCouponDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.hintLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(255, 123));
        make.bottom.equalTo(self.mas_centerY).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(30);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_counpon_default"]];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

@end
