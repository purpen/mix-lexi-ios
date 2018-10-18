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
#import "THNLoginManager.h"
#import "THNSearchViewController.h"

@interface THNHomeViewController ()<THNSelectButtonViewDelegate>

@property (nonatomic, strong) THNHomeSearchView *searchView;
@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
// 承载selectButton切换展示Controller的View
@property (nonatomic, strong) UIView *publicView;
// 当前控制器
@property (nonatomic, strong) UIViewController *currentSubViewController;
@property (nonatomic, strong) THNFeaturedViewController *featured;
@property (nonatomic, strong) THNExploresViewController *explore;
@property (nonatomic, strong) THNLivingHallViewController *livingHall;

@end

@implementation THNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setNavigationBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLayoutHomeView) name:kUpdateLivingHallStatus object:nil];
}

- (void)refreshLayoutHomeView {
     [self claer];
     [self setupUI];
}

// 登录成功刷新，清空再去更新视图
- (void)claer {
   [self.selectButtonView removeFromSuperview];
    self.selectButtonView = nil;
    [self.featured removeFromParentViewController];
    [self.livingHall removeFromParentViewController];
    [self.explore removeFromParentViewController];
}

- (void)setupUI {
    [self.view addSubview:self.searchView];
    
    __weak typeof(self)weakSelf = self;
    self.searchView.pushSearchBlock = ^{
        THNSearchViewController *searchVC = [[THNSearchViewController alloc]init];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    };
    
    [self.view addSubview:self.selectButtonView];
    self.selectButtonView.delegate = self;
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    [self.view addSubview:self.publicView];
    
    [self.publicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    if ([THNLoginManager sharedManager].openingUser) {
        THNLivingHallViewController *livingHall = [[THNLivingHallViewController alloc]init];
        [self addChildViewController:livingHall];
        self.livingHall = livingHall;
    }
    THNFeaturedViewController *featured = [[THNFeaturedViewController alloc]init];
    [self addChildViewController:featured];
    THNExploresViewController *explore = [[THNExploresViewController alloc]init];
    [self addChildViewController:explore];
   
    self.featured = featured;
    self.explore = explore;
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
        _searchView = [[THNHomeSearchView alloc]
                       initWithFrame:CGRectMake(20, 35 + STATUS_BAR_HEIGHT, SCREEN_WIDTH - 20 * 2, 40)];
        [_searchView setSearchType:SearchTypeHome];
    }
    return _searchView;
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray =  [THNLoginManager sharedManager].openingUser ? @[@"生活馆", @"精选", @"探索"] : @[@"精选", @"探索"];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
