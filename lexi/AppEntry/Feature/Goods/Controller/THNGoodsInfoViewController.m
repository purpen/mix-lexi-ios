//
//  THNGoodsInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsInfoViewController.h"

@interface THNGoodsInfoViewController ()

@end

@implementation THNGoodsInfoViewController

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
    [self.navigationBarView setNavigationTitleHidden:YES];
}


@end
