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
 @param model 用户数据
 */
- (void)selfManagerFollowUserStatus:(THNUserFollowStatus)status userModel:(THNUserModel *)model;
- (void)selfManagerFollowUserStatus:(THNUserFollowStatus)status grassListModel:(THNGrassListModel *)model;
- (void)selfManagerFollowUserStatus:(THNUserFollowStatus)status shopWindowModel:(THNShopWindowModel *)model;
- (void)selfManagerFollowUserStatus:(THNUserFollowStatus)status dynamicModel:(THNDynamicModel *)model;


@end
