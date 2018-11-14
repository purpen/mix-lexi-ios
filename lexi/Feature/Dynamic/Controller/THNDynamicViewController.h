//
//  THNDynamicViewController.h
//  lexi
//
//  Created by FLYang on 2018/11/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@interface THNDynamicViewController : THNBaseViewController

/**
 用户的动态

 @param uid 用户id （查看自己的动态时，id = “”）
 @return self
 */
- (instancetype)initWithUserId:(NSString *)uid;

@end
