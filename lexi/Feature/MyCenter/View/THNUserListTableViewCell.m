//
//  THNUserListTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserListTableViewCell.h"
#import "THNFollowUserButton.h"
#import "THNFollowUserButton+SelfManager.h"
#import <Masonry/Masonry.h>
#import "UIImageView+SDWedImage.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "THNLoginManager.h"

@interface THNUserListTableViewCell ()

/// 头像
@property (nonatomic, strong) UIImageView *headerImageView;
/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
/// 关注按钮
@property (nonatomic, strong) THNFollowUserButton *followButton;

@end

@implementation THNUserListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setUserListCellModel:(THNUserModel *)model {
    [self.headerImageView downloadImage:model.avatar place:[UIImage imageNamed:@"default_header_place"]];
    self.nameLabel.text = model.username;

    if (model.uid == [[THNLoginManager sharedManager].userId integerValue]) {
        self.followButton.hidden = YES;
        
    } else {
        self.followButton.hidden = NO;
        [self.followButton selfManagerFollowUserStatus:(THNUserFollowStatus)model.followed_status
                                                userId:[NSString stringWithFormat:@"%zi", model.uid]];
    }
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.followButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headerImageView.frame = CGRectMake(20, (CGRectGetHeight(self.bounds) - 40) / 2, 40, 40);
    [self.headerImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:40/2];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-100);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    self.followButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 83, (CGRectGetHeight(self.bounds) - 29) / 2, 63, 29);
    [self.followButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.bounds) - 1)
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"default_user_place"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (THNFollowUserButton *)followButton {
    if (!_followButton) {
        _followButton = [[THNFollowUserButton alloc] init];
    }
    return _followButton;
}

@end
