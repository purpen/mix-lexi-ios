//
//  UIViewController+Analytics.m
//  lexi
//
//  Created by FLYang on 2018/11/21.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "UIViewController+Analytics.h"
#import <objc/runtime.h>
#import <UMAnalytics/MobClick.h>

@implementation UIViewController (Analytics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
    });
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)   {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)aop_viewWillAppear:(BOOL)animated {
    [self aop_viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
#ifdef DEBUG
//    NSLog(@"=== 进入 viewWillAppear:%@", NSStringFromClass([self class]));
#endif
}
- (void)aop_viewWillDisappear:(BOOL)animated {
    [self aop_viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
#ifdef DEBUG
//    NSLog(@"=== 退出 viewDisappear:%@", NSStringFromClass([self class]));
#endif
}

@end
