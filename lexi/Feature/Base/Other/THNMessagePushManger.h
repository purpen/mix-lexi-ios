//
//  THNMessagePushManger.h
//  lexi
//
//  Created by HongpingRao on 2018/11/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNBaseNavigationController.h"

@interface THNMessagePushManger : NSObject

+ (void)pushMessageTypeWithNavigationVC:(THNBaseNavigationController *)navi
                       initWithUserInfo:(NSDictionary *)userInfo;

@end
