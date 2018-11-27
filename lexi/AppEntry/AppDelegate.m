//
//  AppDelegate.m
//  lexi
//
//  Created by FLYang on 2018/6/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNBaseNavigationController.h"
#import "THNBaseTabBarController.h"
#import "THNLoginViewController.h"
#import "THNPaymentViewController.h"
#import "THNLoginManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <UMAnalytics/MobClick.h>
#import <UMAnalytics/DplusMobClick.h>
#import <UMAnalytics/MobClickGameAnalytics.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>
#import "THNAlertView.h"

static NSString *const kCancelPayOrderTitle = @"取消支付";

@interface AppDelegate ()<WXApiDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setRootViewController];
    [self setThirdExpandConfig];
    [self configUSharePlatforms];
    [self configUmengAnalytics];
    [self configWXPlatforms];
    [self configureUMessageWithLaunchOptions:launchOptions];
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
    [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class]
                                  didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification
                                    didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
}

#pragma mark - 友盟推送设置
- (void)configureUMessageWithLaunchOptions:(NSDictionary *)launchOptions  {
    // Push功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
        } else {
            
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate
//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于后台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
}

//iOS10以下使用这两个方法接收通知
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [UMessage registerDeviceToken:deviceToken];
}

#pragma mark - 友盟分享设置
- (void)configUSharePlatforms {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];

    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kWXAppKey
                                       appSecret:kWXAppSecret
                                     redirectURL:@"http:mobile.umeng.com/social"];
    /* 移除相应平台的分享，如微信收藏 */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:kQQAppId /*设置QQ平台的appID*/
                                       appSecret:nil
                                     redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:kWBAppKey
                                       appSecret:kWBAppSecret
                                     redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

#pragma mark 友盟统计
- (void)configUmengAnalytics {
    /* 初始化友盟所有组件产品
     * appKey 开发者在友盟官网申请的AppKey.
     * channel 渠道标识，可设置nil表示"App Store".
     */
    [UMConfigure initWithAppkey:kUMAppKey channel:@"App Store"];
    
    /* 启用 DPlus 功能 */
    [MobClick setScenarioType:E_UM_DPLUS];
    
    /* 设置是否对日志信息进行加密 */
    [UMConfigure setEncryptEnabled:YES];
    
    /* 输出sdk的log信息 */
    [UMConfigure setLogEnabled:YES];
    
    /* 需要统计应用自身的账号 */
    if ([THNLoginManager isLogin]) {
        [MobClick profileSignInWithPUID:[THNLoginManager sharedManager].userId provider:@"IOS"];
    }
    
    /* 获取集成测试的 deviceID */
//    NSString *deviceID =  [UMConfigure deviceIDForIntegration];
    
#ifdef DEBUG
//    NSLog(@"\n\n--- 集成测试的 deviceID:\n    %@\n", deviceID);
#endif
}

#pragma mark - 微信支付设置
- (void)configWXPlatforms {
    [WXApi registerApp:kWXAppKey];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
//        跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //  6001 = 取消
            if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                [SVProgressHUD thn_showInfoWithStatus:kCancelPayOrderTitle];
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:THNPayMentVCPayCallback object:nil];
            }
        }];
        
    } else {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        if (!result) {
            return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
        }
        return result;
    }
    return YES;
}

#pragma mark WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        // -2为取消
        if (resp.errCode == -2) {
            [SVProgressHUD thn_showInfoWithStatus:kCancelPayOrderTitle];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:THNPayMentVCPayCallback object:nil];
        }
    }
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
