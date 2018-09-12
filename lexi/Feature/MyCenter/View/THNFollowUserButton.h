//
//  THNFollowUserButton.h
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNUserFollowStatus) {
    THNUserFollowStatusNot = 0,     // 未关注
    THNUserFollowStatusYet,         // 已关注
    THNUserFollowStatusMutually     // 互相关注
};

@interface THNFollowUserButton : UIButton

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) THNUserFollowStatus followStatus;

/**
 设置关注的状态
 */
- (void)setFollowUserStatus:(THNUserFollowStatus)status;

@end
