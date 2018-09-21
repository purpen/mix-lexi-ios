//
//  THNSelectLogisticsViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
@class THNFreightModelItem;

/// 选择物流公司
typedef void(^DidSelectedExpressItemBlock)(THNFreightModelItem *expressModel);

@interface THNSelectLogisticsViewController : THNBaseViewController

@property (nonatomic, copy) DidSelectedExpressItemBlock didSelectedExpressItem;

/**
 初始化商品、物流信息

 @param goodsData 商品数据
 @param logisticsData 物流数据
 @return self
 */
- (instancetype)initWithGoodsData:(NSArray *)goodsData logisticsData:(NSArray *)logisticsData;

@property (nonatomic, strong) NSDictionary *expressParams;

@end
