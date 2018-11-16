//
//  THNDynamicUserInfoTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicUserInfoTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"
#import <DateTools/DateTools.h>
#import "THNLoginManager.h"

static NSString *const kDynamicUserInfoCellId = @"THNDynamicUserInfoTableViewCellId";

@interface THNDynamicUserInfoTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation THNDynamicUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initDynamicUserInfoCellWithTableView:(UITableView *)tableView {
    THNDynamicUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDynamicUserInfoCellId];
    if (!cell) {
        cell = [[THNDynamicUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kDynamicUserInfoCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setDynamicUserInfoWithModel:(THNDynamicModelLines *)model {
    self.dynamicRid = [NSString stringWithFormat:@"%zi", model.rid];

    [self.headImageView loadImageWithUrl:[model.userAvatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatarSmall)]];
    self.nameLabel.text = model.userName;
    
    NSString *timeAt = [NSString stringWithFormat:@"%zi", model.createdAt];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeAt doubleValue]];
    self.timeLabel.text = [date formattedDateWithFormat:@"MM月dd日"];

    self.actionButton.hidden = ![model.uid isEqualToString:[THNLoginManager sharedManager].userId];
}

#pragma mark - event response
- (void)actionButtonAction:(UIButton *)button {
    if (self.userDynamicActionBlock && self.dynamicRid.length) {
        self.userDynamicActionBlock(self.dynamicRid);
    }
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.actionButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.equalTo(self.headImageView.mas_top).with.offset(0);
        make.left.equalTo(self.headImageView.mas_right).with.offset(5);
        make.right.mas_equalTo(-100);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.bottom.equalTo(self.headImageView.mas_bottom).with.offset(0);
        make.left.equalTo(self.headImageView.mas_right).with.offset(5);
        make.right.mas_equalTo(-100);
    }];
    
    [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.mas_equalTo(-7);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.layer.cornerRadius = 15;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _timeLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.backgroundColor = [UIColor whiteColor];
        [_actionButton setImage:[UIImage imageNamed:@"icon_more_gray"] forState:(UIControlStateNormal)];
        [_actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _actionButton;
}

@end
