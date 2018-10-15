//
//  UIViewController+THNHud.m
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UIViewController+THNHud.h"
#import <objc/runtime.h>
#import "UIView+Helper.h"
#import "THNLoadView.h"
#import "THNMarco.h"

static const void *loadHeightKey = &loadHeightKey;
NSString * const _loadHeightKey = @"loadHeightKey";
static char loadViewKey;

@implementation UIViewController (THNHud)

- (CGFloat)loadHeight{
    NSNumber *scaleValue = objc_getAssociatedObject(self, (__bridge const void *)(_loadHeightKey));
    return scaleValue.floatValue;
}

- (void)setLoadHeight:(CGFloat)loadHeight{
    objc_setAssociatedObject(self, (__bridge const void *)_loadHeightKey,  @(loadHeight) , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHud{
    THNLoadView *loadView = objc_getAssociatedObject(self, &loadViewKey);
    
    if (!loadView) {
        loadView = [THNLoadView viewFromXib];
    }

    if (self.loadHeight == 0) {
        self.loadHeight = 0;
    }

    loadView.frame = CGRectMake(0, self.loadHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    loadView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    objc_setAssociatedObject(self, &loadViewKey, loadView , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:loadView];
}

- (void)hiddenHud {

    THNLoadView *loadView = objc_getAssociatedObject(self, &loadViewKey);

    [loadView removeFromSuperview];

    loadView = nil;
}

//- (void)localShowHud {
//    BUSLocalloadingView * loadingView = [BUSLocalloadingView viewFromXib];
//    loadingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
//    objc_setAssociatedObject(self, &loadViewKey, loadingView , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self.view addSubview:loadingView];
//
//}

//- (void)localHiddenHud {
//    BUSLocalloadingView * loadingView = objc_getAssociatedObject(self, &loadViewKey);
//    [loadingView removeFromSuperview];
//}

@end
