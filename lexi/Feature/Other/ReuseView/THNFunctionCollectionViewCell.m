//
//  THNFunctionCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionCollectionViewCell.h"
#import "UIColor+Extension.h"
#import "THNConst.h"

@interface THNFunctionCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNFunctionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setCellTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)thn_selectCell:(BOOL)select {
    [self thn_changeLabelBackgroundStyleWithSelect:select];
}

#pragma mark - private methods
/**
 选中改变背景样式

 @param select 是否选中
 */
- (void)thn_changeLabelBackgroundStyleWithSelect:(BOOL)select {
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:select ? kColorMain : @"#F5F7F9" alpha:select ? 0.1 : 1];
    self.titleLabel.layer.borderWidth = select ? 1 : 0;
    self.titleLabel.layer.borderColor = [UIColor colorWithHexString:select ? kColorMain : @"#F5F7F9"].CGColor;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithHexString:@"#F5F7F9"];
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

@end
