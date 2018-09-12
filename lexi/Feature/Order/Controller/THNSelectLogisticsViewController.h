//
//  THNSelectLogisticsViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@interface THNSelectLogisticsViewController : THNBaseViewController

/**
 初始化商品、物流信息

 @param goodsData 商品数据
 @param logisticsData 物流数据
 @return self
 */
- (instancetype)initWithGoodsData:(NSArray *)goodsData logisticsData:(NSArray *)logisticsData;

@end
