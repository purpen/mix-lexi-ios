//
//  THNBaseViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@interface THNBaseViewController () <THNNavigationBarViewDelegate>

@end

@implementation THNBaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBaseUI];
}

- (void)setupBaseUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navigationBarView];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationBarView setNavigationBackButton];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.view bringSubviewToFront:self.navigationBarView];
}

#pragma mark - custom delegate
- (void)didNavigationBackButtonEvent {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didNavigationCloseButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (THNNavigationBarView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [[THNNavigationBarView alloc] init];
        _navigationBarView.delegate = self;
    }
    return _navigationBarView;
}

@end
