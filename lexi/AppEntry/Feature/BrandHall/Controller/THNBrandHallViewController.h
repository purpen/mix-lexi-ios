//
//  THNBrandHallViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNBaseViewController.h"


/**
 品牌馆Collection显示数据

 - BrandShowTypeProduct: 商品
 - BrandShowTypelifeRecord: 种草清单
 */
typedef NS_ENUM(NSUInteger, BrandShowType) {
    BrandShowTypeProduct,
    BrandShowTypelifeRecord
};

@interface THNBrandHallViewController : THNBaseViewController

// 品牌馆ID
@property (nonatomic, strong) NSString *rid;

@end
