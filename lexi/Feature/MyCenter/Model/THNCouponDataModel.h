//
//  THNCouponDataModel.h
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNCouponDataModel : NSObject

@property (nonatomic, strong) NSString *end_at;
@property (nonatomic, strong) NSString *get_at;
/// 是否过期
@property (nonatomic, assign) BOOL is_expired;
@property (nonatomic, assign) BOOL is_used;
@property (nonatomic, strong) NSString *order_rid;
@property (nonatomic, strong) NSString *store_logo;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *store_rid;
@property (nonatomic, strong) NSDictionary *coupon;

@end
