//
//  AppDelegate.h
//  lexi
//
//  Created by FLYang on 2018/6/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 加载登录视图
 */
- (void)thn_loadLoginController;

@end

