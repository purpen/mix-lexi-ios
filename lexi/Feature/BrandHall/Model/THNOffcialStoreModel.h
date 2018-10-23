//
//  THNOffcialStoreModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNOffcialStoreModel : NSObject

@property (nonatomic, strong) NSString *city;
// 粉丝数
@property (nonatomic, assign) NSInteger fans_count;
// 文章数量
@property (nonatomic, assign) NSInteger life_record_count;
//商品数量
@property (nonatomic, assign) NSInteger product_count;
// 宣传语
@property (nonatomic, strong) NSString *tag_line;
//品牌馆名称
@property (nonatomic, strong) NSString *name;
//是否关注过
@property (nonatomic, assign) BOOL is_followed;

@property (nonatomic, strong) NSString *bgcover;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *logo;

@end
