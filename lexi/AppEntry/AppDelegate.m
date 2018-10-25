//
//  AppDelegate.m
//  lexi
//
//  Created by FLYang on 2018/6/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNBaseNavigationController.h"
#import "THNBaseTabBarController.h"
#import "THNLoginViewController.h"
#import "THNLoginManager.h"
#import <UMShare/UMShare.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setRootViewController];
    [self setThirdExpandConfig];
    
    
    return YES;
}

#pragma mark - 加载根视图
- (void)setRootViewController {
    THNBaseTabBarController *tabBarC = [[THNBaseTabBarController alloc] init];
    self.window.rootViewController = tabBarC;
    
   // [self thn_loadLoginController];
}

- (void)thn_loadLoginController {
    [[THNLoginManager sharedManager] clearLoginInfo];
    
    if (![THNLoginManager isLogin]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            THNLoginViewController *loginVC = [[THNLoginViewController alloc] init];
            THNBaseNavigationController *loginNavController = [[THNBaseNavigationController alloc] initWithRootViewController:loginVC];
            [self.window.rootViewController presentViewController:loginNavController animated:YES completion:nil];
        });
    }
}

#pragma mark - 第三方库设置
- (void)setThirdExpandConfig {
    //  SVP颜色设置
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    [SVProgressHUD setMinimumDismissTimeInterval:(NSTimeInterval)3];
    [SVProgressHUD setMaximumDismissTimeInterval:(NSTimeInterval)MAXFLOAT];
    
    //  键盘弹起模式
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 友盟设置
- (void)setupUMSocial {
    UMSocialManager *socialManger = [UMSocialManager defaultManager];
    [socialManger openLog:YES];
    [socialManger setPlaform:UMSocialPlatformType_Whatsapp appKey:<#(NSString *)#> appSecret:<#(NSString *)#> redirectURL:<#(NSString *)#>]
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
