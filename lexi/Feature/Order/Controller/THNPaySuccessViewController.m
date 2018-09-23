//
//  THNPaySuccessViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaySuccessViewController.h"

@interface THNPaySuccessViewController () <THNNavigationBarViewDelegate>

@end

@implementation THNPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:kColorMain];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationBackButtonHidden:YES];
    [self.navigationBarView setNavigationTransparent:YES showShadow:NO];
    [self.navigationBarView setNavigationLeftButtonOfImageNamed:@"icon_close_white"];
    
    WEAKSELF;
    [self.navigationBarView didNavigationLeftButtonCompletion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}
@end
