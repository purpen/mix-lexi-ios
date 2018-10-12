//
//  THNMyCenterMenuView.m
//  lexi
//
//  Created by FLYang on 2018/10/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNMyCenterMenuView.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

static NSString *const kTextCenter      = @"个人主页";
static NSString *const kTextLifeStore   = @"生活馆管理";
///
static NSInteger const kMenuButtonTag   = 516;

@interface THNMyCenterMenuView ()

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end

@implementation THNMyCenterMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)menuButtonAction:(UIButton *)button {
    button.selected = YES;
    self.selectedButton.selected = NO;
    self.selectedButton = button;
    NSInteger index = button.tag - kMenuButtonTag;
    
    [self thn_uploadLineViewFrameWithIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedMenuButtonIndex:)]) {
        [self.delegate thn_didSelectedMenuButtonIndex:index];
    }
}

#pragma mark - private methods
- (void)thn_uploadLineViewFrameWithIndex:(NSInteger)index {
    UIButton *menuButton = (UIButton *)self.buttonArr[index];
    CGFloat button_x = index == 0 ? 8 : 3;
    CGFloat originX = CGRectGetMinX(menuButton.frame) + button_x;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(originX);
        }];
        
        [self layoutIfNeeded];
    }];
}

- (void)thn_removeButton {
    if (!self.buttonArr.count) return;
    
    [self.buttonArr removeAllObjects];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self thn_creatMenuButtonWithTitles:@[kTextCenter, kTextLifeStore]];
    [self.buttonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:75 leadSpacing:60 tailSpacing:60];
    [self.buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-3);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 2));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(68);
    }];
}

#pragma mark - getters and setters
- (void)thn_creatMenuButtonWithTitles:(NSArray *)titles {
    [self thn_removeButton];
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titles[idx] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateSelected)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = kMenuButtonTag + idx;

        if (idx == 0) {
            button.selected = YES;
            self.selectedButton = button;
        }
        
        [button addTarget:self action:@selector(menuButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:button];
        [self.buttonArr addObject:button];
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kColorMain];
    }
    return _lineView;
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

@end
