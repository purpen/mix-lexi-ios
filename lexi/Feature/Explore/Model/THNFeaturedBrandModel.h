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
// 首页页面商品数量字段
@property (nonatomic, assign) NSInteger product_count;
 // 店铺logo
@property (nonatomic, strong) NSString *logo;
// 店铺名
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray *products_cover;
// 品牌馆ID
@property (nonatomic, strong) NSString *rid;
// 国家
@property (nonatomic, strong) NSString *delivery_country;
// 城市
@property (nonatomic, strong) NSString *delivery_city;
@property (nonatomic, strong) NSArray <THNProductModel *>*products;
//宣传语
@property (nonatomic, strong) NSString *tag_line;

@property (nonatomic, assign) BOOL is_followed;

@property (nonatomic, strong) NSString *store_logo;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *store_rid;
@property (nonatomic, assign) NSInteger product_counts;
@property (nonatomic, assign) BOOL is_follow_store;


@end
