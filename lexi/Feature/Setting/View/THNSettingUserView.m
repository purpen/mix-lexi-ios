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
#import "UIImageView+WebImage.h"
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
    self.headId = model.avatar_id.length ? model.avatar_id : @"0";
    [self.headImageView loadImageWithUrl:[model.avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatarBg)]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.created_at doubleValue]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@", kTextTime, [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
}

- (void)thn_setHeaderImageWithData:(NSData *)imageData {
    self.headImageView.image = [UIImage imageWithData:imageData];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.cameraButton];
    [self addSubview:self.timeLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
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
        _cameraButton.userInteractionEnabled = NO;
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
