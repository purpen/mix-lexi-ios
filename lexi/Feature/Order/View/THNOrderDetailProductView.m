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
#import "THNPreViewTableViewCell.h"

static NSString *const kOrderDetailCellIdentifier = @"kOrderDetailCellIdentifier";
//// 商品信息View的高度
//static CGFloat const productViewHeight = 80;
//// 商品View下的配送方式View的高度
//static CGFloat const loginsticsViewHeight = 70;

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
@property (nonatomic, strong) NSArray *products;

@end

@implementation THNOrderDetailProductView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.scrollEnabled = NO;
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
            self.orderStatusLabel.text = @"待付款";
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
    
    // 按照express排序
    NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"express" ascending:YES]];
    self.products = [self.detailModel.items sortedArrayUsingDescriptors:sortArr];
    
    // 获取不隐藏运费模板的数量
    NSMutableArray *expressMutableArray = [NSMutableArray array];
    for (NSDictionary *dict in self.self.products) {
        [expressMutableArray addObject:dict[@"express"]];
    }
    
    NSSet *set = [NSSet setWithArray:expressMutableArray];
    // 其他的高度 +有运费模板商品的高度 + 无运费模板的高度
    return 90 + set.count * (kProductViewHeight + kLogisticsViewHeight) + (self.products.count - set.count) * kProductViewHeight;
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNOrdersItemsModel *itemsModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.products[indexPath.row]];
    // 最后一行不隐藏运费模板
    if (indexPath.row < self.products.count - 1) {
        // 该商品后面运费模板一样，隐藏选择运费模板
        if (itemsModel.express == [self.products[indexPath.row + 1][@"express"] integerValue]) {
            cell.logisticsView.hidden = YES;
        } else {
            cell.logisticsView.hidden = NO;
        }
        
    } else {
        cell.logisticsView.hidden = NO;
    }
    
    if (self.detailModel.user_order_status == OrderStatusReceipt) {
        cell.logisticsButton.hidden = NO;
    } else {
        cell.logisticsButton.hidden = YES;
    }
    [cell setItemsModel:itemsModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrdersItemsModel *itemsModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.products[indexPath.row]];
    if (indexPath.row < self.products.count - 1) {
        // 该商品后面运费模板一样，设置为商品的高度
        if (itemsModel.express == [self.products[indexPath.row + 1][@"express"] integerValue]) {
            return kProductViewHeight;
        } else {
            return kProductViewHeight + kLogisticsViewHeight;
        }
    } else {
        return kProductViewHeight + kLogisticsViewHeight;
    }
}

@end
