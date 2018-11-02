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
#import "THNLogisticsViewController.h"
#import "THNEvaluationViewController.h"
#import "UIViewController+THNHud.h"
#import "THNPaymentViewController.h"
#import "THNBaseTabBarController.h"
#import "UIScrollView+THNMJRefresh.h"

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

@interface THNOrderViewController () <
    THNSelectButtonViewDelegate,
    THNOrderTableViewCellDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    THNNavigationBarViewDelegate,
    THNMJRefreshDelegate
>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableArray *allOrders;
@property (nonatomic, strong) NSMutableArray *waitDeliveryOrders;
@property (nonatomic, strong) NSMutableArray *waiteReceiptOrders;
@property (nonatomic, strong) NSMutableArray *evaluationOrders;
@property (nonatomic, strong) NSMutableArray *paymentOrders;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
// 之前记录的页码
@property (nonatomic, assign) NSInteger lastPage;

@end

@implementation THNOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderType = OrderTypeAll;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logisticsTracking:) name:kOrderLogisticsTracking object:nil];
    [self setupUI];
    [self loadOrdersData];
}

- (void)setupUI {
    self.navigationBarView.title = @"订单";
    [self.navigationBarView setNavigationBackButton];
    [self.view addSubview:self.selectButtonView];
    [self.view addSubview:self.tableView];
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadOrdersData {
    self.loadViewY = CGRectGetMaxY(self.selectButtonView.frame);
    
    if (self.currentPage == 1) {
        [self showHud];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"status"] = @(self.orderType);
    THNRequest *request = [THNAPI getWithUrlString:kUrlOrders requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [self.tableView endFooterRefreshAndCurrentPageChange:YES];
        [self.orders removeAllObjects];
        switch (self.orderType) {
            
            case OrderTypeAll:
                [self.allOrders addObjectsFromArray:result.data[@"orders"]];
                [self.orders setArray:self.allOrders];
                break;
            case OrderTypeWaitDelivery:
                [self.waitDeliveryOrders addObjectsFromArray:result.data[@"orders"]];
                [self.orders setArray:self.waitDeliveryOrders];
                break;
            case OrderTypWaiteReceipt:
                [self.waiteReceiptOrders addObjectsFromArray:result.data[@"orders"]];
                 [self.orders setArray:self.waiteReceiptOrders];
                break;
            case OrderTypeEvaluation:
                [self.evaluationOrders addObjectsFromArray:result.data[@"orders"]];
                 [self.orders setArray:self.evaluationOrders];
                break;
            case OrderTypePayment:
                [self.paymentOrders addObjectsFromArray:result.data[@"orders"]];
                 [self.orders setArray:self.paymentOrders];
                break;
        }

        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

- (void)logisticsTracking:(NSNotification *)notification {
    THNOrdersItemsModel *itemsModel = notification.userInfo[@"itemModel"];
    THNLogisticsViewController *logistics = [[THNLogisticsViewController alloc]init];
    logistics.itemsModel = itemsModel;
    [self.navigationController pushViewController:logistics animated:YES];
}

// 删除订单
- (void)deleteOrderData:(NSString *)rid initWithCurrenIndex:(NSInteger)index {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlOrdersDelete requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        [self.orders removeObjectAtIndex:index];
        [self.tableView deleteRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
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
        self.lastPage = self.currentPage;
        self.currentPage = 1;
        [self.tableView resetCurrentPageNumber];
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
        [self deleteOrderData:orderModel.rid initWithCurrenIndex:currentIndexPath.row];
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
    
    THNOrdersModel *orderModel = [THNOrdersModel mj_objectWithKeyValues:self.orders[indexPath.row]];
    
    if (orderModel.user_order_status == OrderStatusReceipt) {
        NSArray *items = orderModel.items;
        // 获取不隐藏运费模板的数量
        NSMutableArray *expressArr = [NSMutableArray array];
        for (NSDictionary *dict in orderModel.items) {
            [expressArr addObject:dict[@"express"]];
        }
        
        NSSet *set = [NSSet setWithArray:expressArr];
        if (set.count == 1) {
            return items.count *kOrderProductViewHeight + 114 + orderCellLineSpacing;
        } else {
            // 有运费模板商品的高度 + 无运费模板的高度 + 满减View的高度 + 其他的高度
            return set.count * (kOrderProductViewHeight + kOrderLogisticsViewHeight) + (items.count - set.count) * kOrderProductViewHeight + 114 + orderCellLineSpacing;
        }
    } else if (orderModel.user_order_status == OrderStatusWaitDelivery) {
        return kOrderProductViewHeight * orderModel.items.count + 75 + orderCellLineSpacing;
    } else {
        return kOrderProductViewHeight * orderModel.items.count + 114 + orderCellLineSpacing;
    }
}

#pragma mark - THNOrderTableViewCellDelegate
- (void)deleteOrder:(NSString *)rid initWithCell:(THNOrderTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self deleteOrderData:rid initWithCurrenIndex:indexPath.row];
}

- (void)pushOrderDetail:(NSString *)orderRid {
        THNOrderDetailViewController *detail = [[THNOrderDetailViewController alloc]init];
        detail.rid = orderRid;
        [self.navigationController pushViewController:detail animated:YES];
}

- (void)pushEvaluation:(NSArray *)products initWithRid:(NSString *)rid {
    THNEvaluationViewController *evaluationVC = [[THNEvaluationViewController alloc]init];
    evaluationVC.ealuationBlock = ^{
        [self loadOrdersData];
    };
    
    evaluationVC.products = products;
    evaluationVC.rid = rid;
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

// 确认收货
- (void)confirmReceipt {
    [self loadOrdersData];
}

// 付款
- (void)pushPayment:(THNOrderDetailModel *)detailModel initWithOrderRid:(NSString *)orderRid {
    THNPaymentViewController *paymentVC = [[THNPaymentViewController alloc]init];
    paymentVC.detailModel = detailModel;
    paymentVC.orderRid = orderRid;
    paymentVC.fromPaymentType = FromPaymentTypeOrderVC;
    [self.navigationController pushViewController:paymentVC animated:YES];
}

#pragma mark - THNNavigationBarViewDelegate
- (void)didNavigationBackButtonEvent {
    if (self.pushOrderDetailType == PushOrderDetailTypePaySuccess) {
        THNBaseTabBarController *tabVC = [[THNBaseTabBarController alloc]init];
        tabVC.selectedIndex = 0;
        [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - THNMJRefreshDelegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    
    // 切换页面拿到的数据一直加载第二页数据的问题
    if (self.currentPage == 1 && self.lastPage != 0) {
        self.currentPage = self.lastPage + 1;
    } else {
        self.currentPage = currentPage.integerValue;
    }
    
    [self loadOrdersData];
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

- (NSMutableArray *)allOrders {
    if (!_allOrders) {
        _allOrders = [NSMutableArray array];
    }
    return _allOrders;
}

- (NSMutableArray *)waitDeliveryOrders {
    if (!_waitDeliveryOrders) {
        _waitDeliveryOrders = [NSMutableArray array];
    }
    return _waitDeliveryOrders;
}

- (NSMutableArray *)waiteReceiptOrders {
    if (!_waiteReceiptOrders) {
        _waiteReceiptOrders = [NSMutableArray array];
    }
    return _waiteReceiptOrders;
}

- (NSMutableArray *)evaluationOrders {
    if (!_evaluationOrders) {
        _evaluationOrders = [NSMutableArray array];
    }
    return _evaluationOrders;
}

- (NSMutableArray *)paymentOrders {
    if (!_paymentOrders) {
        _paymentOrders = [NSMutableArray array];
    }
    return _paymentOrders;
}

@end
