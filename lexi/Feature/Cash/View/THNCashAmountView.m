//
//  THNCashAmountView.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashAmountView.h"

static NSString *const kTitleAmount = @"可提现金额";

@interface THNCashAmountView ()

@property (nonatomic, strong) UILabel *amoutLabel;

@end

@implementation THNCashAmountView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setCashAmountValue:(CGFloat)value {
    self.amoutLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.title = kTitleAmount;
    
    [self addSubview:self.amoutLabel];
    [self.amoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(45, 20, 25, 20));
    }];
}

#pragma mark - getters and setters
- (UILabel *)amoutLabel {
    if (!_amoutLabel) {
        _amoutLabel = [[UILabel alloc] init];
        _amoutLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
        _amoutLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightBold)];
    }
    return _amoutLabel;
}

@end
