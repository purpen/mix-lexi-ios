//
//  THNZipCodeViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNZipCodeViewController.h"
#import "THNZipCodeView.h"

@interface THNZipCodeViewController ()

/// 区号列表
@property (nonatomic, strong) THNZipCodeView *zipCodeView;

@end

@implementation THNZipCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - private methods

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.zipCodeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (THNZipCodeView *)zipCodeView {
    if (!_zipCodeView) {
        _zipCodeView = [[THNZipCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        WEAKSELF;
        
        _zipCodeView.CloseZipCodeViewBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        _zipCodeView.SelectedZipCodeBlock = ^(NSString *zipCode) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showInfoWithStatus:zipCode];
        };
    }
    return _zipCodeView;
}

@end
