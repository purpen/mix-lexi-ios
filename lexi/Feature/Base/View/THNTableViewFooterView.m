//
//  THNTableViewFooterView.m
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNTableViewFooterView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
#import "UIColor+Extension.h"

static NSString *const kHintTextLiked    = @"您还未喜欢过任何东西";
static NSString *const kSubHintTextLiked = @"点击商品和橱窗上的  即可添加到您的喜欢列表中";
static NSString *const kHintTextCollect  = @"你当前还没有浏览和添加心愿单商品";
static NSString *const kHintTextStore    = @"你当前还未关注任何原创品牌设计馆";

@interface THNTableViewFooterView ()

/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 提示内容
@property (nonatomic, strong) UILabel *hintLabel;
/// 提示内容副标题
@property (nonatomic, strong) YYLabel *subHintLable;

@end

@implementation THNTableViewFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame iconImageName:(NSString *)imageName hintText:(NSString *)hintText {
    self  = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        self.hintLabel.text = hintText;
        self.iconImageView.image = [UIImage imageNamed:imageName];
    }
    return self;
}

#pragma mark - public methods
- (void)setHintLabelText:(NSString *)text iconImageName:(NSString *)iconName {
    self.subHintLable.hidden = YES;
    self.hintLabel.text = text;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    
    [UIView animateWithDuration:(NSTimeInterval)0.8 animations:^{
        self.alpha = 1;
    }];
}

- (void)setSubHintLabelText:(NSString *)text {
    self.subHintLable.hidden = YES;
    return [self setSubHintLabelText:text iconImageName:nil iconLocation:0];
}

- (void)setSubHintLabelText:(NSString *)text iconImageName:(NSString *)iconName iconLocation:(NSInteger)location {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    attText.color = [UIColor colorWithHexString:@"#999999"];
    attText.font = [UIFont systemFontOfSize:12];
    attText.alignment = NSTextAlignmentCenter;
    
    // 嵌入图标
    if (iconName.length) {
        UIImage *image = [UIImage imageNamed:iconName];
        NSMutableAttributedString *attachment = [NSMutableAttributedString attachmentStringWithContent:image
                                                                                           contentMode:UIViewContentModeCenter
                                                                                        attachmentSize:image.size
                                                                                           alignToFont:[UIFont systemFontOfSize:12]
                                                                                             alignment:YYTextVerticalAlignmentCenter];
        [attText insertAttributedString:attachment atIndex:location];
    }
    
    self.subHintLable.attributedText = attText;
    self.subHintLable.hidden = NO;
}

- (void)setSubHintLabelTextWithType:(THNHeaderViewSelectedType)type {
    self.alpha = 0;
    
    switch (type) {
        case THNHeaderViewSelectedTypeLiked: {
            [self setHintLabelText:kHintTextLiked iconImageName:@"default_liked"];
            [self setSubHintLabelText:kSubHintTextLiked iconImageName:@"default_heart" iconLocation:10];
        }
            break;
            
        case THNHeaderViewSelectedTypeCollect: {
            [self setHintLabelText:kHintTextCollect iconImageName:@"default_collect"];
        }
            break;
            
        case THNHeaderViewSelectedTypeStore: {
            [self setHintLabelText:kHintTextStore iconImageName:@"default_store"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.hintLabel];
    [self addSubview:self.subHintLable];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.mas_centerY).with.offset(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.hintLabel.mas_top).with.offset(-20);
    }];
    
    [self.subHintLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _hintLabel;
}

- (YYLabel *)subHintLable {
    if (!_subHintLable) {
        _subHintLable = [[YYLabel alloc] init];
        _subHintLable.hidden = YES;
    }
    return _subHintLable;
}

@end
