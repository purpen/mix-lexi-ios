//
//  THNProductModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNProductModel : NSObject

@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) CGFloat min_price;
@property (nonatomic, assign) CGFloat max_price;
@property (nonatomic, assign) CGFloat min_sale_price;
@property (nonatomic, assign) CGFloat max_sale_price;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger like_count;
// 商品推荐语
@property (nonatomic, strong) NSString *features;
// 是否包邮
@property (nonatomic, assign) BOOL is_free_postage;
// 是否售罄
@property (nonatomic, assign) BOOL is_sold_out;
// 是否喜欢
@property (nonatomic, assign) BOOL is_like;

@end
