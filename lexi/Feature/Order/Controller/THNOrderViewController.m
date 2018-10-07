//
//  THNOrderViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderViewController.h"
#import "THNSelectButtonView.h"
#import "THNOrderTableViewCell.h"
#import "UIView+Helper.h"
#import "THNAPI.h"
#import "THNOrdersModel.h"
#import "THNOrderDetailViewController.h"
#import "THNBrandHallViewController.h"
#import "THNOrderStoreModel.h"

/**
 请求订单类型

 - OrderTypeAll: 全部订单
 - OrderTypeWaitDelivery: 待发货
 - OrderTypWaiteReceipt: 待收货
 - OrderTypeEvaluation: 评价
 - OrderTypePayment: 待付款
 */
typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeAll,
    OrderTypeWaitDelivery,
    OrderTypWaiteReceipt,
    OrderTypeEvaluation,
    OrderTypePayment
};


static NSString *const kOrderCellIdentifier = @"kOrderCellIdentifier";
static NSString *const kUrlOrders = @"/orders";
static NSString *const kUrlOrdersDelete = @"/orders/delete";

@interface THNOrderViewController ()<THNSelectButtonViewDelegate, UITableViewDelegate, UITableViewDataSource ,THNOrderTableViewCellDelegate>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSArray *allOrders;
@property (nonatomic, strong) NSArray *waitDeliveryOrders;
@property (nonatomic, strong) NSArray *waiteReceiptOrders;
@property (nonatomic, strong) NSArray *evaluationOrders;
@property (nonatomic, strong) NSArray *paymentOrders;

@end

@implementation THNOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderType = OrderTypeAll;
    [self loadOrdersData];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.title = @"订单";
    [self.view addSubview:self.selectButtonView];
    [self.view addSubview:self.tableView];
}

- (void)loadOrdersData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = @(self.orderType);
    THNRequest *request = [THNAPI getWithUrlString:kUrlOrders requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.orders removeAllObjects];
        switch (self.orderType) {
            
            case OrderTypeAll:
                self.allOrders = result.data[@"orders"];
                [self.orders setArray:self.allOrders];
                break;
            case OrderTypeWaitDelivery:
                self.waitDeliveryOrders = result.data[@"orders"];
                [self.orders setArray:self.waitDeliveryOrders];
                break;
            case OrderTypWaiteReceipt:
                self.waiteReceiptOrders = result.data[@"orders"];
                 [self.orders setArray:self.waiteReceiptOrders];
                break;
            case OrderTypeEvaluation:
                self.evaluationOrders = result.data[@"orders"];
                 [self.orders setArray:self.evaluationOrders];
                break;
            case OrderTypePayment:
                self.paymentOrders= result.data[@"orders"];
                 [self.orders setArray:self.paymentOrders];
                break;
        }

        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 删除订单
- (void)deleteOrderData:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlOrdersDelete requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self loadOrdersData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma THNSelectButtonViewDelegate
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    
    [self.orders removeAllObjects];
    
    switch (index) {
        case 0:
            self.orderType = OrderTypeAll;
            [self.orders setArray:self.allOrders];
            break;
        case 1:
            self.orderType = OrderTypePayment;
            [self.orders setArray:self.paymentOrders];
            break;
        case 2:
            self.orderType = OrderTypeWaitDelivery;
            [self.orders setArray:self.waitDeliveryOrders];
            break;
        case 3:
            self.orderType = OrderTypWaiteReceipt;
            [self.orders setArray:self.waiteReceiptOrders];
            break;
        case 4:
            self.orderType = OrderTypeEvaluation;
            [self.orders setArray:self.evaluationOrders];
            break;
    }
    
    if (self.orders.count == 0) {
        [self loadOrdersData];
    } else {
        [self.tableView reloadData];
    }
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.countDownBlock = ^(THNOrderTableViewCell *cell) {
        NSIndexPath *currentIndexPath = [tableView indexPathForCell:cell];
        THNOrdersModel *orderModel = [THNOrdersModel mj_objectWithKeyValues:self.orders[currentIndexPath.row]];
        [self delete:orderModel.rid];
        [self.orders removeObjectAtIndex:currentIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    // 解决滑动没结束切换视图刷新tableView 数据越界问题
    if (self.orders.count == 0) {
        return cell;
    }
    
    THNOrdersModel *orderModel = [THNOrdersModel mj_objectWithKeyValues:self.orders[indexPath.row]];
    [cell setOrdersModel:orderModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrdersModel *orderModel = [THNOrdersModel mj_objectWithKeyValues:self.orders[indexPath.row]];
    THNBrandHallViewController *brandHall = [[THNBrandHallViewController alloc]init];
    brandHall.rid = orderModel.store.store_rid;
    [self.navigationController pushViewController:brandHall animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 解决滑动没结束切换视图刷新tableView 数据越界问题
    if (self.orders.count == 0) {
        return 0;
    }
    NSArray *items = self.orders[indexPath.row][@"items"];
    // 获取不隐藏运费模板的数量
    NSMutableArray *expressArr = [NSMutableArray array];
    for (NSDictionary *dict in items) {
        [expressArr addObject:dict[@"express"]];
    }
    
    NSSet *set = [NSSet setWithArray:expressArr];
    // 有运费模板商品的高度 + 无运费模板的高度 + 满减View的高度 + 其他的高度
    return set.count * (kOrderProductViewHeight + kOrderLogisticsViewHeight) + (items.count - set.count) * kOrderProductViewHeight + 114 + orderCellLineSpacing;
}

#pragma mark - THNOrderTableViewCellDelegate
- (void)deleteOrder:(NSString *)rid {
    [self deleteOrderData:rid];
}

- (void)pushOrderDetail:(NSString *)orderRid {
        THNOrderDetailViewController *detail = [[THNOrderDetailViewController alloc]init];
        detail.rid = orderRid;
        detail.pushOrderDetailType = PushOrderDetailTypeOrder;
        [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - lazy
- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 40) titles:titleArray initWithButtonType:ButtonTypeLine];
        _selectButtonView.backgroundColor = [UIColor whiteColor];
        _selectButtonView.delegate = self;
    }
    return _selectButtonView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableY = CGRectGetMaxY(self.selectButtonView.frame);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, SCREEN_HEIGHT - tableY ) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        [_tableView registerNib:[UINib nibWithNibName:@"THNOrderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCellIdentifier];
        //TableView刷新后位置偏移的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

@end
