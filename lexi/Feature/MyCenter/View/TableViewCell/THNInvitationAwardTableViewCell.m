//
//  THNInvitationAwardTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNInvitationAwardTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import "NSString+Helper.h"
#import "UIView+Helper.h"
#import "THNConst.h"
#import "UIImageView+WebImage.h"

@interface THNInvitationAwardTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNInvitationAwardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setInviteRewardUserModel:(THNInviteRewardsModelRewards *)model {
    [self.headImageView downloadImage:model.userLogo];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%zi", model.createdAt] doubleValue]];
    self.timeLabel.text = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self thn_setFriendStatus:(model.status - 1)];
    NSString *prefix = model.status == 3 ? @"-" : @"+";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%.2f", prefix, model.amount];
    self.hintLabel.text = model.title;
}

#pragma mark - private methods
- (void)thn_setFriendStatus:(NSInteger)status {
    NSArray *colors = @[kColorMain, @"#FFA22A", @"#B2B2B2"];
    NSArray *texts = @[@"成功", @"待结算", @"交易失败.已退款"];
    
    self.statusLabel.text = texts[status];
    self.statusLabel.textColor = [UIColor colorWithHexString:colors[status]];
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.hintLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.left.equalTo(self.headImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.mas_centerY).with.offset(-2);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.left.equalTo(self.headImageView.mas_right).with.offset(10);
        make.top.equalTo(self.mas_centerY).with.offset(2);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.mas_centerY).with.offset(-2);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.mas_centerY).with.offset(2);
    }];
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

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _hintLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:11];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

@end
