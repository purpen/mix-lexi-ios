//
//  THNShareViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShareViewController.h"

@interface THNShareViewController ()

@end

@implementation THNShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    [self.navigationBarView setNavigationTransparent:YES showShadow:YES];
    [self.navigationBarView setNavigationCloseButton];
}

@end
