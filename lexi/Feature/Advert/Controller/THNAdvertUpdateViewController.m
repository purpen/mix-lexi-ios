//
//  THNAdvertUpdateViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertUpdateViewController.h"
#import "THNAdvertUpdateView.h"

@interface THNAdvertUpdateViewController () <THNAdvertUpdateViewDelegate>

@property (nonatomic, strong) THNAdvertUpdateView *updateView;

@end

@implementation THNAdvertUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_updateDoneAction {
    [SVProgressHUD thn_showInfoWithStatus:@"去更新"];
}

- (void)thn_updateCancelAction {
    [self thn_showAnimation:NO dismiss:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self.view addSubview:self.updateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES dismiss:NO];
}

- (void)thn_showAnimation:(BOOL)show dismiss:(BOOL)dismiss {
    CGFloat originY = show ? 0 : -SCREEN_HEIGHT;
    CGFloat alpha = show ? 0.5 : 0;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.8
                        options:(UIViewAnimationOptionTransitionCrossDissolve)
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:alpha];
                         self.updateView.frame = CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT);
                         
                     } completion:^(BOOL finished) {
                         if (dismiss) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }];
}

#pragma mark - getters and setters
- (THNAdvertUpdateView *)updateView {
    if (!_updateView) {
        _updateView = [[THNAdvertUpdateView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _updateView.delegate = self;
    }
    return _updateView;
}

@end
