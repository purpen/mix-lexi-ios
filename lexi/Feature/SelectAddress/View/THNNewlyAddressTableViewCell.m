//
//  THNNewlyAddressTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewlyAddressTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

static NSString *const kNewlyAddressTableViewCellId = @"kNewlyAddressTableViewCellId";
/// text
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
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self);
    }];
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
