//
//  THNLifeManagementTextTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeManagementTextTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

@interface THNLifeManagementTextTableViewCell ()

@property (nonatomic, strong) UILabel *hintTextLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation THNLifeManagementTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)setHintText:(NSString *)hintText {
    self.hintTextLabel.text = hintText;
}

- (void)setIconImage:(UIImage *)iconImage {
    self.iconImageView.image = iconImage;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.hintTextLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nextImageView];
}

- (void)updateConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.hintTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-40);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UILabel *)hintTextLabel {
    if (!_hintTextLabel) {
        _hintTextLabel = [[UILabel alloc] init];
        _hintTextLabel.font = [UIFont systemFontOfSize:14];
        _hintTextLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _hintTextLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_gray"]];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _nextImageView;
}

@end
