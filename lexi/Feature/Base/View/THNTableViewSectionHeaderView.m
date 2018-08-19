//
//  THNTableViewSectionHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNTableViewSectionHeaderView.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>

static NSString *const kMoreButtonTitle = @"查看全部";

@interface THNTableViewSectionHeaderView ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNTableViewSectionHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)showMoreButton:(BOOL)show {
    self.moreButton.hidden = !show;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.moreButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTitle:kMoreButtonTitle forState:(UIControlStateNormal)];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"#949EA6"] forState:(UIControlStateNormal)];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_moreButton setImage:[UIImage imageNamed:@"icon_ arrow_right_gray"] forState:(UIControlStateNormal)];
        [_moreButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 65, 0, 0))];
        _moreButton.hidden = YES;
    }
    return _moreButton;
}

@end
