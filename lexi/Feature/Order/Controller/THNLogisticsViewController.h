//
//  THNLogisticsViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/9/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@class THNOrdersItemsModel;

@interface THNLogisticsViewController : THNBaseViewController

@property (nonatomic, strong) THNOrdersItemsModel *itemsModel;
@property (nonatomic, strong) NSString *orderRid;

@end
