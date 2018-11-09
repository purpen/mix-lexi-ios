//
//  THNShareImageViewController.h
//  lexi
//
//  Created by FLYang on 2018/11/3.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, THNSharePosterType) {
    THNSharePosterTypeGoods = 0,    // 分享商品
    THNSharePosterTypeLifeStore,    // 生活馆
    THNSharePosterTypeWindow,       // 橱窗
    THNSharePosterTypeInvitation,   // 邀请
};

@interface THNShareImageViewController : THNBaseViewController

/**
 分享的各种海报

 @param type 海报的类型
 @return self
 */
- (instancetype)initWithType:(NSUInteger)type;

@end
