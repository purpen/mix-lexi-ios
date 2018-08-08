//
//  THNHomeViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "THNGoodsInfoViewController.h"
#import "THNHomeSearchView.h"
#import "THNSelectButtonView.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"
#import "UIView+Helper.h"
#import "THNLivingHallViewController.h"
#import "THNFeaturedViewController.h"
#import "THNExploresViewController.h"
#import "THNNavigationBarView.h"

@interface THNHomeViewController ()<THNSelectButtonViewDelegate>

@property (nonatomic, strong) THNHomeSearchView *searchView;
@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
// 承载selectButton切换展示Controller的View
@property (nonatomic, strong) UIView *publicView;
@property (nonatomic, strong) UIView *lineView;
// 当前控制器
@property (nonatomic, strong) UIViewController *currentSubViewController;

@end

@implementation THNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBar];
}

- (void)setupUI {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.selectButtonView];
    self.selectButtonView.delegate = self;
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(35 + STATUS_BAR_HEIGHT);
        make.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.selectButtonView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.view addSubview:self.publicView];
    
    [self.publicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    
    THNLivingHallViewController *livingHall = [[THNLivingHallViewController alloc]init];
    THNFeaturedViewController *featured = [[THNFeaturedViewController alloc]init];
    THNExploresViewController *explore = [[THNExploresViewController alloc]init];
    [self addChildViewController:livingHall];
    [self addChildViewController:featured];
    [self addChildViewController:explore];
    self.childViewControllers[0].view.frame = self.publicView.bounds;
    [self.publicView addSubview:self.childViewControllers[0].view];
    self.currentSubViewController = self.childViewControllers[0];
}


/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - lazy
- (THNHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[THNHomeSearchView alloc]init];
    }
    return _searchView;
}

- (UIView *)publicView {
    if (!_publicView) {
        _publicView = [[UIView alloc]init];
    }
    return _publicView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    }
    return _lineView;
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSMutableArray *titleArray = [@[@"生活馆", @"精选", @"探索"] mutableCopy];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.searchView.frame), SCREEN_WIDTH, 60) titles:titleArray];
    }
    return _selectButtonView;
}

#pragma mark - THNSelectButtonViewDelegate Method 实现
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    UIViewController *selectedController = self.childViewControllers[index];
    selectedController.view.frame = self.publicView.bounds;
    [self transitionFromViewController:self.currentSubViewController toViewController:self.childViewControllers[index] duration:0.5 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            self.currentSubViewController = self.childViewControllers[index];
        }
    }];
}

@end
