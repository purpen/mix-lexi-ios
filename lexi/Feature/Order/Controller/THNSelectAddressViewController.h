//
//  THNSelectAddressViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNSkuModelItem.h"

@interface THNSelectAddressViewController : THNBaseViewController

/**
 选择的 sku
 */
@property (nonatomic, strong) NSArray *selectedSkuItems;

/**
 每件商品的发货地
 */
@property (nonatomic, strong) NSArray *deliveryCountrys;

/**
 结算商品总价
 */
@property (nonatomic, assign) CGFloat goodsTotalPrice;

@end
