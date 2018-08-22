//
//  THNBaseNavigationController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseNavigationController.h"
#import "THNBaseViewController.h"

@interface THNBaseNavigationController ()

@end

@implementation THNBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.viewControllers.count) {
//        viewController.hidesBottomBarWhenPushed = YES;
//        self.navigationBar.hidden = YES;
//    }
    
    if ([viewController.class isSubclassOfClass:[THNBaseViewController class]]) {
        self.navigationBarHidden = YES;
    } else {
        self.navigationBarHidden = NO;
    }
    
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController * _Nullable)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        return [super popViewControllerAnimated:animated];
    }
    
    return nil;
}

@end
