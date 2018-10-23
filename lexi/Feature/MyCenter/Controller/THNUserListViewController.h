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
};

@interface THNUserListViewController : THNBaseViewController

- (instancetype)initWithType:(THNUserListType)type requestId:(NSString *)requestId;

@end
