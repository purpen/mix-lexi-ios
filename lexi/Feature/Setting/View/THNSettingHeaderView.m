//
//  THNSettingHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNSettingHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIImageView+WebImage.h"

static NSString *const kTextHint = @"查看并编辑个人资料";

@interface THNSettingHeaderView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation THNSettingHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setNickname:(NSString *)name headImageUrl:(NSString *)imageUrl {
    self.nameLabel.text = name;
    [self.headImageView loadImageWithUrl:[imageUrl loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.hintLabel];
    [self addSubview:self.headImageView];
}

- (void)updateConstraints {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.mas_centerY).with.offset(-5);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-90);
        make.bottom.equalTo(self.mas_centerY).with.offset(0);
        make.height.mas_equalTo(35);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-90);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightSemibold)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightLight)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    }
    return _headImageView;
}

@end
