//
//  THNLoginViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginViewController.h"
#import "THNLoginView.h"
#import "THNSignInViewController.h"
#import "THNSignUpViewController.h"

@interface THNLoginViewController () <THNLoginViewDelegate>

@property (nonatomic, strong) THNLoginView *loginView;

@end

@implementation THNLoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.loginView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - custom delegate
- (void)thn_loginViewDidSelectSkipButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)thn_loginViewDidSelectSignUpButton:(UIButton *)button {
    THNSignUpViewController *signUpVC = [[THNSignUpViewController alloc] init];
    signUpVC.canSkip = YES;
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (void)thn_loginViewDidSelectSignInButton:(UIButton *)button {
    THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
    signInVC.canSkip = YES;
    [self.navigationController pushViewController:signInVC animated:YES];
}

- (void)thn_loginViewDidSelectWechatButton:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"打开微信登录"];
}

#pragma mark - getters and setters
- (THNLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[THNLoginView alloc] init];
        _loginView.delegate = self;
    }
    return _loginView;
}

@end
