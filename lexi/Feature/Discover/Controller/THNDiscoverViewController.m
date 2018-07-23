//
//  THNDiscoverViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"

@interface THNDiscoverViewController ()

@end

@implementation THNDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.title = kTitleDiscover;
}

@end
