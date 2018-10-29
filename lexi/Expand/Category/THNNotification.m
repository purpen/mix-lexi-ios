//
//  THNNotification.m
//  lexi
//
//  Created by FLYang on 2018/10/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNNotification.h"
#import <objc/runtime.h>
#import <objc/message.h>

void (*THNNotification_action) (id, SEL, id) = (void (*)(id, SEL, id))objc_msgSend;

@interface THNNotification ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id sender;
@property (nonatomic, strong) id userInfo;

@end

@implementation THNNotification

- (instancetype)initWithName:(NSString *)name sender:(id)sender target:(id)taget selector:(SEL)selector {
    self = [super init];
    if (self) {
        _name = name;
        _sender = sender;
        _target = taget;
        _selector = selector;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:name
                                                   object:sender];
    }
    return self;
}

- (void)handleNotification:(NSNotification *)notification {
    (_target && _selector) ? THNNotification_action(_target, _selector, notification) : nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil];
}

@end

#pragma mark -
@implementation NSObject (THNNotification)

- (id)notifications {
    return objc_getAssociatedObject(self, _cmd) ? : ({
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, @selector(notifications), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        dic;
    });
}

- (void)thn_registerNotification:(NSString *)name {
    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"thn_handleNotification%@:", name]);
    
    if ([self respondsToSelector:aSel]) {
        [self notificationWihtName:name target:self selector:aSel];
        return;
    }
}

- (void)notificationWihtName:(NSString *)name target:(id)target selector:(SEL)selector {
    THNNotification *notification = [[THNNotification alloc] initWithName:name sender:nil target:target selector:selector];
    [self.notifications setObject:notification forKey:name];
}

- (void)thn_postNotification:(NSString *)name userInfo:(id)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

- (void)thn_removeNotification:(NSString *)name {
    [self.notifications removeObjectForKey:name];
}

- (void)thn_removeAllNotification {
    [self.notifications removeAllObjects];
}

@end
