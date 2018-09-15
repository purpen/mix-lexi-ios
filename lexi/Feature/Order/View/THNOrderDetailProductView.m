//
//  THNOrderDetailProductView.m
//  mixcash
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailProductView.h"
#import "THNOrderStoreModel.h"
#import "THNOrdersItemsModel.h"
#import "NSString+Helper.h"
#import "THNOrderDetailModel.h"
#import <MJExtension/MJExtension.h>
#import "THNOrderDetailTableViewCell.h"

static NSString *const kOrderDetailCellIdentifier = @"kOrderDetailCellIdentifier";
// 商品信息View的高度
static CGFloat const productViewHeight = 75;
// 商品View下的配送方式View的高度
static CGFloat const loginsticsViewHeight = 80;

@interface THNOrderDetailProductView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 发货地址
@property (weak, nonatomic) IBOutlet UILabel *deliveryAddressLabel;
// 商品View下有配送方式View的个数
@property (nonatomic, assign) NSInteger loginsticsViewCount;
@property (nonatomic, strong) THNOrderDetailModel *detailModel;
@property (nonatomic, strong) NSString *firstExpressName;

@end

@implementation THNOrderDetailProductView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderDetailCellIdentifier];
}

- (CGFloat)setOrderDetailPayView:(THNOrderDetailModel *)detailModel {
    self.detailModel = detailModel;
    THNOrderStoreModel *storeModel = [THNOrderStoreModel mj_objectWithKeyValues:detailModel.store];
    THNOrdersItemsModel *itemsModel = [THNOrdersItemsModel mj_objectWithKeyValues:detailModel.items[0]];
    self.firstExpressName = itemsModel.express_name;
    self.storeNameLabel.text = storeModel.store_name;
    self.timeLabel.text = [NSString timeConversion:itemsModel.express_at initWithFormatterType:FormatterDay];
    switch (detailModel.user_order_status) {
        case OrderStatusWaitDelivery:
            self.orderStatusLabel.text = @"待发货";
            break;
        case OrderStatusReceipt:
            self.orderStatusLabel.text = @"待收货";
            break;
        case OrderStatusCancel:
            self.orderStatusLabel.text = @"交易取消";
            break;
        case OrderStatuspayment:
            self.orderStatusLabel.text = @"去付款";
            break;
        case OrderStatusEvaluation:
        case OrderStatusFinish:
            self.orderStatusLabel.text = @"交易成功";
            break;
    }
    
    self.loginsticsViewCount = 2;
    
    if (itemsModel.delivery_country.length == 0 || [itemsModel.delivery_country isEqualToString:@"中国"]) {
            self.deliveryAddressLabel.text = [NSString stringWithFormat:@"从%@发货",itemsModel.delivery_province];
    } else {
      self.deliveryAddressLabel.text = [NSString stringWithFormat:@"从%@,%@发货",itemsModel.delivery_country,itemsModel.delivery_province];
    }

    return 90 + self.detailModel.items.count * (productViewHeight + loginsticsViewHeight);
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailCellIdentifier forIndexPath:indexPath];
    THNOrdersItemsModel *itemsModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.detailModel.items[indexPath.row]];
    [cell setItemsModel:itemsModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return productViewHeight + loginsticsViewHeight;
}

@end
