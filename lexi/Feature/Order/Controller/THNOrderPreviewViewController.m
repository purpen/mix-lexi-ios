//
//  THNOrderPreviewViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderPreviewViewController.h"
#import "THNPaySuccessViewController.h"
#import "THNSelectLogisticsViewController.h"
#import "THNBuyProgressView.h"
#import "THNOrderDetailLogisticsView.h"
#import "UIView+Helper.h"
#import "THNOrderDetailPayView.h"
#import "THNPreViewTableViewCell.h"
#import "THNSkuModelItem.h"
#import "THNFreightModelItem.h"

static NSString *kTitleDone = @"提交订单";
static NSString *const KOrderPreviewCellIdentifier = @"KOrderPreviewCellIdentifier";
static NSString *const kUrlCreateOrder = @"/orders/create";
static NSString *const kUrlProductStoreSkus = @"/products/by_store_sku";
static NSString *const kUrlOrderCoupons = @"/market/user_order_coupons";
static NSString *const kUrlOrderFullReduction = @"/market/user_order_full_reduction";
static NSString *const kUrlLogisticsFreight = @"/logistics/freight/calculate";
static NSString *const kUrlLogisticsProductExpress = @"/logistics/product/express";
static NSString *const kUrlNewUserDiscount = @"/market/coupons/new_user_discount";

@interface THNOrderPreviewViewController ()<UITableViewDelegate, UITableViewDataSource>

/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 进度条
@property (nonatomic, strong) THNBuyProgressView *progressView;
// 保存View
@property (nonatomic, strong) UIView *saveView;
// 寄送地址等信息
@property (nonatomic, strong) THNOrderDetailLogisticsView *logisticsView;
// 支付价格等明细
@property (nonatomic, strong) THNOrderDetailPayView *payDetailView;
@property (nonatomic, strong) NSArray *skus;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *skuDict;
@property (nonatomic, strong) NSDictionary *logisticsDict;

@end

@implementation THNOrderPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProductStoreSkuData];
    [self loadOrderCoupons];
    [self loadOrderFullReduction];
    [self loadLogisticsFreightData];
    [self loadLogisticsProductExpressData];
    [self loadNewUserDiscountData];
    [self setupUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushSelectLogistics:) name:@"SelectDelivery" object:nil];
}

// 选择配送物流
- (void)pushSelectLogistics:(NSNotification *)notification {
    // 选中商品所在的行
    NSInteger productIndex = [notification.userInfo[@"selectProducIndex"]integerValue];
    // 选中店铺所在的行
    NSInteger storeIndex = [notification.userInfo[@"selectStoreIndex"]integerValue];
    NSString *storeKey = self.skuItems[storeIndex][@"rid"];
    NSArray *skus = self.skuDict[storeKey];
    NSString *skuKey = self.skuItems[storeIndex][@"sku_items"][productIndex][@"sku"];
    NSArray *expressArray = self.logisticsDict[storeKey][skuKey][@"express"];
    THNSelectLogisticsViewController *selectLogisticsVC = [[THNSelectLogisticsViewController alloc] initWithGoodsData:skus logisticsData:expressArray];
    selectLogisticsVC.didSelectedExpressItem = ^(THNFreightModelItem *expressModel) {
        NSLog(@"============ 获取的物流： %@", expressModel.expressName);
    };
    [self.navigationController pushViewController:selectLogisticsVC animated:YES];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    THNPaySuccessViewController *paySuccessVC = [[THNPaySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccessVC animated:YES];



}

// 按店铺编号分类根据sku编号获取的信息
- (void)loadProductStoreSkuData {
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *skus = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in self.skuItems) {
        [items  setArray:dict[@"sku_items"]];
    }
    
    for (NSDictionary *dict in items) {
        [skus addObject:dict[@"sku"]];
    }
    
    params[@"rids"] = [skus componentsJoinedByString:@","];
    THNRequest *request = [THNAPI getWithUrlString:kUrlProductStoreSkus requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.skuDict = result.data;
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 用户获取当前订单的符合条件的优惠券信息
- (void)loadOrderCoupons {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrderCoupons requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 用户获取当前订单的符合条件的满减信息
- (void)loadOrderFullReduction {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrderFullReduction requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 获取每件商品的物流公司列表
- (void)loadLogisticsProductExpressData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogisticsProductExpress requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.logisticsDict = result.data;
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 计算运费
- (void)loadLogisticsFreightData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address_rid"] = self.addressModel.rid;
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogisticsFreight requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
    
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 新用户折扣
- (void)loadNewUserDiscountData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    THNRequest *request = [THNAPI getWithUrlString:kUrlNewUserDiscount requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.saveView];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSubmitOrder;
}



#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.skuDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNPreViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KOrderPreviewCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    // 店铺id作为Key取商品的SKU信息
    NSString *key = self.skuItems[indexPath.row][@"rid"];
    // 取对应的商品数量
    NSArray *skuItems = self.skuItems[indexPath.row][@"sku_items"];
    self.skus = self.skuDict[key];

    [cell setPreViewCell:self.skus initWithItmeSkus:skuItems];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.payDetailView.frame);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.payDetailView.frame))];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    [headerView addSubview:self.logisticsView];
    [headerView addSubview:self.payDetailView];
    return headerView;
}

#pragma mark - getters and setters
- (UIButton *)doneButton {
    if (!_doneButton) {
        CGFloat originBottom = kDeviceiPhoneX ? 77 : 45;
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - originBottom, SCREEN_WIDTH - 30, 40)];
        [_doneButton setTitle:kTitleDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (THNBuyProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[THNBuyProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44)
                                                            index:1];
    }
    return _progressView;
}

- (THNOrderDetailLogisticsView *)logisticsView {
    if (!_logisticsView) {
        _logisticsView = [THNOrderDetailLogisticsView viewFromXib];
         [_logisticsView setAddressModel:self.addressModel];
        _logisticsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 112);
    }
    return _logisticsView;
}

- (THNOrderDetailPayView *)payDetailView {
    if (!_payDetailView) {
        _payDetailView = [THNOrderDetailPayView viewFromXib];
        _payDetailView.frame = CGRectMake(0, CGRectGetMaxY(self.logisticsView.frame) + 10, SCREEN_WIDTH, 350);
    }
    return _payDetailView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressView.frame) + 18, SCREEN_WIDTH, SCREEN_HEIGHT - 81) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"THNPreViewTableViewCell" bundle:nil] forCellReuseIdentifier:KOrderPreviewCellIdentifier];
    }
    return _tableView;
}

@end
