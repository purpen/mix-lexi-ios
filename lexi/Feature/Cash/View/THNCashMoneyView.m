//
//  THNCashMoneyView.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashMoneyView.h"
#import "THNCashActionButton.h"
#import "THNMarco.h"

static NSString *const kTitleMoney = @"选择提现金额";
static NSInteger const kActionTag = 534;

@interface THNCashMoneyView () <THNCashActionButtonDelegate>

@property (nonatomic, strong) NSArray *moneyArr;
@property (nonatomic, strong) NSMutableArray *firstButtonArr;
@property (nonatomic, strong) NSMutableArray *secondButtonArr;
@property (nonatomic, strong) THNCashActionButton *selectedButton;

@end

@implementation THNCashMoneyView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - custom delegate
- (void)thn_didSelectedCashActionButton:(THNCashActionButton *)button {
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    NSInteger index = button.tag - kActionTag;
    self.cashAmount = [self.moneyArr[index] floatValue];
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedCashMoneyIndex:)]) {
        [self.delegate thn_didSelectedCashMoneyIndex:index];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.title = kTitleMoney;
    self.moneyArr = @[@(1), @(2), @(3), @(4), @(10), @(20)];
    self.cashAmount = [self.moneyArr[0] floatValue];
    
    [self thn_createCashMoneyButtonWithValues:self.moneyArr];
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.firstButtonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:10 leadSpacing:20 tailSpacing:20];
    [self.firstButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(50);
    }];
    
    [self.secondButtonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:10 leadSpacing:20 tailSpacing:20];
    [self.secondButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(115);
    }];
}

#pragma mark - getters and setters
- (void)thn_createCashMoneyButtonWithValues:(NSArray *)values {
    NSInteger maxItems = 3;
    
    for (NSUInteger idx = 0; idx < values.count; idx ++) {
        THNCashActionButton *actionButton = [[THNCashActionButton alloc] initWithType:THNCashActionButtonTypeMoney];
        NSNumber *value = values[idx];
        [actionButton thn_showCashMoneyValue:value.floatValue];
        actionButton.tag = kActionTag + idx;
        actionButton.selected = idx == 0;
        actionButton.delegate = self;
        if (idx == 0) {
            self.selectedButton = actionButton;
            [actionButton thn_showHintIcon];
        }
        
        [self addSubview:actionButton];
        
        if (idx < maxItems) {
            [self.firstButtonArr addObject:actionButton];
            
        } else {
            [self.secondButtonArr addObject:actionButton];
        }
    }
}

- (NSMutableArray *)firstButtonArr {
    if (!_firstButtonArr) {
        _firstButtonArr = [NSMutableArray array];
    }
    return _firstButtonArr;
}

- (NSMutableArray *)secondButtonArr {
    if (!_secondButtonArr) {
        _secondButtonArr = [NSMutableArray array];
    }
    return _secondButtonArr;
}

@end
