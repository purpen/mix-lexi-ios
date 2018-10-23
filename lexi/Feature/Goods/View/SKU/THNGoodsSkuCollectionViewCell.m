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
#import "NSString+Helper.h"

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

- (void)setModeName:(NSString *)modeName {
    _modeName = modeName;
    
    self.titleLabel.text = modeName;
}

- (void)setCellType:(THNGoodsSkuCellType)cellType {
    switch (cellType) {
        case THNGoodsSkuCellTypeNormal: {
            [self thn_setCellStyleWithBackgroundColor:kColorWhite borderColor:@"#333333" textColor:@"#333333"];
        }
            break;
            
        case THNGoodsSkuCellTypeDisable: {
            [self thn_setCellStyleWithBackgroundColor:kColorWhite borderColor:@"#B2B2B2" textColor:@"#B2B2B2"];
        }
            break;
            
        case THNGoodsSkuCellTypeSelected: {
            [self thn_setCellStyleWithBackgroundColor:kColorMain borderColor:kColorMain textColor:kColorWhite];
        }
            break;
    }
}

#pragma mark - private methods
- (void)thn_setCellStyleWithBackgroundColor:(NSString *)backgroundColor borderColor:(NSString *)borderColor textColor:(NSString *)textColor {
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:backgroundColor];
    self.titleLabel.layer.borderColor = [UIColor colorWithHexString:borderColor].CGColor;
    self.titleLabel.textColor = [UIColor colorWithHexString:textColor];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithHexString:kColorWhite];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

@end
