//
//  THNCashRecordDefaultView.m
//  lexi
//
//  Created by FLYang on 2018/12/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashRecordDefaultView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

static NSString *const kTextHint = @"暂无提现记录";

@interface THNCashRecordDefaultView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNCashRecordDefaultView

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
        make.size.mas_equalTo(CGSizeMake(210, 155));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(70);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(10);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cash_record"]];
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

@end
