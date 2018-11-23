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
#import <Masonry/Masonry.h>

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
    [self setNeedsUpdateConstraints];
}

- (void)setCellType:(THNGoodsSkuCellType)cellType {
    // 背景色
    NSDictionary *bgColorDict = @{@(THNGoodsSkuCellTypeNormal)   : @"#FFFFFF",
                                  @(THNGoodsSkuCellTypeDisable)  : @"#FFFFFF",
                                  @(THNGoodsSkuCellTypeSelected) : kColorMain};
    
    // 边框色
    NSDictionary *bdColorDict = @{@(THNGoodsSkuCellTypeNormal)   : @"#333333",
                                  @(THNGoodsSkuCellTypeDisable)  : @"#B2B2B2",
                                  @(THNGoodsSkuCellTypeSelected) : kColorMain};
    
    // 文字色
    NSDictionary *textColorDict = @{@(THNGoodsSkuCellTypeNormal)   : @"#333333",
                                    @(THNGoodsSkuCellTypeDisable)  : @"#B2B2B2",
                                    @(THNGoodsSkuCellTypeSelected) : @"#FFFFFF"};
    
    [self thn_setCellStyleWithBackgroundColor:bgColorDict[@(cellType)]
                                  borderColor:bdColorDict[@(cellType)]
                                    textColor:textColorDict[@(cellType)]];
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

- (void)updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
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
