//
//  THNAllBrandHallViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAllBrandHallViewController.h"
#import "THNSelectButtonView.h"
#import "UIView+Helper.h"
#import "THNBrandHallFeaturesTableViewController.h"
#import "THNBrandHallFeaturedViewController.h"

@interface THNAllBrandHallViewController ()<THNNavigationBarViewDelegate, THNSelectButtonViewDelegate>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
// 承载selectButton切换展示Controller的View
@property (nonatomic, strong) UIView *publicView;
// 当前控制器
@property (nonatomic, strong) UIViewController *currentSubViewController;

@end

@implementation THNAllBrandHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_gray"];
    self.navigationBarView.title = @"品牌馆";
    self.selectButtonView.delegate = self;
    [self.view addSubview:self.selectButtonView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    [self.view addSubview:self.publicView];
    [self.publicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    THNBrandHallFeaturesTableViewController *features = [[THNBrandHallFeaturesTableViewController alloc]init];
    [self addChildViewController:features];
    THNBrandHallFeaturedViewController *featured = [[THNBrandHallFeaturedViewController alloc]init];
    [self addChildViewController:featured];
    self.childViewControllers[0].view.frame = self.publicView.bounds;
    [self.publicView addSubview:self.childViewControllers[0].view];
    self.currentSubViewController = self.childViewControllers[0];
    
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"特色", @"精选"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(5, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 60) titles:titleArray initWithButtonType:ButtonTypeDefault];
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
    __weak typeof(self)weakSelf = self;
    [self transitionFromViewController:self.currentSubViewController toViewController:self.childViewControllers[index] duration:0.5 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            weakSelf.currentSubViewController = self.childViewControllers[index];
        }
    }];
}


@end
