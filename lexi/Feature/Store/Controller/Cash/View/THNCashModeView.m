//
//  THNCashModeView.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashModeView.h"
#import "THNCashActionButton.h"

static NSString *const kTitleMode = @"选择提现方式";
static NSInteger const kActionTag = 434;

@interface THNCashModeView () <THNCashActionButtonDelegate>

@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) THNCashActionButton *selectedButton;

@end

@implementation THNCashModeView

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
    
    self.cashMode = button.tag - kActionTag;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.title = kTitleMode;
    self.cashMode = 0;
    
    [self thn_createCashModeButton];
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.buttonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:10 leadSpacing:20 tailSpacing:20];
    [self.buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(45);
    }];
}

#pragma mark - getters and setters
- (void)thn_createCashModeButton {
    for (NSUInteger idx = 0; idx < 2; idx ++) {
        THNCashActionButton *actionButton = [[THNCashActionButton alloc] initWithType:THNCashActionButtonTypeMode];
        actionButton.tag = kActionTag + idx;
        actionButton.selected = idx == 0;
        [actionButton thn_showCashMode:(THNCashMode)idx];
        actionButton.delegate = self;
        if (idx == 0) {
            self.selectedButton = actionButton;
        }
        
        [self addSubview:actionButton];
        [self.buttonArr addObject:actionButton];
    }
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

@end
