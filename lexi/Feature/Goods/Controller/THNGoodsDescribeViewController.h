//
//  THNGoodsDescribeViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseTableViewController.h"
#import "THNGoodsManager.h"

@interface THNGoodsDescribeViewController : THNBaseTableViewController

- (instancetype)initWithGoodsModel:(THNGoodsModel *)goodsModel
                        storeModel:(THNStoreModel *)storeModel
                      freightModel:(THNFreightModel *)freightModel;

@end
