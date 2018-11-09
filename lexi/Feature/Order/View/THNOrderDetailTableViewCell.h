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
@class THNFreightModelItem;

typedef void(^SelectDeliveryBlcok)(NSString *fid);

UIKIT_EXTERN NSString *const kSelectDelivery;

@interface THNOrderDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) THNOrdersItemsModel *itemsModel;
@property (nonatomic, strong) THNSkuModelItem *skuItemModel;
// 物流信息的View
@property (weak, nonatomic) IBOutlet UIView *logisticsView;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
// 配送方式
@property (weak, nonatomic) IBOutlet UILabel *deliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsTimeLabel;
// 物流公司名字
@property (nonatomic, strong) THNFreightModelItem *freightModel;

@property (nonatomic, copy) SelectDeliveryBlcok selectDeliveryBlcok;
// 物流跟踪
@property (weak, nonatomic) IBOutlet UIButton *logisticsButton;
// 选择配送方式按钮
@property (weak, nonatomic) IBOutlet UIButton *selectDeliveryButton;

- (void)setPaySuccessProductView:(THNOrdersItemsModel *)itemsModel;

@end
