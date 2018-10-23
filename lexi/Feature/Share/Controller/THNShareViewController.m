//
//  THNShareViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShareViewController.h"
#import "THNShareActionView.h"

static NSString *const kTextCancel = @"取消";

@interface THNShareViewController () <THNShareActionViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) THNShareActionView *thirdActionView;
@property (nonatomic, strong) THNShareActionView *moreActionView;

@end

@implementation THNShareViewController

- (instancetype)initWithType:(ShareContentType)type {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_shareView:(THNShareActionView *)shareView didSelectedShareActionIndex:(NSInteger)index {
    if (shareView == self.thirdActionView) {
        [SVProgressHUD thn_showInfoWithStatus:[NSString stringWithFormat:@"分享到：%zi", index]];
    
    } else if (shareView == self.moreActionView) {
        [SVProgressHUD thn_showInfoWithStatus:[NSString stringWithFormat:@"更多：%zi", index]];
    }
}

#pragma mark - event response
- (void)cancelButtonAction:(UIButton *)button {
    [self thn_showAnimation:NO];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    
    [self.containerView addSubview:self.thirdActionView];
    [self.containerView addSubview:self.moreActionView];
    [self.containerView addSubview:self.cancelButton];
    [self.view addSubview:self.containerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES];
    self.cancelButton.frame = CGRectMake(0, 235, SCREEN_WIDTH, 40);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)thn_showAnimation:(BOOL)show {
    CGFloat frameH = kDeviceiPhoneX ? 307 : 275;
    frameH = show ? frameH : 0;
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.8
                        options:(UIViewAnimationOptionTransitionCrossDissolve)
                     animations:^{
                         self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT - frameH, SCREEN_WIDTH, frameH);
                         self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:show ? 0.4 : 0];
                         
                     } completion:^(BOOL finished) {
                         if (show) return ;
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (touch.view != self.containerView) {
        [self thn_showAnimation:NO];
    }
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        CGFloat frameH = kDeviceiPhoneX ? 307 : 275;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, frameH)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:kTextCancel forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelButton;
}

- (THNShareActionView *)thirdActionView {
    if (!_thirdActionView) {
        _thirdActionView = [[THNShareActionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 112)
                                                                type:(THNShareActionViewTypeThird)];
        _thirdActionView.delegate = self;
    }
    return _thirdActionView;
}

- (THNShareActionView *)moreActionView {
    if (!_moreActionView) {
        _moreActionView = [[THNShareActionView alloc] initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, 112)
                                                               type:(THNShareActionViewTypeMore)];
        _moreActionView.delegate = self;
    }
    return _moreActionView;
}

@end
