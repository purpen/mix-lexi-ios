//
//  THNGoodsSkuCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsSkuCollectionViewCell.h"
#import "UIColor+Extension.h"
#import "THNConst.h"

@interface THNGoodsSkuCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNGoodsSkuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setSkuName:(NSString *)name {
    self.titleLabel.text = name;
}

#pragma mark - private methods
/**
 选中改变背景样式
 
 @param select 是否选中
 */
- (void)thn_changeLabelBackgroundStyleWithSelect:(BOOL)select {
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:select ? kColorMain : kColorWhite];
    self.titleLabel.layer.borderColor = [UIColor colorWithHexString:select ? kColorMain : @"#333333"].CGColor;
    self.titleLabel.textColor = [UIColor colorWithHexString:select ? kColorWhite : @"#333333"];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
}

#pragma mark - getters and setters
- (void)setSelected:(BOOL)selected {
    [self thn_changeLabelBackgroundStyleWithSelect:selected];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithHexString:kColorWhite];
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

@end
