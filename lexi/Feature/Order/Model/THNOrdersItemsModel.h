//
//  THNOrdersItemsModel.h
//  mixcash
//
//  Created by HongpingRao on 2018/7/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNOrdersItemsModel : NSObject
// 产品图片地址
@property (nonatomic, strong) NSString *cover;
// sku编码
@property (nonatomic, strong) NSString *id_code;
@property (nonatomic, strong) NSString *product_name;
// 零售价
@property (nonatomic, assign) CGFloat price;
// 购买数量
@property (nonatomic, assign) NSInteger quantity;
// 优惠价格
@property (nonatomic, assign) CGFloat discount_amount;
// 实付款
@property (nonatomic, assign) CGFloat sale_price;
// 物流公司编码
@property (nonatomic, strong) NSString *express_code;
// 运单号
@property (nonatomic, strong) NSString *express_no;

@end
