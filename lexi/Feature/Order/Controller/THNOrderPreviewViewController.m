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
#import "THNSelectOfficalCouponView.h"
#import "UIViewController+THNHud.h"
#import "THNWxPayModel.h"
#import <WXApi.h>

static NSString *kTitleDone = @"提交订单";
static NSString *const KOrderPreviewCellIdentifier = @"KOrderPreviewCellIdentifier";
static NSString *const kUrlCreateOrder = @"/orders/create";
static NSString *const kUrlProductStoreSkus = @"/products/by_store_sku";
static NSString *const kUrlOrderCoupons = @"/market/user_order_coupons";
static NSString *const kUrlOrderFullReduction = @"/market/user_order_full_reduction";
static NSString *const kUrlLogisticsFreight = @"/logistics/freight/calculate";
static NSString *const kUrlLogisticsProductExpress = @"/logistics/product/express";
static NSString *const kUrlNewUserDiscount = @"/market/coupons/new_user_discount";
static NSString *const kUrlOfficialFill = @"/market/user_official_fill";

@interface THNOrderPreviewViewController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    THNPreViewTableViewCellDelegate,
    WXApiDelegate
>

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
// 底部选择官方优惠券
@property (nonatomic, strong) THNSelectOfficalCouponView *selectOfficalCouponView;
@property (nonatomic, strong) NSArray *skus;
@property (nonatomic, strong) UITableView *tableView;
// sku
@property (nonatomic, strong) NSDictionary *skuDict;
// 物流
@property (nonatomic, strong) NSMutableDictionary *logisticsDict;
// 满减
@property (nonatomic, strong) NSDictionary *fullReductionDict;
// 物流公司ID
@property (nonatomic, strong) NSMutableArray *expressIDArray;
// 运费
@property (nonatomic, strong) NSDictionary *freightDict;
// 优惠券
@property (nonatomic, strong) NSDictionary *couponDict;
//官方优惠券
@property (nonatomic, strong) NSArray *officalCoupons;
// 满减View的高度
@property (nonatomic, assign) CGFloat fullReductionViewHeight;
// 总运费
@property (nonatomic, assign) CGFloat totalFreight;
// 总优惠券
@property (nonatomic, assign) CGFloat totalCouponAmount;
// 总满减金额
@property (nonatomic, assign) CGFloat totalReductionAmount;
// 首单优惠折扣
@property (nonatomic, assign) CGFloat discountRatio;
// 首单优惠金额
@property (nonatomic, assign) CGFloat firstDiscount;
// 支付金额
@property (nonatomic, assign) CGFloat payAmount;
// 官方红包优惠券码
@property (nonatomic, strong) NSString *officalCouponCode;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CGFloat payDetailViewHeight;

@end

@implementation THNOrderPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self showHud];
    
    dispatch_group_async(group, queue, ^{
        [self loadProductStoreSkuData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadOrderCoupons];
    });
    dispatch_group_async(group, queue, ^{
        [self loadOrderFullReduction];
    });
    dispatch_group_async(group, queue, ^{
        [self loadNewUserDiscountData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadOfficialCouponData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadLogisticsProductExpressData];
    });
    
    
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenHud];
            [self.tableView reloadData];
        });
    });
}


#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    [self createOrder];
}

// 创建订单
- (void)createOrder {
    self.isTransparent = YES;
    [self showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *items = [NSMutableArray array];

    // 取出字典的storeRid,重新命名key
    for (NSDictionary *dict in self.skuItems) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        NSString *storeRid = dict[@"rid"];
        itemDict[@"store_rid"] = storeRid;
        itemDict[@"coupon_codes"] = dict[@"coupon_codes"];
        itemDict[@"blessing_utterance"] = dict[@"blessing_utterance"];
        itemDict[@"buyer_remark"] = dict[@"buyer_remark"];
        
        for (NSMutableDictionary *skuItemDict in dict[@"sku_items"]) {
            skuItemDict[@"rid"] = skuItemDict[@"sku"];
            [skuItemDict removeObjectForKey:@"sku"];
        }
        
        itemDict[@"items"] = dict[@"sku_items"];
        [items addObject:itemDict];
    }

    // 组合成后台对应的格式
    params[@"address_rid"] = self.addressModel.rid;
    params[@"bonus_code"] =  self.officalCouponCode;
    params[@"store_items"] = items;
    // 来源客户端，1、小程序；2、H5 3、App 4、TV 5、POS 6、PAD
    params[@"from_client"] = @(3);
    // 是否同步返回支付参数 0、否 1、是
    params[@"sync_pay"] = @(1);
    THNRequest *request = [THNAPI postWithUrlString:kUrlCreateOrder requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        THNWxPayModel *payModel = [THNWxPayModel mj_objectWithKeyValues:result.data[@"pay_params"]];
        THNPaymentViewController *paymentVC = [[THNPaymentViewController alloc] init];
        paymentVC.totalPrice = self.totalPrice;
        paymentVC.paymentAmount = self.payAmount;
        paymentVC.totalFreight = self.totalFreight;
        paymentVC.payModel = payModel;

        [self.navigationController pushViewController:paymentVC animated:YES];
        
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
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
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.skuDict = result.data;
        
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 用户获取当前订单的符合条件的优惠券信息
- (void)loadOrderCoupons {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrderCoupons requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.couponDict = result.data;

        for (NSMutableDictionary *dict in self.skuItems) {
            NSMutableArray *coupons = [NSMutableArray array];
            for (NSDictionary *storeDict in self.couponDict[dict[@"rid"]]) {
                [coupons addObject:storeDict[@"coupon"]];
            }

            if (coupons.count > 0) {
                dict[@"coupon_codes"] = coupons[0][@"code"];
                self.totalCouponAmount += [coupons[0][@"amount"] floatValue];
            }
        }

    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 官方优惠券
- (void)loadOfficialCouponData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *skus = [NSMutableArray array];
    
    for (NSDictionary *skuDict in self.skuItems) {
        [mutableArray addObjectsFromArray:skuDict[@"sku_items"]];
    }
    
    for (NSDictionary *dict in mutableArray) {
        [skus addObject:dict[@"sku"]];
    }
    
    params[@"sku"] = skus;
    params[@"amount"] = @(self.totalPrice);
    THNRequest *request = [THNAPI postWithUrlString:kUrlOfficialFill requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO]];
        self.officalCoupons = [result.data[@"coupons"] sortedArrayUsingDescriptors:sortArr];

        if (self.officalCoupons.count > 0) {
            self.totalCouponAmount += [self.officalCoupons[0][@"amount"] floatValue];
            self.officalCouponCode = self.officalCoupons[0][@"code"];
        }

    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 用户获取当前订单的符合条件的满减信息
- (void)loadOrderFullReduction {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrderFullReduction requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.fullReductionDict = result.data;
        
        for (NSDictionary *dict in self.skuItems) {
            NSDictionary *fullReductionDict = self.fullReductionDict[dict[@"rid"]];
            THNCouponModel *couponModel = [THNCouponModel mj_objectWithKeyValues:fullReductionDict];
            self.totalReductionAmount += couponModel.amount;
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 获取每件商品的物流公司列表
- (void)loadLogisticsProductExpressData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogisticsProductExpress requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
    
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            dispatch_semaphore_signal(self.semaphore);
            return;
        }
    
        self.logisticsDict = [result.data mutableCopy];
        [self loadLogisticsFreightData];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    }];
}

// 计算运费
- (void)loadLogisticsFreightData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self changeExpress];
    params[@"address_rid"] = self.addressModel.rid;
    params[@"items"] = self.skuItems;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogisticsFreight requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.totalFreight = 0;
        self.freightDict = result.data;
        // 遍历所有总运费
        for (NSDictionary *dict in self.skuItems) {
            CGFloat freight  = [self.freightDict[dict[@"rid"]] floatValue];
            self.totalFreight += freight;
        }
        
        [self.tableView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 新用户折扣
- (void)loadNewUserDiscountData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    THNRequest *request = [THNAPI getWithUrlString:kUrlNewUserDiscount requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.discountRatio = [result.data[@"discount_ratio"]floatValue];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 改变物流
- (void)changeExpress {
    // 添加或改变默认物流ID
    for (NSMutableDictionary *skuDict in self.skuItems) {
        NSDictionary *logisticsDict = self.logisticsDict[skuDict[@"rid"]];
        for (NSMutableDictionary *goodsDict in [skuDict[@"sku_items"]mutableCopy]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default = YES"];
            NSArray *expressArray = [logisticsDict[goodsDict[@"sku"]][@"express"] filteredArrayUsingPredicate:predicate];
            NSString *logId = expressArray[0][@"express_id"];
            [goodsDict setObject:logId forKey:@"express_id"];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return self.skuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNPreViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [THNPreViewTableViewCell viewFromXib];
    }
    cell.delagate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    // 店铺id作为Key取商品的SKU信息
    NSString *storekey = self.skuItems[indexPath.row][@"rid"];
    NSString *remarkStr = self.skuItems[indexPath.row][@"buyer_remark"];
    NSString *giftStr = self.skuItems[indexPath.row][@"blessing_utterance"];
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

    // 运费
    CGFloat freight  = [self.freightDict[storekey] floatValue];

    NSMutableArray *products = [NSMutableArray array];
    for (int i = 0; i < skus.count; i++) {
        [products addObject:self.logisticsDict[storekey]];
    }

    self.fullReductionViewHeight = [cell setPreViewCell:skus
                                       initWithItmeSkus:skuItems
                                     initWithCouponModel:couponModel
                                         initWithFreight:freight
                                         initWithCoupons:coupons
                                       initWithproducts:products
                                          initWithRemark:remarkStr
                                            initWithGift:giftStr];
    
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
    return set.count * (kProductViewHeight + kLogisticsViewHeight) + (self.skus.count - set.count) * kProductViewHeight + self.fullReductionViewHeight + 290;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //  实际支付金额 = 订单总金额 + 运费 - 首单优惠 - 满减 - 优惠券/红包
    self.payAmount = self.totalPrice + self.totalFreight - self.totalReductionAmount - self.firstDiscount - self.totalCouponAmount;
    
    if (self.discountRatio > 0) {
        self.firstDiscount = (self.totalFreight + self.totalReductionAmount + self.totalPrice) * (1 - self.discountRatio);
    }
    
    NSDictionary *payParams = @{@"freight":@(self.totalFreight),
                                @"coupon_amount":@(self.totalCouponAmount),
                                @"reach_minus":@(self.totalReductionAmount),
                                @"total_amount":@(self.totalPrice),
                                @"first_discount":@(self.firstDiscount),
                                @"user_pay_amount":@(self.payAmount)
                                };
    
    THNOrderDetailModel *detailModel = [THNOrderDetailModel mj_objectWithKeyValues:payParams];
    self.payDetailViewHeight = [self.payDetailView setOrderDetailPayView:detailModel];
    
    return CGRectGetMaxY(self.logisticsView.frame) + 10 + self.payDetailViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,CGRectGetMaxY(self.logisticsView.frame) + 10 + self.payDetailViewHeight)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    [headerView addSubview:self.logisticsView];
    [headerView addSubview:self.payDetailView];
    self.payDetailView.frame = CGRectMake(0, CGRectGetMaxY(self.logisticsView.frame) + 10, SCREEN_WIDTH,  self.payDetailViewHeight);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.selectOfficalCouponView.officalCoupons = self.officalCoupons;
    __weak typeof(self)weakSelf = self;

    self.selectOfficalCouponView.updateCouponAcountBlcok = ^(CGFloat couponSpread, NSString *code) {
        weakSelf.officalCouponCode = code;
        weakSelf.totalCouponAmount += couponSpread;
        [weakSelf.payDetailView setTotalCouponAmount:weakSelf.totalCouponAmount];

    };

    return self.selectOfficalCouponView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

#pragma mark - THNPreViewTableViewCellDelegate

/**
 选择物流方式

 @param skuIds 相同运费的商品信息
 @param fid 运费模板ID
 @param storeIndex 选中的商品对应所在行数
 */
- (void)selectLogistic:(NSMutableArray *)skuIds
               WithFid:(NSString *)fid
        withStoreIndex:(NSInteger)storeIndex {

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

    THNSelectLogisticsViewController *selectLogistcisVC = [[THNSelectLogisticsViewController alloc] initWithGoodsData:goods logisticsData:expressParams];

    // 选择物流配送方式完成回调
    selectLogistcisVC.didSelectedExpressItem = ^(THNFreightModelItem *expressModel) {

        NSMutableDictionary *productDict = [self.logisticsDict[storeKey] mutableCopy];
        for ( NSMutableDictionary *skuitemDict in items) {
            NSString *skuKey = skuitemDict[@"sku"];
            NSMutableDictionary *skuDict = [productDict[skuKey] mutableCopy];
            NSMutableArray *expressArray = [NSMutableArray array];
            for (NSMutableDictionary *expressDict in self.logisticsDict[storeKey][skuKey][@"express"]) {
                NSMutableDictionary *newExpressDict = [NSMutableDictionary dictionaryWithDictionary:expressDict];
                // 选中的物流替换成默认物流
                if (expressModel.expressId == [expressDict[@"express_id"]integerValue]) {
                    newExpressDict[@"is_default"] = @(1);
                } else {
                    newExpressDict[@"is_default"] = @(0);
                }

                // 替换后的物流用该数组保存
                [expressArray addObject:newExpressDict];

            }

            // 物流数组用express 作为key
            skuDict[@"express"] = expressArray;
            // 以店铺id作为key
            productDict[skuKey] = skuDict;
        }

        // 替换为重新组合的值
        self.logisticsDict[storeKey] = productDict;
        // 重新计算更改默认物流后的运费
        [self loadLogisticsFreightData];
    };

    [self.navigationController pushViewController:selectLogistcisVC animated:YES];
}


/**
 更新优惠券的信息

 @param couponSpread 本次选择优惠券和上次选中优惠券的差价
 @param code 选中的优惠券码
 @param tag 选中cell的tag
 */
- (void)updateTotalCouponAcount:(CGFloat)couponSpread withCode:(NSString *)code withTag:(NSInteger)tag {
    // 优惠券码插入到对应的店铺
    NSMutableDictionary *skuItemDict = self.skuItems[tag];
    skuItemDict[@"coupon_codes"] = code;
    self.totalCouponAmount += couponSpread;
    [self.payDetailView setTotalCouponAmount:self.totalCouponAmount];
}

- (void)setRemarkWithGift:(NSString *)remarkStr withGift:(NSString *)giftStr withTag:(NSInteger)tag {
    // 备注和赠语插入到对应的店铺
    NSMutableDictionary *skuItemDict = self.skuItems[tag];
    skuItemDict[@"buyer_remark"] = remarkStr;
    skuItemDict[@"blessing_utterance"] = giftStr;
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

- (THNSelectOfficalCouponView *)selectOfficalCouponView {
    if (!_selectOfficalCouponView) {
        _selectOfficalCouponView = [THNSelectOfficalCouponView viewFromXib];
        _selectOfficalCouponView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }
    return _selectOfficalCouponView;
}

@end
