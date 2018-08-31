//
//  THNGoodsButton+SelfManager.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsButton.h"

@interface THNGoodsButton (SelfManager)

/**
 获取商品 SKU 信息

 @param productId 商品 id
 */
- (void)selfManagerGetProductSkuInfoWithId:(NSString *)productId;

@end
