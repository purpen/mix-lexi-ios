//
//  THNNotificationHeader.h
//  lexi
//
//  Created by FLYang on 2018/10/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#ifndef THNNotificationHeader_h
#define THNNotificationHeader_h

#import "THNNotification.h"

#define staticConstString(__string) static const NSString * __string = #__string
#define kNotificationName(name) staticConstString(name)

static NSString *const kNotificationFollowStore = @"kNotificationFollowStore";
static NSString *const kNotificationFollowUser  = @"kNotificationFollowUser";

#endif /* THNNotificationHeader_h */
