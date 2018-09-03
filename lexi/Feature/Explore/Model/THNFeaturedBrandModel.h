//
//  THNFeaturedBrandModel.h
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THNProductModel;

@interface THNFeaturedBrandModel : NSObject

// 背景图
@property (nonatomic, strong) NSString *bgcover;
// 上架商品数量
@property (nonatomic, assign) NSInteger store_products_counts;
 // 店铺logo
@property (nonatomic, strong) NSString *logo;
// 店铺名
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *products_cover;
// 品牌馆ID
@property (nonatomic, strong) NSString *rid;
// 国家
@property (nonatomic, strong) NSString *country;
// 城市
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSArray <THNProductModel *>*products;
//宣传语
@property (nonatomic, strong) NSString *tag_line;

@end
