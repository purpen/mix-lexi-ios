//
//  THNLikedWindowCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedWindowCollectionViewCell.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"

@interface THNLikedWindowCollectionViewCell ()

/// 图片1
@property (nonatomic, strong) UIImageView *mainImageView;
/// 图片2
@property (nonatomic, strong) UIImageView *secondImageView;
/// 图片3
@property (nonatomic, strong) UIImageView *thirdImageView;
/// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
/// 背景
@property (nonatomic, strong) UIView *backView;

@end

@implementation THNLikedWindowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
        [self thn_setWindowModel:@""];
    }
    return self;
}

- (void)thn_setWindowModel:(NSString *)model {
    [self thn_setTitleLabelText:@"阿斯顿嘎是嘎嘎公司萨店的撒上的格桑达瓦阿斯顿嘎是嘎嘎公司达瓦阿斯顿嘎是嘎嘎公司"];
    
    [self layoutIfNeeded];
}

#pragma mark - private methods
- (void)thn_setTitleLabelText:(NSString *)text {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    attStr.yy_lineSpacing = 5;
    attStr.yy_font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    attStr.yy_color = [UIColor whiteColor];
    
    self.titleLabel.attributedText = attStr;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.mainImageView];
    [self addSubview:self.secondImageView];
    [self addSubview:self.thirdImageView];
    [self addSubview:self.backView];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    CGFloat imgHeight = (cellHeight - 2) / 2;
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cellHeight, cellHeight));
        make.top.left.mas_equalTo(0);
    }];
    
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imgHeight, imgHeight));
        make.left.equalTo(self.mainImageView.mas_right).with.offset(2);
        make.top.equalTo(self.mainImageView.mas_top).with.offset(0);
    }];
    
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imgHeight, imgHeight));
        make.left.equalTo(self.mainImageView.mas_right).with.offset(2);
        make.top.equalTo(self.secondImageView.mas_bottom).with.offset(2);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cellWidth, cellHeight));
        make.top.left.mas_equalTo(0);
    }];
    [self.backView drawGradientMaskWithStartPoint:(CGPointMake(0, 0))
                                         endPoint:CGPointMake(0, 1)
                                           colors:@[@"#000000", @"#000000"]];
    
    // 标题的动态高度
    CGFloat titleHeight = [self.titleLabel thn_getLabelHeightWithMaxWidth:cellWidth - 30];
    titleHeight = titleHeight > 40 ? 40 : titleHeight;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cellWidth - 30, titleHeight));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-13);
    }];
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _mainImageView;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thirdImageView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

@end
