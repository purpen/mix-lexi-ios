//
//  THNMyCenterViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNMyCenterViewController.h"
#import "THNShareViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"

@interface THNMyCenterViewController () <THNNavigationBarViewDelegate>

@end

@implementation THNMyCenterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    loginButton.backgroundColor = [UIColor grayColor];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.centerY.centerX.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamedArray:@[@"icon_more_white", @"icon_share_white"]];
    [self.navigationBarView setNavigationTransparent:YES showShadow:YES];
}

#pragma mark - custom delegate
- (void)didNavigationRightButtonOfIndex:(NSInteger)index {
    if (index == 0) {
        [SVProgressHUD showInfoWithStatus:@"展开更多"];
        
    } else if (index == 1) {
        [SVProgressHUD showInfoWithStatus:@"打开设置"];
    }
}

#pragma mark - event response
- (void)loginButtonAction:(UIButton *)button {
    THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
    THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
