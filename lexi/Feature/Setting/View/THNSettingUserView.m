//
//  THNSettingUserView.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNSettingUserView.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "UIImageView+SDWedImage.h"
#import "UIColor+Extension.h"

static NSString *const kTextTime = @"注册时间：";

@interface THNSettingUserView ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *cameraButton;
// 注册时间
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation THNSettingUserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setUserInfoData:(THNUserDataModel *)model {
    [self.headImageView downloadImage:model.avatar[@"view_url"] place:[UIImage new]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.created_at doubleValue]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@", kTextTime, [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.cameraButton];
    [self addSubview:self.timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.bottom.mas_equalTo(-15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 15));
        make.left.mas_equalTo(15);
        make.bottom.mas_offset(-12);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleToFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    }
    return _headImageView;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] init];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_black"] forState:(UIControlStateNormal)];
        _cameraButton.backgroundColor = [UIColor whiteColor];
        _cameraButton.layer.cornerRadius = 20;
        _cameraButton.layer.masksToBounds = YES;
    }
    return _cameraButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

@end
