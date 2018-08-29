//
//  THNFeaturedBrandModel.h
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNFeaturedBrandModel : NSObject

@property (nonatomic, strong) NSString *bgcover;
@property (nonatomic, assign) NSInteger store_products_counts;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *products_cover;
// 品牌馆ID
@property (nonatomic, strong) NSString *rid;

@end
