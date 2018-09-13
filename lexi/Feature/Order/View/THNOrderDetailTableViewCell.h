//
//  THNOrderDetailTableViewCell.h
//  lexi
//
//  Created by rhp on 2018/9/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNOrdersItemsModel;

@interface THNOrderDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) THNOrdersItemsModel *itemsModel;
// 物流信息的View
@property (weak, nonatomic) IBOutlet UIView *logisticsView;

@end
