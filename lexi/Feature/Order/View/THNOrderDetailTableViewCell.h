//
//  THNOrderDetailTableViewCell.h
//  lexi
//
//  Created by rhp on 2018/9/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNOrdersItemsModel;
@class THNSkuModelItem;

@interface THNOrderDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) THNOrdersItemsModel *itemsModel;
@property (nonatomic, strong) THNSkuModelItem *skuItemModel;
// 物流信息的View
@property (weak, nonatomic) IBOutlet UIView *logisticsView;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;

@end
