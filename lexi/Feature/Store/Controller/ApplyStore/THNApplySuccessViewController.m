//
//  THNApplySuccessViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNApplySuccessViewController.h"
#import "THNApplySuccessView.h"
#import "THNHomeViewController.h"

static NSString *const kTitleApply = @"申请生活馆";

@interface THNApplySuccessViewController ()

@property (nonatomic, strong) THNApplySuccessView *successView;

@end

@implementation THNApplySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.successView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleApply;
    [self.navigationBarView setNavigationBackButtonHidden:YES];
}

#pragma mark - getters and setters
- (THNApplySuccessView *)successView {
    if (!_successView) {
        _successView = [[THNApplySuccessView alloc] init];
        
        WEAKSELF;
        _successView.ApplySuccessBlock = ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _successView;
}

@end
