//
//  THNAdvertInviteView.m
//  lexi
//
//  Created by FLYang on 2018/12/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertInviteView.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNMarco.h"
#import <Masonry/Masonry.h>

static NSString *const kTextDone = @"立即领取";

@interface THNAdvertInviteView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation THNAdvertInviteView

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

#pragma mark - public methods
- (void)show {
    if (!self.superview) {
        [[[UIApplication sharedApplication].windows firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.alpha = 1;
    }];
}

- (void)dismiss {
    if (self.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 0.1, 0.1);
            self.containerView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if (self.advertInviteDoneBlock) {
        self.advertInviteDoneBlock();
    }
    
    [self dismiss];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self.containerView addSubview:self.bgImageView];
    [self.containerView addSubview:self.doneButton];
    [self addSubview:self.containerView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(260, 328));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(220, 40));
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches anyObject].view != self.containerView) {
        [self dismiss];
    }
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4;
        _containerView.transform = CGAffineTransformScale(_containerView.transform, 0.1, 0.1);
        _containerView.alpha = 0;
    }
    return _containerView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_advert_invite"]];
    }
    return _bgImageView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightSemibold)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_doneButton setTitle:kTextDone forState:(UIControlStateNormal)];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
