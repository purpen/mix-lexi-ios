//
//  THNHeaderTitleView.m
//  lexi
//
//  Created by FLYang on 2018/9/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNHeaderTitleView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

@interface THNHeaderTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNHeaderTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, CGRectGetHeight(self.bounds));
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.bounds))
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
                        width:1.0
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

@end
