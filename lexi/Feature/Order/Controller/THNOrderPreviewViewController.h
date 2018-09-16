//
//  THNOrderPreviewViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNAddressModel.h"
#import "THNSkuModelItem.h"

@class THNSkuModelItem;
@class THNAddressModel;


@interface THNOrderPreviewViewController : THNBaseViewController
/**
 选择的地址
 */
@property (nonatomic, strong) THNAddressModel *addressModel;

/**
 选择的 sku
 */
@property (nonatomic, strong) NSArray *skuItems;

@end
