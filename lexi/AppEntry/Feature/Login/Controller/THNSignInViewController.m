//
//  THNSignInViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSignInViewController.h"
#import "THNSignUpViewController.h"
#import "THNSignInView.h"

@interface THNSignInViewController ()

@property (nonatomic, strong) THNSignInView *signInView;

@end

@implementation THNSignInViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.signInView];
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
- (THNSignInView *)signInView {
    if (!_signInView) {
        _signInView = [[THNSignInView alloc] init];
    }
    return _signInView;
}

@end
