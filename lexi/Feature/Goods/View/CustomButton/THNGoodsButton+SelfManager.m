//
//  THNGoodsButton+SelfManager.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsButton+SelfManager.h"
#import "THNGoodsManager.h"

@implementation THNGoodsButton (SelfManager)

- (void)selfManagerGetProductSkuInfoWithId:(NSString *)productId {
    self.productId = productId;
    [self addTarget:self action:@selector(goodsButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)goodsButtonAction:(id)sender {
    [THNGoodsManager getProductSkusInfoWithId:self.productId params:@{} completion:^(THNSkuModel *model, NSError *error) {
        
    }];
}

@end
