//
//  THNPaySuccessViewController.h
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseTableViewController.h"

@class THNOrderDetailModel;

@interface THNPaySuccessViewController : THNBaseTableViewController

@property (nonatomic, strong) THNOrderDetailModel *detailModel;
@property (nonatomic, strong) NSArray *orders;

@end
