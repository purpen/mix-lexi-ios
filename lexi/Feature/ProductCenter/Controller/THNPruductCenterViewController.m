//
//  THNPruductCenterViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPruductCenterViewController.h"
#import "THNHomeSearchView.h"
#import "THNSelectButtonView.h"
#import "UIView+Helper.h"
#import "THNRecommendViewController.h"
#import "THNProductAllViewController.h"

@interface THNPruductCenterViewController ()<THNSelectButtonViewDelegate>

@property (nonatomic, strong) THNHomeSearchView *searchView;
@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
// 承载selectButton切换展示Controller的View
@property (nonatomic, strong) UIView *publicView;
// 当前控制器
@property (nonatomic, strong) UIViewController *currentSubViewController;

@end

@implementation THNPruductCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI]; 
}

- (void)setupUI {
    self.navigationBarView.title = @"选品中心";
    [self.view addSubview:self.searchView];
    self.selectButtonView.delegate = self;
    [self.view addSubview:self.selectButtonView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    [self.view addSubview:self.publicView];
    
    [self.publicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    THNRecommendViewController *recommend = [[THNRecommendViewController alloc]init];
    [self addChildViewController:recommend];
    THNProductAllViewController *productAll = [[THNProductAllViewController alloc]init];
    [self addChildViewController:productAll];
    self.childViewControllers[0].view.frame = self.publicView.bounds;
    [self.publicView addSubview:self.childViewControllers[0].view];
    self.currentSubViewController = self.childViewControllers[0];
}

#pragma mark - lazy
- (THNHomeSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[THNHomeSearchView alloc]
                       initWithFrame:CGRectMake(20, 10 + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH - 20 * 2, 34)];
        [_searchView setSearchType:SearchTypeProductCenter];
    }
    return _searchView;
}


- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"推荐", @"全部商品"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.searchView.frame), SCREEN_WIDTH, 60) titles:titleArray initWithButtonType:ButtonTypeDefault];
    }
    return _selectButtonView;
}

- (UIView *)publicView {
    if (!_publicView) {
        _publicView = [[UIView alloc]init];
    }
    return _publicView;
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
