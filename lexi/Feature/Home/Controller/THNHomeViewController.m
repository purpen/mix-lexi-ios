//
//  THNHomeViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "THNGoodsInfoViewController.h"

@interface THNHomeViewController ()

@end

@implementation THNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *goodsInfoButton = [[UIButton alloc] init];
    [goodsInfoButton setTitle:@"商品详情" forState:(UIControlStateNormal)];
    goodsInfoButton.backgroundColor = [UIColor grayColor];
    [goodsInfoButton addTarget:self action:@selector(goodsInfoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:goodsInfoButton];
    [goodsInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.centerY.centerX.equalTo(self.view);
    }];
}

- (void)goodsInfoButtonAction:(UIButton *)button {
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] init];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.title = kTitleHome;
}

@end
