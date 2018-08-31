//
//  THNFunctionButtonView.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionButtonView.h"
#import "THNMarco.h"
#import "THNTextConst.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "THNFunctionButton.h"

static NSInteger const kFunctionButtonTag = 5123;

@interface THNFunctionButtonView ()

/// 记录功能按钮
@property (nonatomic, strong) NSMutableArray *functionButtonArr;
/// 选中的功能按钮下标
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation THNFunctionButtonView

- (instancetype)initWithFrame:(CGRect)frame type:(THNGoodsListViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        [self thn_createFunctionButtonWithType:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        self.goodsListType = THNGoodsListViewTypeDefault;
        [self creatFunctionButtonWithTitles:titles];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)functionButtonAction:(THNFunctionButton *)button {
    self.selectedIndex = [self.functionButtonArr indexOfObject:button];
    [self thn_setFunctionButtonSelected:YES];
    
    
    if ([self.delegate respondsToSelector:@selector(thn_functionViewSelectedWithIndex:)]) {
        [self.delegate thn_functionViewSelectedWithIndex:(button.tag - kFunctionButtonTag)];
    }
}

#pragma mark - public methods
- (void)thn_createFunctionButtonWithType:(THNGoodsListViewType)type {
    self.goodsListType = type;
    
    switch (type) {
        case THNGoodsListViewTypeBrandHall:
        case THNGoodsListViewTypeUser:
        case THNGoodsListViewTypeStore:{
            [self creatFunctionButtonWithTitles:@[kButtonTitleSort, kButtonTitleScreen]];
            break;
        }
        case THNGoodsListViewTypeProductCenter:{
            [self creatFunctionButtonWithTitles:@[kButtonTitleSort, kButtonTitleProfit, kButtonTitleScreen]];
            break;
        }
            
        default: {
            [self creatFunctionButtonWithTitles:@[kButtonTitleSort, kButtonTitleNew, kButtonTitleScreen]];
            break;
        }
            
    }
}

- (void)thn_setSelectedButtonTitle:(NSString *)title {
    THNFunctionButton *selectedButton = (THNFunctionButton *)self.functionButtonArr[self.selectedIndex];
    selectedButton.title = title;
}

- (void)thn_setFunctionButtonSelected:(BOOL)selected {
    THNFunctionButton *selectedButton = (THNFunctionButton *)self.functionButtonArr[self.selectedIndex];
    selectedButton.selected = selected;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(0, CGRectGetHeight(self.bounds)))
                          end:(CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
                        width:1
                        color:[UIColor colorWithHexString:@"#E5E5E5"]];
}

#pragma mark - getters and setters
- (void)creatFunctionButtonWithTitles:(NSArray *)titles {
    CGFloat buttonW = CGRectGetWidth(self.bounds) / titles.count;
    CGFloat buttonH = CGRectGetHeight(self.bounds);
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        THNFunctionButton *button = [[THNFunctionButton alloc] initWithFrame:CGRectMake(buttonW * idx, 0, buttonW, buttonH)
                                                                       title:titles[idx]];
        button.tag = kFunctionButtonTag + idx;
        
        if ([titles[idx] isEqualToString:@"新品"]) {
            button.iconHidden = YES;
        }
    
        button.selected = NO;
        [button addTarget:self action:@selector(functionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:button];
        [self.functionButtonArr addObject:button];
    }
}

- (NSMutableArray *)functionButtonArr {
    if (!_functionButtonArr) {
        _functionButtonArr = [NSMutableArray array];
    }
    return _functionButtonArr;
}

@end
