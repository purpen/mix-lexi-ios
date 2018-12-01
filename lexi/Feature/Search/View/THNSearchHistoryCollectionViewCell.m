//
//  THNSearcgHistoryCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchHistoryCollectionViewCell.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNMarco.h"

NSString *const kSearchHistoryCellIdentifier = @"kSearchHistoryCellIdentifier";

@interface THNSearchHistoryCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNSearchHistoryCollectionViewCell

- (void)setupCellViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
    self.titleLabel.frame = CGRectMake(10, 0, self.viewWidth - 20, self.viewHeight);
    [self drawCornerWithType:0 radius:self.viewHeight / 2];
    [self addSubview:self.titleLabel];
}

- (void)setHistoryStr:(NSString *)historyStr {
    self.titleLabel.text = historyStr;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

@end
