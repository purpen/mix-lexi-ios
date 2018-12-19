//
//  THNGuideTool.m
//  lexi
//
//  Created by rhp on 2018/11/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGuideTool.h"
#import "THNSaveTool.h"
#import "THNConst.h"
#import "THNGuideCollectionViewController.h"
#import "THNHomeViewController.h"
#import "THNBaseTabBarController.h"

@implementation THNGuideTool

+ (UIViewController *)chooseRootViewController {
    NSString *newVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *oldVersion = [THNSaveTool objectForKey:kClientVersionKey];
    UIViewController *rootVC;

    if (![newVersion isEqualToString:oldVersion]) {
        rootVC = [[THNGuideCollectionViewController alloc] init];
        [THNSaveTool setObject:newVersion forKey:kClientVersionKey];

    } else {
        rootVC = [[THNBaseTabBarController alloc]init];
    }

    return rootVC;
}

@end
