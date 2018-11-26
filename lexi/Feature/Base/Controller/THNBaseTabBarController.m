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
#import "THNDiscoverViewController.h"
#import "THNMyCenterViewController.h"
#import "THNSignInViewController.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNLoginManager.h"
#import "AppDelegate.h"
#import "UIViewController+THNHud.h"

@interface THNBaseTabBarController () <UITabBarControllerDelegate> {
    THNHomeViewController       *_homeVC;
    THNDiscoverViewController   *_discoverVC;
    THNCartViewController       *_cartVC;
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
        THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
        THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
        [appDelegate.window.rootViewController presentViewController:navController animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
//    self.tabBar.translucent = NO;
    
    [self initTabBarController];
}

/**
 初始化 TabBarController 视图控制器
 */
- (void)initTabBarController {
    _homeVC = [[THNHomeViewController alloc] init];
    _discoverVC = [[THNDiscoverViewController alloc] init];
    _cartVC = [[THNCartViewController alloc] init];
    _myCenterVC = [[THNMyCenterViewController alloc] init];
    
    NSArray *controllerArr = @[_homeVC, _discoverVC, _cartVC, _myCenterVC];
    NSArray *titleArr = @[@"首页", @"发现", @"购物车", @"我的"];
    NSArray *defaultimageArr = @[@"tabbar_home_default", @"tabbar_discover_default", @"tabbar_cart_default", @"tabbar_myCenter_default"];
    NSArray *selectedImageArr = @[@"tabbar_home_selected", @"tabbar_discover_selected", @"tabbar_cart_selected", @"tabbar_myCenter_selected"];
    
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
        contorller.tabBarItem.image = [[UIImage imageNamed:defaultImages[idx]]
                                       imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        contorller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[idx]]
                                               imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        
        THNBaseNavigationController *navController = [[THNBaseNavigationController alloc] initWithRootViewController:contorller];
        [self addChildViewController:navController];
    }
}

/**
 统一设置所有 tabBarItem 的文字属性
 */
+ (void)initialize {
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#949EA6"],
                                         NSFontAttributeName: [UIFont systemFontOfSize:kFontSizeTabDefault]}
                              forState:(UIControlStateNormal)];
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kColorTabSelected],
                                         NSFontAttributeName: [UIFont systemFontOfSize:kFontSizeTabSelected]}
                              forState:(UIControlStateSelected)];
}

@end
