//
//  THNSearchDetailViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchDetailViewController.h"
#import "THNSearchView.h"
#import "THNSelectButtonView.h"
#import "UIView+Helper.h"
#import "THNSearchProductViewController.h"
#import "THNSearchUserTableViewController.h"
#import "THNSearchStoreTableViewController.h"
#import "THNSaveTool.h"

static NSString *const kUrlSearchProduct = @"/core_platforms/search/products";
static NSString *const kUrlSearchStore = @"/core_platforms/search/stores";
static NSString *const kUrlSearchUser  = @"/core_platforms/search/users";

@interface THNSearchDetailViewController ()<THNSearchViewDelegate, THNSelectButtonViewDelegate>

@property (nonatomic, strong) THNSearchView *searchView;
@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
// 承载selectButton切换展示Controller的View
@property (nonatomic, strong) UIView *publicView;
// 当前控制器
@property (nonatomic, strong) UIViewController *currentSubViewController;

@end

@implementation THNSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.searchView layoutSearchView:SearchViewTypeNoCancel withSearchKeyword:[THNSaveTool objectForKey:kSearchKeyword]];
    self.searchView.delegate = self;
    [self.navigationBarView addSubview:self.searchView];
    [self.view addSubview:self.selectButtonView];
    self.selectButtonView.delegate = self;
    [self.selectButtonView setDefaultShowIndex:self.childVCType];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    [self.view addSubview:self.publicView];
    
    [self.publicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    THNSearchProductViewController *searchProductVC = [[THNSearchProductViewController alloc]init];
    [self addChildViewController:searchProductVC];
    THNSearchStoreTableViewController *searchStoreVC = [[THNSearchStoreTableViewController alloc]init];
    [self addChildViewController:searchStoreVC];
    THNSearchUserTableViewController *searchUserVC = [[THNSearchUserTableViewController alloc]init];
    [self addChildViewController:searchUserVC];
    self.childViewControllers[self.childVCType].view.frame = self.publicView.bounds;
    [self.publicView addSubview:self.childViewControllers[self.childVCType].view];
    self.currentSubViewController = self.childViewControllers[self.childVCType];
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

- (void)back {
    NSString *searchWord = [THNSaveTool objectForKey:kSearchKeyword];
    self.searchDetailBlock(searchWord);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy
- (THNSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[THNSearchView alloc]initWithFrame:CGRectMake(47, STATUS_BAR_HEIGHT + 5, SCREEN_WIDTH - 67, 30)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"商品", @"品牌馆", @"用户"];
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



@end
