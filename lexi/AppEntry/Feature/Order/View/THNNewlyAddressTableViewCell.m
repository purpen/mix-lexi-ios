//
//  THNNewlyAddressTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewlyAddressTableViewCell.h"
#import "UIColor+Extension.h"

static NSString *const kNewlyAddressTableViewCellId = @"kNewlyAddressTableViewCellId";
static NSString *const kTitleText = @"新的收货地址";

@interface THNNewlyAddressTableViewCell ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// icon
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation THNNewlyAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initNewlyAddressCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNNewlyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewlyAddressTableViewCellId];
    if (!cell) {
        cell = [[THNNewlyAddressTableViewCell alloc] initWithStyle:style reuseIdentifier:kNewlyAddressTableViewCellId];
    }
    return cell;
}

+ (instancetype)initNewlyAddressCellWithTableView:(UITableView *)tableView {
    return [self initNewlyAddressCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(15, 0, 200, CGRectGetHeight(self.bounds));
    self.iconImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 50, 0, 50, CGRectGetHeight(self.bounds));
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightLight)];
        _titleLabel.text = kTitleText;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icon_add_main"];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

@end
