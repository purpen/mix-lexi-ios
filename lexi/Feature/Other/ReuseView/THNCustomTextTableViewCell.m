//
//  THNCustomTextTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCustomTextTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

@interface THNCustomTextTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UILabel *mainTextLabel;
@property (nonatomic, strong) UILabel *subTextLabel;

@end

@implementation THNCustomTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setIconImageName:(NSString *)imageName mainText:(NSString *)mainText {
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.mainTextLabel.text = mainText;
}

- (void)thn_setSubText:(NSString *)subText textColor:(NSString *)colorHex {
    self.subTextLabel.text = subText;
    self.subTextLabel.textColor = [UIColor colorWithHexString:colorHex];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.nextImageView];
    [self addSubview:self.mainTextLabel];
    [self addSubview:self.subTextLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self);
    }];
    
    [self.mainTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-100);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTextLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(-30);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(15, CGRectGetHeight(self.frame)))
                          end:(CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
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

- (UILabel *)mainTextLabel {
    if (!_mainTextLabel) {
        _mainTextLabel = [[UILabel alloc] init];
        _mainTextLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _mainTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mainTextLabel;
}

- (UILabel *)subTextLabel {
    if (!_subTextLabel) {
        _subTextLabel = [[UILabel alloc] init];
        _subTextLabel.font = [UIFont systemFontOfSize:12];
        _subTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subTextLabel;
}

@end
