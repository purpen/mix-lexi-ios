//
//  THNInvitationFriendTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNInvitationFriendTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "NSString+Helper.h"
#import "UIView+Helper.h"

@interface THNInvitationFriendTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNInvitationFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
        
        [self settext];
    }
    return self;
}

- (void)settext {
    self.nameLabel.text = @"Fynn";
    [self thn_setFriendStatus:0];
    self.moneyLabel.text = [NSString formatFloat:99.9];
    self.hintLabel.text = @"生活馆销售额";
}

#pragma mark - private methods
- (void)thn_setFriendStatus:(NSInteger)status {
    NSArray *colors = @[@"#2785FA", @"#FFA22A"];
    NSArray *texts = @[@"实习", @"正式"];
    
    self.statusLabel.text = texts[status];
    self.statusLabel.backgroundColor = [UIColor colorWithHexString:colors[status]];
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.hintLabel];
}

- (void)setMasonryLayout {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.equalTo(self.headImageView.mas_right).with.offset(5);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(40);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 15));
        make.left.mas_equalTo(self.nameLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 15));
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.mas_centerY).with.offset(-2);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 15));
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.mas_centerY).with.offset(2);
    }];
}

- (void)updateConstraints {
    [self setMasonryLayout];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:35/2];
    [self.statusLabel drawCornerWithType:(UILayoutCornerRadiusAll) radius:15/2];
}

#pragma mark - getters and setters
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:11];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _hintLabel.textAlignment = NSTextAlignmentRight;
    }
    return _hintLabel;
}

@end
