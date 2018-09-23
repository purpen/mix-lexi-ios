//
//  THNBuyProgressView.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBuyProgressView.h"
#import "UIColor+Extension.h"
#import "THNConst.h"

static NSString *const kTitleAddress = @"寄送";
static NSString *const kTitlePreview = @"明细";
static NSString *const kTitlePay     = @"付款";

@interface THNBuyProgressView ()

/// 进度条
@property (nonatomic, strong) UIView *defaultProgressView;
@property (nonatomic, strong) UIView *selectedProgressView;
/// 默认选中的下标
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation THNBuyProgressView

- (instancetype)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.selectIndex = index;
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectIndex = index;
        [self setupViewUI];
    }
    return self;
}

#pragma mark - private methods
- (void)thn_creatProgressWithTitles:(NSArray *)titles {
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        CGFloat titleW = CGRectGetWidth(self.bounds) / titles.count;
        CGFloat titleH = CGRectGetHeight(self.bounds) - 8;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleW * idx, 0, titleW, titleH)];
        titleLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightMedium)];
        titleLabel.text = titles[idx];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake((titleW / 2 - 4) + titleW * idx, titleH - 4, 8, 8)];
        dotView.backgroundColor = [UIColor whiteColor];
        dotView.layer.cornerRadius = 4;
        dotView.layer.borderWidth = 2;
        
        if (idx <= self.selectIndex) {
            titleLabel.textColor = [UIColor colorWithHexString:kColorMain];
            dotView.layer.borderColor = [UIColor colorWithHexString:kColorMain].CGColor;
            
        } else {
            titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            dotView.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        }
        
        [self addSubview:titleLabel];
        [self addSubview:dotView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat titleW = CGRectGetWidth(self.bounds) / 3;
    CGFloat originW = self.selectIndex == 2 ? 0 : titleW / 2;
    CGFloat selectW = (self.selectIndex + 1) * titleW - originW;
    self.selectedProgressView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 8, selectW, 2);
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.defaultProgressView];
    [self addSubview:self.selectedProgressView];
    
    [self thn_creatProgressWithTitles:@[kTitleAddress, kTitlePreview, kTitlePay]];
}

#pragma mark - getters and setters
- (UIView *)defaultProgressView {
    if (!_defaultProgressView) {
        _defaultProgressView = [[UIView alloc] initWithFrame: \
                                CGRectMake(0, CGRectGetHeight(self.bounds) - 8, CGRectGetWidth(self.bounds), 2)];
        _defaultProgressView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    }
    return _defaultProgressView;
}

- (UIView *)selectedProgressView {
    if (!_selectedProgressView) {
        _selectedProgressView = [[UIView alloc] initWithFrame: \
                                 CGRectMake(0, CGRectGetHeight(self.bounds) - 8, 0, 2)];
        _selectedProgressView.backgroundColor = [UIColor colorWithHexString:kColorMain];
    }
    return _selectedProgressView;
}

@end
