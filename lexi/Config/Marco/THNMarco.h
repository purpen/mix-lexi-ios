//
//  THNMarco.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#ifndef THNMarco_h
#define THNMarco_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kDeviceiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDeviceiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WITHOUT_STATUS_HEIGHT    (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAVIGATION_BAR_HEIGHT           kDeviceiPhoneX ? 88 : 64
#define TABBAR_HEIGHT                   kDeviceiPhoneX ? 83 : 49
#define STATUS_BAR_HEIGHT               kDeviceiPhoneX ? 44 : 22
#define ADDRESS_TOP                     kDeviceiPhoneX ? 62 : 40
#define SEARCH_TOP                      kDeviceiPhoneX ? 52 : 27
#define kHPercentage(a)                 (SCREEN_HEIGHT * ((a) / 667.0))
#define kWPercentage(a)                 (SCREEN_WIDTH * ((a) / 375.0))

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#ifdef DEBUG
#define THNLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define THNLog(...)
#endif
#define WEAKSELF __weak __typeof(self)weakSelf = self;

#endif /* THNMarco_h */
