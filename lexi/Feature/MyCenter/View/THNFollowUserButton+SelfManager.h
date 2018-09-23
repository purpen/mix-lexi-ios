//
//  THNFollowUserButton+SelfManager.h
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowUserButton.h"

@interface THNFollowUserButton (SelfManager)

/**
 管理用户关注状态
 
 @param status 关注状态
 @param uid 用户 id
 */
- (void)selfManagerFollowUserStatus:(THNUserFollowStatus)status userId:(NSString *)uid;

@end
