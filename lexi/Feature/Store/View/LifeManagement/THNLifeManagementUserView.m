//
//  THNLifeManagementUserView.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeManagementUserView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"
#import "UIColor+Extension.h"
#import "UIImageView+SDWedImage.h"

@interface THNLifeManagementUserView ()

// 背景
@property (nonatomic, strong) UIImageView *headerBackgroundView;
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 店铺icon
@property (nonatomic, strong) UIImageView *iconImageView;
// 昵称
@property (nonatomic, strong) YYLabel *nicknameLabel;
@property (nonatomic, assign) CGFloat nameWidth;
// 生活馆状态
@property (nonatomic, strong) UILabel *statusLabel;
// 用户id
@property (nonatomic, strong) UILabel *userIdLabel;

@end

@implementation THNLifeManagementUserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeStoreInfo:(THNLifeStoreModel *)model {
    [self.headerBackgroundView downloadImage:model.logo place:[UIImage imageNamed:@"default_header_place"]];
    [self.headImageView downloadImage:model.logo place:[UIImage imageNamed:@"default_user_place"]];
    [self thn_setNickname:model.name];
    self.userIdLabel.text = [NSString stringWithFormat:@"ID:%zi", model.lifeStoreId];
    [self thn_setUserStatus:model.phases];
    
    [self layoutSubviews];
}

#pragma mark - private methods
- (void)thn_setNickname:(NSString *)name {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:name];
    att.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    att.color = [UIColor whiteColor];
    self.nicknameLabel.attributedText = att;
    
    self.nameWidth = [self.nicknameLabel thn_getLabelWidthWithMaxHeight:16];
}
// 馆主状态标签
- (void)thn_setUserStatus:(NSInteger)status {
    NSArray *statusTexts = @[@"实习馆主", @"达人馆主"];
    self.statusLabel.text = statusTexts[status - 1];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headerBackgroundView];
    [self addSubview:self.headImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.userIdLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.top.mas_equalTo(20);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.headImageView.mas_right).with.offset(10);
        make.top.mas_equalTo(30);
    }];
    
    [self.nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(5);
        make.centerY.equalTo(self.iconImageView);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(self.nameWidth);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 18));
        make.top.mas_equalTo(30);
        make.left.equalTo(self.nicknameLabel.mas_right).with.offset(5);
    }];
    
    [self.userIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(10);
        make.left.equalTo(self.headImageView.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 13));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headerBackgroundView {
    if (!_headerBackgroundView) {
        _headerBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _headerBackgroundView.contentMode = UIViewContentModeCenter;
        _headerBackgroundView.layer.masksToBounds = YES;
        
        // 毛玻璃
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualView.alpha = 0.9;
        visualView.frame = _headerBackgroundView.bounds;
        
        [_headerBackgroundView addSubview:visualView];
    }
    return _headerBackgroundView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = 4;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store_practice"]];
    }
    return _iconImageView;
}

- (YYLabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[YYLabel alloc] init];
    }
    return _nicknameLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:11];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.backgroundColor = [UIColor colorWithHexString:@"#2785FA"];
        _statusLabel.layer.cornerRadius = 9;
        _statusLabel.layer.masksToBounds = YES;
    }
    return _statusLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.font = [UIFont systemFontOfSize:12];
        _userIdLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
    }
    return _userIdLabel;
}

@end
