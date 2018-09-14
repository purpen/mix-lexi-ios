//
//  THNOrderPreviewViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@class THNSkuModelItem;
@class THNAddressModel;

@interface THNOrderPreviewViewController : THNBaseViewController

@property (nonatomic, strong) THNSkuModelItem *skuItemModel;
@property (nonatomic, strong) THNAddressModel *addressModel;
// 购物车商品数组
@property (nonatomic, strong) NSArray *items;

@end
