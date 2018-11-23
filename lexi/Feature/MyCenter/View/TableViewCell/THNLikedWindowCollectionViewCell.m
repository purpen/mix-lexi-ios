//
//  THNLikedWindowCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedWindowCollectionViewCell.h"
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"
#import "UIImageView+WebImage.h"

@interface THNLikedWindowCollectionViewCell ()

/// 图片1
@property (nonatomic, strong) UIImageView *mainImageView;
/// 图片2
@property (nonatomic, strong) UIImageView *secondImageView;
/// 图片3
@property (nonatomic, strong) UIImageView *thirdImageView;
/// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, assign) CGFloat titleHeight;
/// 背景
@property (nonatomic, strong) UIView *backView;

@end

@implementation THNLikedWindowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setWindowShopModel:(THNWindowModelShopWindows *)model {
    [self thn_setTitleLabelText:model.title];
    
    if (model.productCovers.count >= 3) {
        [self.mainImageView loadImageWithUrl:[model.productCovers[0] loadImageUrlWithType:(THNLoadImageUrlTypeWindowP500)]];
        [self.secondImageView loadImageWithUrl:[model.productCovers[1] loadImageUrlWithType:(THNLoadImageUrlTypeWindowMd)]];
        [self.thirdImageView loadImageWithUrl:[model.productCovers[2] loadImageUrlWithType:(THNLoadImageUrlTypeWindowMd)]];
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)thn_setTitleLabelText:(NSString *)text {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    attStr.lineSpacing = 5;
    attStr.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    attStr.color = [UIColor whiteColor];
    self.titleLabel.attributedText = attStr;
    
    // 标题的动态高度
    self.titleHeight = [self.titleLabel thn_getLabelHeightWithMaxWidth:CGRectGetWidth(self.bounds) - 30];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.mainImageView];
    [self addSubview:self.secondImageView];
    [self addSubview:self.thirdImageView];

    self.backView.frame = self.bounds;
    [self.backView drawGradientMaskWithStartPoint:(CGPointMake(0, 0))
                                         endPoint:CGPointMake(0, 1)
                                           colors:@[@"#000000", @"#000000"]];

    [self addSubview:self.backView];
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    CGFloat cellHeight = CGRectGetHeight(self.bounds);
    CGFloat cellWidth = CGRectGetWidth(self.bounds);
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
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cellWidth - 30, self.titleHeight > 40 ? 40 : self.titleHeight));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-13);
    }];
    
    [super updateConstraints];
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
        _mainImageView.layer.masksToBounds = YES;
    }
    return _mainImageView;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        _secondImageView.layer.masksToBounds = YES;
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        _thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thirdImageView.layer.masksToBounds = YES;
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
