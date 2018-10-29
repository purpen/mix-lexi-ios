//
//  THNNotification.h
//  lexi
//
//  Created by FLYang on 2018/10/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _thn_handleNotification(name, notification) \
    - (void)thn_handleNotification##name:(NSNotification *)notification

@interface THNNotification : NSObject

@end

#pragma mark -
@interface NSObject (THNNotification)

@property(nonatomic, readonly, strong) NSMutableDictionary *notifications;

- (void)thn_postNotification:(NSString *)name userInfo:(id)userInfo;
- (void)thn_registerNotification:(NSString*)name;
- (void)thn_removeNotification:(NSString *)name;
- (void)thn_removeAllNotification;

@end
