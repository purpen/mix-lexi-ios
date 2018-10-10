//
//  THNOrderDetailViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailViewController.h"
#import "THNOrderDetailPayView.h"
#import "THNOrderDetailProductView.h"
#import "THNOrderDetailLogisticsView.h"
#import "UIView+Helper.h"
#import "THNOrderDetailModel.h"
#import "THNOrdersItemsModel.h"
#import "THNLogisticsViewController.h"
#import "THNOrderDetailTableViewCell.h"

@interface THNOrderDetailViewController ()

@property (nonatomic, strong) THNOrderDetailPayView *payDetailView;
@property (nonatomic, strong) THNOrderDetailProductView *productView;
@property (nonatomic, strong) THNOrderDetailLogisticsView *logisticsView;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) THNOrderDetailModel *detailModel;
@property (nonatomic, strong) THNOrdersItemsModel *itemModel;
@property (nonatomic, strong) THNOrderStoreModel *storeModel;

@end

@implementation THNOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.pushOrderDetailType == PushOrderDetailTypeOrder) {
        self.requestUrl = [NSString stringWithFormat:@"/core_orders/%@",self.rid];
    } else {
        self.requestUrl = [NSString stringWithFormat:@"/orders/after_payment/%@",self.rid];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logisticsTracking:) name:kOrderLogisticsTracking object:nil];
    [self loadOrderDetailData];
    [self setupUI];
}

- (void)loadOrderDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:self.requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
       self.detailModel = [THNOrderDetailModel mj_objectWithKeyValues:result.data];
        CGFloat payDetailViewHeight = [self.payDetailView setOrderDetailPayView:self.detailModel];
        self.payDetailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, payDetailViewHeight);
        CGFloat productDetailViewHeight = [self.productView setOrderDetailPayView:self.detailModel];
        self.productView.frame = CGRectMake(0, CGRectGetMaxY(self.payDetailView.frame) + 10, SCREEN_WIDTH, productDetailViewHeight);
        [self.logisticsView setDetailModel:self.detailModel];
        self.logisticsView.frame = CGRectMake(0, CGRectGetMaxY(self.productView.frame), SCREEN_WIDTH, 105);
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.logisticsView.frame) + 100);
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)logisticsTracking:(NSNotification *)notification {
    THNOrdersItemsModel *itemsModel = notification.userInfo[@"itemModel"];
    THNLogisticsViewController *logistics = [[THNLogisticsViewController alloc]init];
    logistics.itemsModel = itemsModel;
    [self.navigationController pushViewController:logistics animated:YES];
}

- (void)setupUI {
    self.navigationBarView.title = @"订单详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.payDetailView];
    [self.scrollView addSubview:self.productView];
    [self.scrollView addSubview:self.logisticsView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - lazy
- (THNOrderDetailPayView *)payDetailView {
    if (!_payDetailView) {
        _payDetailView = [THNOrderDetailPayView viewFromXib];
    }
    return _payDetailView;
}

- (THNOrderDetailProductView *)productView {
    if (!_productView) {
        _productView = [THNOrderDetailProductView viewFromXib];
    }
    return _productView;
}

- (THNOrderDetailLogisticsView *)logisticsView {
    if (!_logisticsView) {
        _logisticsView = [THNOrderDetailLogisticsView viewFromXib];
    }
    return _logisticsView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    }
    return _scrollView;
}

@end
