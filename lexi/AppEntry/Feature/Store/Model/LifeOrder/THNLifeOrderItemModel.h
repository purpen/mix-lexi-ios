//
//  THNLifeOrderItemModel.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeOrderItemModel : NSObject

@property (nonatomic, strong) NSString *product_rid;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *s_color;
@property (nonatomic, strong) NSString *s_model;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) CGFloat sale_price;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger express_no;
@property (nonatomic, strong) NSString *express_code;
// 分销佣金
@property (nonatomic, assign) CGFloat order_sku_commission_price;
// 佣金比例
@property (nonatomic, assign) CGFloat order_sku_commission_rate;

@end
