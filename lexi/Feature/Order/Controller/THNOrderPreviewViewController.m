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
#import <MJExtension/MJExtension.h>
#import "THNCouponModel.h"
#import "THNFreightModelItem.h"
#import "THNPaymentViewController.h"
#import "THNOrderDetailTableViewCell.h"
#import "THNOrderDetailModel.h"

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
// sku
@property (nonatomic, strong) NSDictionary *skuDict;
// 物流
@property (nonatomic, strong) NSDictionary *logisticsDict;
// 满减
@property (nonatomic, strong) NSDictionary *fullReductionDict;
// 物流公司ID
@property (nonatomic, strong) NSMutableArray *expressIDArray;
// 运费
@property (nonatomic, strong) NSDictionary *freightDict;
// 优惠券
@property (nonatomic, strong) NSDictionary *couponDict;

// 满减View的高度
@property (nonatomic, assign) CGFloat fullReductionViewHeight;
// 总运费
@property (nonatomic, assign) CGFloat totalFreight;
// 总优惠券
@property (nonatomic, assign) CGFloat totalCouponAmount;
// 总满减金额
@property (nonatomic, assign) CGFloat totalReductionAmount;

@end

@implementation THNOrderPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadOrderCoupons];
    [self loadOrderFullReduction];
    [self loadLogisticsProductExpressData];
    [self loadNewUserDiscountData];
    [self loadProductStoreSkuData];
    [self setupUI];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushSelectLogistics:) name:kSelectDelivery object:nil];
}

//// 选择配送物流
//- (void)pushSelectLogistics:(NSNotification *)notification {
//    // 选中店铺所在的行
//    NSInteger storeIndex = [notification.userInfo[@"selectStoreIndex"]integerValue];
//    // 选中商品所在的行
//    NSInteger productIndex = [notification.userInfo[@"selectProducIndex"]integerValue];
//    // storeKey
//    NSString *storeKey = self.skuItems[storeIndex][@"rid"];
//
//    NSMutableDictionary *expressDict = [NSMutableDictionary dictionary];
//    expressDict[@"address_rid"] = self.addressModel.rid;
//    expressDict[@"fid"] = self.skuDict[storeKey][productIndex][@"fid"];
//
//
////    NSArray *skus = self.skuDict[storeKey];
////    params[@"address_rid"] = self.addressModel.rid;
////
////    for (NSDictionary *dict in self.skuItems) {
////        [items  setArray:dict[@"sku_items"]];
////    }
////
////    // 为sku字典添加express_id
////    [self.expressIDArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        [items[idx] setValue:obj forKey:@"express_id"];
////    }];
//
//    params[@"items"] = self.skuItems;
//    NSString *skuKey = self.skuItems[storeIndex][@"sku_items"][productIndex][@"sku"];
//    NSArray *expressArray = self.logisticsDict[storeKey][skuKey][@"express"];
//    [self.expressIDArray removeAllObjects];
//    // 取出所有的物流ID
//    for (NSDictionary *dict in expressArray) {
//        [self.expressIDArray addObject:dict[@"express_id"]];
//    }
//
//    THNSelectLogisticsViewController *selectLogisticsVC = [[THNSelectLogisticsViewController alloc] initWithGoodsData:skus logisticsData:expressArray];
//    selectLogisticsVC.didSelectedExpressItem = ^(THNFreightModelItem *expressModel) {
//         [self.expressIDArray removeAllObjects];
//        // 取出THNOrderDetailTableViewCell
//        THNOrderDetailTableViewCell *cell = self.tableView.subviews[0].subviews[0].subviews[0].subviews[3].subviews[0].subviews[0];
//        cell.deliveryMethodLabel.text = expressModel.expressName;
//        cell.logisticsTimeLabel.text = [NSString stringWithFormat:@"%ld至%ld天送达",(long)expressModel.minDays,(long)expressModel.maxDays];
//        // 替换为选中的expressId
//        [self.expressIDArray addObject:@(expressModel.expressId)];
//        // 计算运费
//        [self loadLogisticsFreightData];
//
//    };
//    [self.navigationController pushViewController:selectLogisticsVC animated:YES];
//}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    [self createOrder];
}

// 创建订单
- (void)createOrder {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *items = [NSMutableArray array];
    NSString *storeRid;
    NSMutableDictionary *item;

    // 取出字典的storeRid,重新命名key
    for (NSDictionary *dict in self.skuItems) {
        storeRid = dict[@"rid"];
        [items setArray:dict[@"sku_items"]];
    }

    // 取出每个sku信息，重新命名key
    for (NSDictionary *dict in items) {
        item = [@{@"rid":dict[@"sku"],@"quantity":dict[@"quantity"]} mutableCopy];
    }

    // 为sku字典添加express_id
    [self.expressIDArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setValue:obj forKey:@"express_id"];
    }];

    // 组合成后台对应的格式
    params[@"address_rid"] = self.addressModel.rid;
    params[@"store_items"] = @[
                                @{@"store_rid":storeRid, @"items":@[item]}
                              ];
    THNRequest *request = [THNAPI postWithUrlString:kUrlCreateOrder requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNPaymentViewController *paymentVC = [[THNPaymentViewController alloc] init];
        [self.navigationController pushViewController:paymentVC animated:YES];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

// 按店铺编号分类根据sku编号获取的信息
- (void)loadProductStoreSkuData {
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *skus = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in self.skuItems) {

        [items addObjectsFromArray:dict[@"sku_items"]];
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
        self.couponDict = result.data;
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 用户获取当前订单的符合条件的满减信息
- (void)loadOrderFullReduction {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrderFullReduction requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.fullReductionDict = result.data;
        
        for (NSDictionary *dict in self.skuItems) {
            NSDictionary *fullReductionDict = self.fullReductionDict[dict[@"rid"]];
            THNCouponModel *couponModel = [THNCouponModel mj_objectWithKeyValues:fullReductionDict];
            self.totalReductionAmount += couponModel.amount;
        }
        
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
        [self loadLogisticsFreightData];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 计算运费
- (void)loadLogisticsFreightData {
    
    NSMutableArray *newSkuItems = [NSMutableArray array];

    for (NSDictionary *skuDict in self.skuItems) {
        NSMutableDictionary *oriSkuDict = [NSMutableDictionary dictionaryWithDictionary:skuDict];
        NSDictionary *logisticsDict = self.logisticsDict[skuDict[@"rid"]];
        NSMutableArray *newSkuArr = [NSMutableArray array];

        for (NSDictionary *goodsDict in (NSArray *)skuDict[@"sku_items"]) {
            NSMutableDictionary *newSku = [NSMutableDictionary dictionaryWithDictionary:goodsDict];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default = YES"];
            NSArray *expressArray = [logisticsDict[goodsDict[@"sku"]][@"express"] filteredArrayUsingPredicate:predicate];
            NSString *logId = expressArray[0][@"express_id"];
            [newSku setObject:logId forKey:@"express_id"];
            [newSkuArr addObject:newSku];
        }

        [oriSkuDict setObject:newSkuArr forKey:@"sku_items"];
        [newSkuItems addObject:oriSkuDict];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address_rid"] = self.addressModel.rid;
    params[@"items"] = newSkuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogisticsFreight requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.freightDict = result.data;
        // 遍历所有总运费
        for (NSDictionary *dict in self.skuItems) {
            CGFloat freight  = [self.freightDict[dict[@"rid"]] floatValue];
            self.totalFreight += freight;
        }
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
    THNPreViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [THNPreViewTableViewCell viewFromXib];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    
    // 选择配送方式
    cell.preViewCellBlock = ^(NSMutableArray *skuIds, NSString *fid, NSInteger storeIndex) {
        NSMutableArray *items = [NSMutableArray array];
        NSMutableArray *goods = [NSMutableArray array];
         NSString *storeKey = self.skuItems[storeIndex][@"rid"];
        for (NSString *skuId in skuIds) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sku == %@",skuId];
            NSPredicate *productPredicate = [NSPredicate predicateWithFormat:@"rid == %@",skuId];
            [items addObjectsFromArray:[self.skuItems[storeIndex][@"sku_items"] filteredArrayUsingPredicate:predicate]];
            [goods addObjectsFromArray:[self.skuDict[storeKey] filteredArrayUsingPredicate:productPredicate]];
        }
        
        NSDictionary *expressParams = @{
                                        @"address_rid":self.addressModel.rid,
                                        @"fid":fid,
                                        @"items":items
                                        };
         THNSelectLogisticsViewController *selectLogistcisVC = [[THNSelectLogisticsViewController alloc] initWithGoodsData:goods
                                                                                                             logisticsData:expressParams];
        [self.navigationController pushViewController:selectLogistcisVC animated:YES];
    };

    // 店铺id作为Key取商品的SKU信息
    NSString *storekey = self.skuItems[indexPath.row][@"rid"];
    // 每个商品的sku
    NSArray *skuItems = self.skuItems[indexPath.row][@"sku_items"];

    // 每个店铺的商品的sku
    NSArray *skus = self.skuDict[storekey];
    self.skus = skus;
    // 每个店铺的满减
    NSDictionary *fullReductionDict = self.fullReductionDict[storekey];
   
    THNCouponModel *couponModel = [THNCouponModel mj_objectWithKeyValues:fullReductionDict];
    // 每个店铺优惠券数组
    NSArray *coupons = self.couponDict[storekey];
  
    NSMutableArray *logistics = [NSMutableArray array];
    
    
    for (int i = 0; i < skus.count; i++) {
        NSString *skuKey = self.skuItems[indexPath.row][@"sku_items"][i][@"sku"];
        [logistics addObjectsFromArray:self.logisticsDict[storekey][skuKey][@"express"]];
    }
    
    // 筛选出默认物流
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default = YES"];
    NSArray *defaultLogistics = [logistics filteredArrayUsingPredicate:predicate];
    // 运费
   CGFloat freight  = [self.freightDict[storekey] floatValue];
    THNFreightModelItem *freighModel = [[THNFreightModelItem alloc]initWithDictionary:defaultLogistics[0]];

   self.fullReductionViewHeight =  [cell setPreViewCell:skus initWithItmeSkus:skuItems initWithCouponModel:couponModel initWithFreight:freight initWithCoupons:coupons initWithLogisticsNames:freighModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取不隐藏运费模板的数量
    NSMutableArray *fids = [NSMutableArray array];
    for (NSDictionary *dict in self.skus) {
        [fids addObject:dict[@"fid"]];
    }
    
    NSSet *set = [NSSet setWithArray:fids];
    // 有运费模板商品的高度 + 无运费模板的高度 + 满减View的高度 + 其他的高度
    return set.count * (kProductViewHeight + kLogisticsViewHeight) + (self.skus.count - set.count) * kProductViewHeight + self.fullReductionViewHeight + 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.payDetailView.frame);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.payDetailView.frame))];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    [headerView addSubview:self.logisticsView];
    [headerView addSubview:self.payDetailView];
    NSDictionary *payParams = @{@"freight":@(self.totalFreight),
                                @"coupon_amount":@(0),
                                @"reach_minus":@(self.totalReductionAmount)
                                };
    THNOrderDetailModel *detailModel = [THNOrderDetailModel mj_objectWithKeyValues:payParams];
    CGFloat payDetailViewHeight = [self.payDetailView setOrderDetailPayView:detailModel];
    self.payDetailView.frame = CGRectMake(0, CGRectGetMaxY(self.logisticsView.frame) + 10, SCREEN_WIDTH, payDetailViewHeight);
    
    
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
    }
    return _payDetailView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat originBottom = kDeviceiPhoneX ? 82 : 50;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.progressView.frame) - originBottom)
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(14, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"THNPreViewTableViewCell" bundle:nil] forCellReuseIdentifier:KOrderPreviewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)expressIDArray {
    if (!_expressIDArray) {
        _expressIDArray = [NSMutableArray array];
    }
    return _expressIDArray;
}

@end
