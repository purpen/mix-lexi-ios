//
//  THNSignUpViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignUpViewController.h"
#import "THNSignUpView.h"
#import "THNSetPasswordViewController.h"
#import "THNSignInViewController.h"
#import "THNZipCodeViewController.h"

@interface THNSignUpViewController () <THNSignUpViewDelegate>

@property (nonatomic, strong) THNSignUpView *signUpView;

@end

@implementation THNSignUpViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_signUpSetPassword {
    THNSetPasswordViewController *setPasswordVC = [[THNSetPasswordViewController alloc] init];
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}

- (void)thn_showZipCodeList {
    THNZipCodeViewController *zipCodeVC = [[THNZipCodeViewController alloc] init];
    [self presentViewController:zipCodeVC animated:YES completion:nil];
}

- (void)thn_directLogin {
    THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
    [self.navigationController pushViewController:signInVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.signUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    WEAKSELF;
    [self.navigationBarView setNavigationRightButtonOfText:@"跳过" textHexColor:@"#666666"];
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - getters and setters
- (THNSignUpView *)signUpView {
    if (!_signUpView) {
        _signUpView = [[THNSignUpView alloc] init];
        _signUpView.delegate = self;
    }
    return _signUpView;
}

@end
