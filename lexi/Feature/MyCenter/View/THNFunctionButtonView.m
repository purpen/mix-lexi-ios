//
//  THNFunctionButtonView.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionButtonView.h"
#import "THNMarco.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

static NSInteger const kFunctionButtonTag = 5123;

@interface THNFunctionButtonView ()

/// 记录功能按钮
@property (nonatomic, strong) NSMutableArray *functionButtonArr;

@end

@implementation THNFunctionButtonView

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        [self creatFunctionButtonWithTitles:titles];
    }
    return self;
}

#pragma mark - event response
- (void)functionButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_functionButtonSelectedWithIndex:)]) {
        [self.delegate thn_functionButtonSelectedWithIndex:(button.tag - kFunctionButtonTag)];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.functionButtonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal)
                                        withFixedSpacing:0
                                             leadSpacing:0
                                             tailSpacing:0];
    [self.functionButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(0, CGRectGetHeight(self.bounds)))
                          end:(CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
                        width:1
                        color:[UIColor colorWithHexString:@"#E5E5E5"]];
}

#pragma mark - getters and setters
- (void)creatFunctionButtonWithTitles:(NSArray *)titles {
    CGFloat buttonWidth = CGRectGetWidth(self.bounds) / titles.count;
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *functionButton = [[UIButton alloc] init];
        functionButton.tag = kFunctionButtonTag + idx;
        [functionButton setTitle:titles[idx] forState:(UIControlStateNormal)];
        [functionButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        functionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [functionButton setImage:[UIImage imageNamed:@"icon_sort_down"] forState:(UIControlStateNormal)];
        [functionButton setImageEdgeInsets:(UIEdgeInsetsMake(0, buttonWidth / 2 - 10, 0, 0))];
        [functionButton addTarget:self action:@selector(functionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:functionButton];
        [self.functionButtonArr addObject:functionButton];
    }
}

- (NSMutableArray *)functionButtonArr {
    if (!_functionButtonArr) {
        _functionButtonArr = [NSMutableArray array];
    }
    return _functionButtonArr;
}

@end
