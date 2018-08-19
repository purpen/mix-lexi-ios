//
//  THNLikedGoodsViewController.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNUserManager.h"

@interface THNLikedGoodsViewController : THNBaseViewController

/**
 根据显示的商品类型初始化
 */
- (instancetype)initWithShowProductsType:(THNProductsType)type;

@end
