//
//  THNCouponsCenterViewController.h
//  lexi
//
//  Created by FLYang on 2018/10/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, THNCouponsType) {
    THNCouponsTypeShared = 0,   // 同享券（品牌）
    THNCouponsTypeSingle,       // 单享券（商品）
};

@interface THNCouponsCenterViewController : THNBaseViewController

@end
