//
//  THNLifeInviteView.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeInviteView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

static NSString *const kTextFriend      = @"我的朋友";
static NSString *const kTextFriendSub   = @"（人）";
static NSString *const kTextToday       = @"今日邀请：";
static NSString *const kTextMoney       = @"奖励";
static NSString *const kTextMoneySub    = @"（元）";
static NSString *const kTextTotal       = @"待结算：";
static NSString *const kTextInvite      = @"组队赚钱，收益速增";

@interface THNLifeInviteView ()

// 邀请视图
@property (nonatomic, strong) UIView *inviteView;
@property (nonatomic, strong) UIImageView *inviteImageView;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, strong) YYLabel *inviteHintLabel;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIView *inviteBgView;

// 数据视图
@property (nonatomic, strong) UIView *containerView;
// 朋友
@property (nonatomic, strong) YYLabel *friendTitleLabel;
// 朋友数量
@property (nonatomic, strong) UIButton *friendCountButton;
// 今日邀请数量
@property (nonatomic, strong) UILabel *todayFriendLabel;
// 奖励
@property (nonatomic, strong) YYLabel *moneyTitleLabel;
// 可提现金额
@property (nonatomic, strong) UIButton *getMoneyButton;
// 待结算金额
@property (nonatomic, strong) YYLabel *totalMoneyLabel;
// 提示按钮
@property (nonatomic, strong) UIButton *hintButton;

@end

@implementation THNLifeInviteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        [self thn_setLifeInviteFriend];
        [self thn_setLifeInviteMoney];
    }
    return self;
}

- (void)thn_setLifeInviteFriend {
    [self.friendCountButton setTitle:[NSString stringWithFormat:@"%i", 99] forState:(UIControlStateNormal)];
    self.todayFriendLabel.text = [NSString stringWithFormat:@"%@%i", kTextToday, 19];
}

- (void)thn_setLifeInviteMoney {
    [self.getMoneyButton setTitle:[NSString stringWithFormat:@"%.2f", 99.9] forState:(UIControlStateNormal)];
    [self thn_setTotalMoneyLabelTextWithCashPrice:12];
}

#pragma mark - event response
- (void)friendCountButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_lifeInviteCheckFriend)]) {
        [self.delegate thn_lifeInviteCheckFriend];
    }
}

- (void)getMoneyButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_lifeInviteCheckMoney)]) {
        [self.delegate thn_lifeInviteCheckMoney];
    }
}

- (void)hintButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_lifeInviteMoneyHint)]) {
        [self.delegate thn_lifeInviteMoneyHint];
    }
}

#pragma mark - private methods
- (void)thn_setTotalMoneyLabelTextWithCashPrice:(CGFloat)price {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextTotal];
    att.color = [UIColor colorWithHexString:@"#333333"];
    att.font = [UIFont systemFontOfSize:12];
    att.alignment = NSTextAlignmentLeft;
    
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    priceAtt.color = [UIColor colorWithHexString:@"#FF9F22"];
    priceAtt.font = [UIFont systemFontOfSize:12];
    
    [att appendAttributedString:priceAtt];
    
    self.totalMoneyLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self.containerView addSubview:self.friendTitleLabel];
    [self.containerView addSubview:self.friendCountButton];
    [self.containerView addSubview:self.todayFriendLabel];
    [self.containerView addSubview:self.moneyTitleLabel];
    [self.containerView addSubview:self.getMoneyButton];
    [self.containerView addSubview:self.totalMoneyLabel];
    [self.containerView addSubview:self.hintButton];
    [self addSubview:self.containerView];
    
    [self.inviteView addSubview:self.inviteBgView];
    [self.inviteView addSubview:self.inviteImageView];
    [self.inviteView addSubview:self.textImageView];
    [self.inviteView addSubview:self.inviteHintLabel];
    [self.inviteView addSubview:self.inviteButton];
    [self addSubview:self.inviteView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.inviteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
    }];
    
    [self.inviteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(10);
    }];
    
    [self.textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(117, 13));
        make.left.mas_equalTo(83);
        make.top.mas_equalTo(22);
    }];
    
    [self.inviteHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.left.mas_equalTo(83);
        make.top.mas_equalTo(40);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 25));
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(25);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(107);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(65);
    }];
    
    [self.friendTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.right.equalTo(self.mas_centerX).with.offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.todayFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-15);
        make.right.equalTo(self.mas_centerX).with.offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.friendCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.friendTitleLabel.mas_bottom).with.offset(15);
        make.right.equalTo(self.mas_centerX).with.offset(-10);
        make.bottom.equalTo(self.todayFriendLabel.mas_top).with.offset(-15);
    }];
    
    [self.moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-45);
        make.top.mas_equalTo(15);
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.getMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.moneyTitleLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.bottom.equalTo(self.totalMoneyLabel.mas_top).with.offset(-15);
    }];
    
    [self.hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.equalTo(self.moneyTitleLabel.mas_left).with.offset(70);
        make.top.mas_equalTo(14);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(CGRectGetWidth(self.frame) / 2, 85)
                          end:CGPointMake(CGRectGetWidth(self.frame) / 2, 160)
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
    
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.frame))
                          end:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
#pragma mark 邀请视图
- (UIView *)inviteView {
    if (!_inviteView) {
        _inviteView = [[UIView alloc] init];
        _inviteView.backgroundColor = [UIColor whiteColor];
    }
    return _inviteView;
}

- (UIView *)inviteBgView {
    if (!_inviteBgView) {
        _inviteBgView = [[UIView alloc] init];
        _inviteBgView.backgroundColor = [UIColor colorWithHexString:@"#FFE4E7" alpha:1];
        _inviteBgView.layer.cornerRadius = 4;
    }
    return _inviteBgView;
}

- (UIImageView *)inviteImageView {
    if (!_inviteImageView) {
        _inviteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_invite_coupon"]];
    }
    return _inviteImageView;
}

- (UIImageView *)textImageView {
    if (!_textImageView) {
        _textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_invite_text"]];
    }
    return _textImageView;
}

- (YYLabel *)inviteHintLabel {
    if (!_inviteHintLabel) {
        _inviteHintLabel = [[YYLabel alloc] init];
        _inviteHintLabel.text = kTextInvite;
        _inviteHintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _inviteHintLabel.font = [UIFont systemFontOfSize:12];
    }
    return _inviteHintLabel;
}

- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [[UIButton alloc] init];
        _inviteButton.backgroundColor = [UIColor colorWithHexString:@"#FF6666" alpha:1];
        [_inviteButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _inviteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_inviteButton setTitle:@"邀请" forState:(UIControlStateNormal)];
        _inviteButton.layer.cornerRadius = 4;
    }
    return _inviteButton;
}

#pragma mark 邀请数据视图
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    }
    return _containerView;
}

- (YYLabel *)friendTitleLabel {
    if (!_friendTitleLabel) {
        _friendTitleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextFriend];
        titleAtt.color = [UIColor colorWithHexString:@"#333333"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextFriendSub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#999999"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _friendTitleLabel.attributedText = titleAtt;
    }
    return _friendTitleLabel;
}

- (UIButton *)friendCountButton {
    if (!_friendCountButton) {
        _friendCountButton = [[UIButton alloc] init];
        [_friendCountButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _friendCountButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightSemibold)];
        _friendCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_friendCountButton setImage:[UIImage imageNamed:@"icon_arrow_right_gray"] forState:(UIControlStateNormal)];
        [_friendCountButton setImageEdgeInsets:(UIEdgeInsetsMake(0, (kScreenWidth - 50) / 2 - 10, 0, 0))];
        [_friendCountButton addTarget:self action:@selector(friendCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _friendCountButton;
}

- (UILabel *)todayFriendLabel {
    if (!_todayFriendLabel) {
        _todayFriendLabel = [[UILabel alloc] init];
        _todayFriendLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _todayFriendLabel.font = [UIFont systemFontOfSize:12];
    }
    return _todayFriendLabel;
}

- (YYLabel *)moneyTitleLabel {
    if (!_moneyTitleLabel) {
        _moneyTitleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextMoney];
        titleAtt.color = [UIColor colorWithHexString:@"#333333"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextMoneySub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#999999"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _moneyTitleLabel.attributedText = titleAtt;
    }
    return _moneyTitleLabel;
}

- (UIButton *)getMoneyButton {
    if (!_getMoneyButton) {
        _getMoneyButton = [[UIButton alloc] init];
        [_getMoneyButton setTitleColor:[UIColor colorWithHexString:@"#FF9F22"] forState:(UIControlStateNormal)];
        _getMoneyButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightSemibold)];
        _getMoneyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_getMoneyButton setImage:[UIImage imageNamed:@"icon_arrow_right_gray"] forState:(UIControlStateNormal)];
        [_getMoneyButton setImageEdgeInsets:(UIEdgeInsetsMake(0, (kScreenWidth - 50) / 2 - 10, 0, 0))];
        [_getMoneyButton addTarget:self action:@selector(getMoneyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _getMoneyButton;
}

- (YYLabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[YYLabel alloc] init];
        _totalMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _totalMoneyLabel;
}

- (UIButton *)hintButton {
    if (!_hintButton) {
        _hintButton = [[UIButton alloc] init];
        [_hintButton setImage:[UIImage imageNamed:@"icon_hint_gray"] forState:(UIControlStateNormal)];
        [_hintButton setImage:[UIImage imageNamed:@"icon_hint_gray"] forState:(UIControlStateSelected)];
        [_hintButton addTarget:self action:@selector(hintButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hintButton;
}

@end
