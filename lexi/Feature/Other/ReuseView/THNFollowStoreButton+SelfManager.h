//
//  THNFollowStoreButton+SelfManager.h
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowStoreButton.h"

@interface THNFollowStoreButton (SelfManager)

/**
 管理店铺关注状态

 @param follow 是否关注
 @param rid 店铺 id
 */
- (void)selfManagerFollowStoreStatus:(BOOL)follow storeRid:(NSString *)rid;

@end
