//
//  THNDoneButton.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDoneButton.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

@interface THNDoneButton ()

/// 主按钮
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, copy) void (^doneHandle)(void);
/// 高斯模糊背景
@property (nonatomic, strong) UIImageView *shadowView;

@end

@implementation THNDoneButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title completion:(void (^)(void))completion {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        self.doneHandle = completion;
        [self.doneButton setTitle:title forState:(UIControlStateNormal)];
    }
    return self;
}

- (void)setupViewUI {
    [self addSubview:self.shadowView];
    [self addSubview:self.doneButton];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    self.doneHandle();
}

#pragma mark - getters and setters
- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 45)];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
        
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (UIImageView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(self.bounds), 30)];
        _shadowView.image = [UIImage imageNamed:@"done_button_shadow"];
    }
    return _shadowView;
}

@end
