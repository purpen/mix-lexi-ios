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
#import "UIColor+Extension.h"

static const void *loadHeightKey = &loadHeightKey;
NSString * const _loadHeightKey = @"loadHeightKey";
static char loadViewKey;

static const void *kIsTransparent = @"kIsTransparent";
static const void *kIsAddWindow = @"kIsAddWindow";
static const void *kIsFromMain = @"kIsFromMain";

@implementation UIViewController (THNHud)

#pragma mark - loadViewY的动态绑定
- (CGFloat)loadViewY {
    NSNumber *scaleValue = objc_getAssociatedObject(self, (__bridge const void *)(_loadHeightKey));
    return scaleValue.floatValue;
}

- (void)setLoadViewY:(CGFloat)loadViewY {
    objc_setAssociatedObject(self, (__bridge const void *)_loadHeightKey,  @(loadViewY) , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 是否透明的动态绑定
- (BOOL)isTransparent {
    return [objc_getAssociatedObject(self, kIsTransparent) boolValue];
}

- (void)setIsTransparent:(BOOL)isTransparent {
    objc_setAssociatedObject(self, kIsTransparent, [NSNumber numberWithBool:isTransparent], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAddWindow {
    return [objc_getAssociatedObject(self, kIsAddWindow) boolValue];
}

- (void)setIsAddWindow:(BOOL)isAddWindow {
    objc_setAssociatedObject(self, kIsAddWindow, [NSNumber numberWithBool:isAddWindow], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isFromMain {
    return [objc_getAssociatedObject(self, kIsFromMain) boolValue];
}

- (void)setIsFromMain:(BOOL)isFromMain {
    objc_setAssociatedObject(self, kIsFromMain, [NSNumber numberWithBool:isFromMain], OBJC_ASSOCIATION_ASSIGN);
}

- (void)showHud{
    THNLoadView *loadView = objc_getAssociatedObject(self, &loadViewKey);
    
    if (!loadView) {
        loadView = [THNLoadView viewFromXib];
    }

    if (self.loadViewY == 0) {
        self.loadViewY = 0;
    }
    
    CGFloat tabbarHeight = kDeviceiPhoneX ? 84 : 50;
    
    loadView.frame = self.isFromMain ? CGRectMake(0, self.loadViewY, SCREEN_WIDTH, SCREEN_HEIGHT - self.loadViewY - tabbarHeight) : CGRectMake(0, self.loadViewY, SCREEN_WIDTH, SCREEN_HEIGHT - self.loadViewY);
    
    if (self.isTransparent) {
        loadView.backgroundColor = [UIColor clearColor];
    } else {
        loadView.backgroundColor = [UIColor whiteColor];
    }
    
    loadView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    objc_setAssociatedObject(self, &loadViewKey, loadView , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
    if (self.isAddWindow) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:loadView];
    } else {
        [self.view addSubview:loadView];
    }
   
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
