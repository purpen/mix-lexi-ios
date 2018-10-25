//
//  THNUserListViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, THNUserListType) {
    THNUserListTypeLikeGoods = 0,   // 喜欢商品的人
    THNUserListTypeFans,            // 粉丝列表
    THNUserListTypeFollow,          // 关注的人列表
    THNUserListTypeOtherFans,       // 其他人的粉丝列表
    THNUserListTypeOtherFollow,     // 其他人的关注列表
};

@interface THNUserListViewController : THNBaseViewController

- (instancetype)initWithType:(THNUserListType)type requestId:(NSString *)requestId;

@end
