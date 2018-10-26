//
//  THNLifeActionView.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeActionView.h"
#import "THNMarco.h"
#import "UIColor+Extension.h"

@interface THNLifeActionView ()

@property (nonatomic, strong) UIButton *backgroundButton;

@end

@implementation THNLifeActionView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
    
    [self addSubview:self.backgroundButton];
}

#pragma mark - getters and setters
- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backgroundButton.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    }
    return _backgroundButton;
}

@end
