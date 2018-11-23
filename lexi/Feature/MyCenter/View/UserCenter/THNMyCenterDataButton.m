//
//  THNMyCenterDataButton.m
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNMyCenterDataButton.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import <Masonry/Masonry.h>

static NSString *const kColorDefault = @"#96A0A8";

@interface THNMyCenterDataButton ()

/// 数据值
@property (nonatomic, strong) UILabel *dataLabel;
/// 标题
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation THNMyCenterDataButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.hidden = YES;
        
        [self setupViewUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    NSString *color = selected ? kColorMain : kColorDefault;
    self.dataLabel.textColor = [UIColor colorWithHexString:color];
    self.textLabel.textColor = [UIColor colorWithHexString:color];
}

#pragma mark - public methods
- (void)setTitleText:(NSString *)titleText {
    self.textLabel.text = titleText;
}

- (void)setDataValue:(NSString *)value {
    if (!value.length) return;
    
    self.dataLabel.text = value;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.dataLabel];
    [self addSubview:self.textLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataLabel.mas_bottom).with.offset(3);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];
}

#pragma mark - getters and setters
- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.font = [UIFont systemFontOfSize:20 weight:(UIFontWeightBold)];
        _dataLabel.textAlignment = NSTextAlignmentCenter;
        _dataLabel.text = @"0";
        _dataLabel.textColor = [UIColor colorWithHexString:kColorDefault];
    }
    return _dataLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor colorWithHexString:kColorDefault];
    }
    return _textLabel;
}

@end
