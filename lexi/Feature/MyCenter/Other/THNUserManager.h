//
//  THNUserManager.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THNUserModel.h"

@interface THNUserManager : NSObject

/**
 获取自己的个人中心
 */
+ (void)getUserCenterCompletion:(void(^)(THNUserModel *model, NSError *error))completion;

@end
