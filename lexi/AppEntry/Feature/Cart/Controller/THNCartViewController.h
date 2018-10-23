//
//  THNCartViewController.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, THNSelectedCartDataType) {
    THNSelectedCartDataTypeItem = 0,    // 商品数据
    THNSelectedCartDataTypeSku,         // sku id
    THNSelectedCartDataTypeProduct,     // 商品 id
};

@interface THNCartViewController : THNBaseViewController

@end
