//
//  THNWindowViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowViewController.h"
#import "THNSelectButtonView.h"
#import "THNMarco.h"

@interface THNShopWindowViewController ()

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;

@end

@implementation THNShopWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.selectButtonView];
    self.navigationBarView.title = @"橱窗";
}

#pragma mark - lazy
- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray =  @[@"关注",@"推荐"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 60) titles:titleArray];
    }
    return _selectButtonView;
}

@end
