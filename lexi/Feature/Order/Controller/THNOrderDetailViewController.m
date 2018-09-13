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

@interface THNOrderDetailViewController ()

@property (nonatomic, strong) THNOrderDetailPayView *payDetailView;
@property (nonatomic, strong) THNOrderDetailProductView *productView;
@property (nonatomic, strong) THNOrderDetailLogisticsView *logisticsView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation THNOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadOrderDetailData];
    [self setupUI];
}

- (void)loadOrderDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:[NSString stringWithFormat:@"/core_orders/%@",self.rid] requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNOrderDetailModel *detailModel = [THNOrderDetailModel mj_objectWithKeyValues:result.data];
        [self.payDetailView setDetailModel:detailModel];
        [self.logisticsView setDetailModel:detailModel];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    self.navigationBarView.title = @"订单详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.payDetailView];
    [self.scrollView addSubview:self.productView];
    [self.scrollView addSubview:self.logisticsView];
}

#pragma mark - lazy
- (THNOrderDetailPayView *)payDetailView {
    if (!_payDetailView) {
        _payDetailView = [THNOrderDetailPayView viewFromXib];
        _payDetailView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 350);
    }
    return _payDetailView;
}

- (THNOrderDetailProductView *)productView {
    if (!_productView) {
        _productView = [THNOrderDetailProductView viewFromXib];
        _productView.frame = CGRectMake(0, CGRectGetMaxY(self.payDetailView.frame) + 10, SCREEN_WIDTH, 254);
    }
    return _productView;
}

- (THNOrderDetailLogisticsView *)logisticsView {
    if (!_logisticsView) {
        _logisticsView = [THNOrderDetailLogisticsView viewFromXib];
        _logisticsView.frame = CGRectMake(0, CGRectGetMaxY(self.productView.frame), SCREEN_WIDTH, 200);
    }
    return _logisticsView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.logisticsView.frame));
    }
    return _scrollView;
}

@end
