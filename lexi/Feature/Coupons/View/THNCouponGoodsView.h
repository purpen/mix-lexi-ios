//
//  THNCouponGoodsView.h
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNCouponSharedModelProductSku.h"

@interface THNCouponGoodsView : UIView

/**
 店铺可用优惠券商品的数据
 */
- (void)thn_setStoreCouponGoodsSku:(THNCouponSharedModelProductSku *)sku;

@end
