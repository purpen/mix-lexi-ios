//
//  THNSetPasswordViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetPasswordViewController.h"
#import "THNSetPasswordView.h"
#import "THNNewUserInfoViewController.h"

@interface THNSetPasswordViewController ()

@property (nonatomic, strong) THNSetPasswordView *setPasswordView;

@end

@implementation THNSetPasswordViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.setPasswordView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.setPasswordView endEditing:YES];
}

#pragma mark - getters and setters
- (THNSetPasswordView *)setPasswordView {
    if (!_setPasswordView) {
        _setPasswordView = [[THNSetPasswordView alloc] init];
        
        WEAKSELF;
        
        _setPasswordView.SetPasswordRegisterBlock = ^{
            THNNewUserInfoViewController *newUserInfoVC = [[THNNewUserInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:newUserInfoVC animated:YES];
        };
    }
    return _setPasswordView;
}

@end
