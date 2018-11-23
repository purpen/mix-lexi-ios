//
//  THNDynamicHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicHeaderView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "THNConst.h"
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"
#import "THNFollowUserButton.h"
#import "THNFollowUserButton+SelfManager.h"

static NSString *const kTextCreate = @"拼贴橱窗";

@interface THNDynamicHeaderView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *createButton;
/// 关注按钮
@property (nonatomic, strong) THNFollowUserButton *followButton;

@end

@implementation THNDynamicHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setDynamicUserModel:(THNDynamicModel *)model {
    [self.backgroundImageView loadImageWithUrl:model.bgCover];
    [self.headImageView loadImageWithUrl:[model.userAvatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    self.nameLabel.text = model.username;
    
    if (self.viewType == THNDynamicHeaderViewTypeOther) {
        [self.followButton selfManagerFollowUserStatus:model.followedStatus dynamicModel:model];
    }
    
    [self thn_changeShowView];
}

#pragma mark - event response
- (void)createButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_createWindow)]) {
        [self.delegate thn_createWindow];
    }
}

#pragma mark - private methods
- (void)thn_changeShowView {
    BOOL isMine = self.viewType == THNDynamicHeaderViewTypeDefault;
    
    self.followButton.hidden = isMine;
    self.createButton.hidden = !isMine;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.createButton];
    [self addSubview:self.followButton];
}

- (void)updateConstraints {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-53);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-14);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(5);
        make.right.mas_equalTo(-135);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.headImageView.mas_centerY).with.offset(0);
    }];
    
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-12);
    }];
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.bounds))
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.layer.masksToBounds = YES;
    }
    return _backgroundImageView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.borderWidth = 2;
        _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.backgroundColor = [UIColor whiteColor];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UIButton *)createButton {
    if (!_createButton) {
        _createButton = [[UIButton alloc] init];
        _createButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_createButton setTitle:kTextCreate forState:(UIControlStateNormal)];
        [_createButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_createButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -24, 0, 0))];
        _createButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_createButton setImage:[UIImage imageNamed:@"icon_add_white"] forState:(UIControlStateNormal)];
        [_createButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 66, 0, 0))];
        _createButton.layer.cornerRadius = 17;
        [_createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _createButton;
}

- (THNFollowUserButton *)followButton {
    if (!_followButton) {
        _followButton = [[THNFollowUserButton alloc] init];
        _followButton.layer.cornerRadius = 70 / 2;
        _followButton.hidden = YES;
    }
    return _followButton;
}

@end
