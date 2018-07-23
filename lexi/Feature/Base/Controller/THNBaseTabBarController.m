//
//  THNBaseTabBarController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseTabBarController.h"
#import "THNBaseNavigationController.h"
#import "THNHomeViewController.h"
#import "THNCartViewController.h"
#import "THNInboxViewController.h"
#import "THNMyCenterViewController.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNLoginManager.h"
#import "AppDelegate.h"

@interface THNBaseTabBarController () <UITabBarControllerDelegate> {
    THNHomeViewController       *_homeVC;
    THNCartViewController       *_cartVC;
    THNInboxViewController      *_inboxVC;
    THNMyCenterViewController   *_myCenterVC;
}

@end

@implementation THNBaseTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = 0;
        self.delegate = self;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - tabBar delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    THNBaseNavigationController *navController = (THNBaseNavigationController *)viewController;
    
    if ([navController.viewControllers[0] isKindOfClass:[THNMyCenterViewController class]]) {
        if ([THNLoginManager isLogin]) {
            return YES;
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate thn_loadLoginController];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    [self initTabBarController];
}

/**
 初始化 TabBarController 视图控制器
 */
- (void)initTabBarController {
    _homeVC = [[THNHomeViewController alloc] init];
    _cartVC = [[THNCartViewController alloc] init];
    _inboxVC = [[THNInboxViewController alloc] init];
    _myCenterVC = [[THNMyCenterViewController alloc] init];
    
    NSArray *controllerArr = @[_homeVC, _cartVC, _inboxVC, _myCenterVC];
    NSArray *titleArr = @[@"首页", @"购物车", @"收件箱", @"我的"];
    NSArray *defaultimageArr = @[@"tabbar_home_default", @"tabbar_cart_default", @"tabbar_inbox_default", @"tabbar_myCenter_default"];
    NSArray *selectedImageArr = @[@"tabbar_home_selected", @"tabbar_cart_selected", @"tabbar_inbox_selected", @"tabbar_myCenter_selected"];
    
    [self setChildViewController:controllerArr
                   defaultImages:defaultimageArr
                  selectedImages:selectedImageArr
                      itemTitles:titleArr];
}

/**
 设置子控制器属性
 
 @param controllers 控制器
 @param defaultImages 默认图片
 @param selectedImages 选中图片
 @param titles 文字
 */
- (void)setChildViewController:(NSArray *)controllers defaultImages:(NSArray *)defaultImages selectedImages:(NSArray *)selectedImages
                     itemTitles:(NSArray *)titles {
    //  添加子控制器
    for (NSUInteger idx = 0; idx < controllers.count; idx ++) {
        UIViewController *contorller = controllers[idx];
        contorller.tabBarItem.title = titles[idx];
        contorller.tabBarItem.image = [UIImage imageNamed:defaultImages[idx]];
        contorller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[idx]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        
        THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:contorller];
        [self addChildViewController:navController];
    }
}

/**
 统一设置所有 tabBarItem 的文字属性
 */
+ (void)initialize {
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:kColorTabDefault],
                                         NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeTabDefault]}
                              forState:(UIControlStateNormal)];
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:kColorTabSelected],
                                         NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeTabSelected]}
                              forState:(UIControlStateSelected)];
}

@end