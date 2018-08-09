//
//  THNProductModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

@end
