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
#import <Masonry/Masonry.h>

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
        [self setupViewUI];
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
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
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
