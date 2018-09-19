//
//  THNCartViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCartViewController.h"
#import "THNGoodsManager.h"
#import "THNGoodsInfoTableViewCell.h"
#import "THNGoodsInfoViewController.h"
#import "THNHeaderTitleView.h"
#import "THNCartFunctionView.h"
#import "THNGoodsSkuViewController.h"
#import "THNSelectAddressViewController.h"

#define kTextGoodsCount(count) [NSString stringWithFormat:@"%zi件礼品", count]

static NSString *const kTextEdit = @"编辑";
static NSString *const kTextWish = @"心愿单";
///
static NSString *const kCartNormalGoodsCellId   = @"kCartNormalGoodsCellId";
static NSString *const kCartEditGoodsCellId     = @"kCartEditGoodsCellId";
static NSString *const kCartWishGoodsCellId     = @"kCartWishGoodsCellId";
/// 自定义的 key
static NSString *const kKeyItems    = @"items";
static NSString *const kKeyRid      = @"rid";
static NSString *const kKeySkuItems = @"sku_items";
static NSString *const kKeySkuId    = @"sku";
static NSString *const kKeyQuantity = @"quantity";

@interface THNCartViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNGoodsInfoTableViewCellDelegate,
    THNCartFunctionViewDelegate>

/// 购物车商品列表
@property (nonatomic, strong) UITableView *cartTableView;
/// 商品数据
@property (nonatomic, strong) NSArray *cartGoodsArr;
/// 心愿单数据
@property (nonatomic, strong) NSArray *wishGoodsArr;
/// 商品数量
@property (nonatomic, assign) NSInteger goodsCount;
/// 底部功能栏
@property (nonatomic, strong) THNCartFunctionView *functionView;

@end

@implementation THNCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
/**
 购物车商品
 */
- (void)thn_getCartGoodsData {
    [SVProgressHUD show];
    [THNGoodsManager getCartGoodsCompletion:^(NSArray *goodsData, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        self.cartGoodsArr = [NSArray arrayWithArray:goodsData];
        [self thn_setCartGoodsTotalPriceWithData:goodsData];
        [self thn_showEditButton];
        [self.cartTableView reloadData];
    }];
}

/**
 心愿单商品
 */
- (void)thn_getWishListGoodsData {
    [THNGoodsManager getUserCenterProductsWithType:(THNUserCenterGoodsTypeWishList) params:@{} completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        self.wishGoodsArr = [NSArray arrayWithArray:goodsData];
        [self.cartTableView reloadData];
    }];
}

/**
 购物车商品数量
 */
- (void)thn_getCartGoodsCount {
    [THNGoodsManager getCartGoodsCountCompletion:^(NSInteger goodsCount, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        self.goodsCount = goodsCount;
    }];
}

#pragma mark - custom delegate
- (void)thn_didSelectedAddGoodsToCart:(THNGoodsInfoTableViewCell *)cell {
    NSIndexPath *indexPath = [self.cartTableView indexPathForCell:cell];
    if (indexPath.section == 1) {
        THNGoodsModel *model = self.wishGoodsArr[indexPath.row];
        [self thn_openGoodsSkuControllerWithGoodsModel:model];
    }
}

- (void)thn_didSettleShoppingCartItems {
    [self thn_openAddressSelectedController];
}

#pragma mark - private methods
- (void)thn_openAddressSelectedController {
    if (!self.cartGoodsArr.count) {
        return;
    }
    
    THNSelectAddressViewController *selectAddressVC = [[THNSelectAddressViewController alloc] init];
    selectAddressVC.selectedSkuItems = [self thn_getCartGoodsSkuItems];
    selectAddressVC.deliveryCountrys = [self thn_getCartGoodsDeliveryCountrys];
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}

// 购物车商品 sku 数据
- (NSArray *)thn_getCartGoodsSkuItems {
    NSMutableArray *cartItems = [NSMutableArray array];
    
    for (THNCartModelItem *item in self.cartGoodsArr) {
        if (item.product.status == 1) {
            NSDictionary *skuItem = @{kKeySkuId: item.rid,
                                      kKeyQuantity: @(item.quantity)};
            
            NSDictionary *storeItem = @{kKeyRid: item.product.storeRid,
                                        kKeySkuItems: @[skuItem]};
            
            [cartItems addObject:storeItem];
        }
    }
    
    return [self thn_getSettleShoppingCartWithItems:[cartItems copy]];
}

// 结算时合并同一家店铺的商品
- (NSArray *)thn_getSettleShoppingCartWithItems:(NSArray *)items {
    NSMutableArray *itemArr = [NSMutableArray array];
    
    for (NSDictionary *itemDict in items) {
        
    }
    
    return [itemArr copy];
}

// 每件商品的发货国家
- (NSArray *)thn_getCartGoodsDeliveryCountrys {
    NSMutableArray *countrys = [NSMutableArray array];
    
    for (THNCartModelItem *item in self.cartGoodsArr) {
        [countrys addObject:item.product.deliveryCountry];
    }
    
    return [countrys copy];
}

- (void)thn_setCartGoodsTotalPriceWithData:(NSArray *)data {
    CGFloat totalPrice = 0.0;
    
    for (THNCartModelItem *item in data) {
        CGFloat goodsPrice = item.product.salePrice == 0 ? item.product.price : item.product.salePrice;
        totalPrice += item.quantity * goodsPrice;
    }
    
    self.functionView.totalPrice = totalPrice;
    [self.view addSubview:self.functionView];
}

- (void)thn_openGoodsSkuControllerWithGoodsModel:(THNGoodsModel *)goodsModel {
    if (!goodsModel.rid.length) return;
    
    THNGoodsSkuViewController *goodsSkuVC = [[THNGoodsSkuViewController alloc] initWithGoodsModel:goodsModel];
    goodsSkuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    goodsSkuVC.handleType = THNGoodsButtonTypeAddCart;
    [self presentViewController:goodsSkuVC animated:NO completion:nil];
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.cartGoodsArr.count : self.wishGoodsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.cartGoodsArr.count || self.wishGoodsArr.count) {
        THNHeaderTitleView *headerView = [[THNHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerView.title = section == 0 ? kTextGoodsCount(self.goodsCount) : kTextWish;
        
        return headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNGoodsInfoTableViewCell *cartGoodsCell = [THNGoodsInfoTableViewCell initGoodsInfoCellWithTableView:tableView
                                                                                                        type:(THNGoodsInfoCellTypeCartNormal)
                                                                                             reuseIdentifier:kCartNormalGoodsCellId];
        if (self.cartGoodsArr.count) {
            [cartGoodsCell thn_setCartGoodsInfoWithModel:self.cartGoodsArr[indexPath.row]];
        }
        
        return cartGoodsCell;
        
    } else {
        THNGoodsInfoTableViewCell *wishGoodsCell = [THNGoodsInfoTableViewCell initGoodsInfoCellWithTableView:tableView
                                                                                                        type:(THNGoodsInfoCellTypeCartWish)
                                                                                             reuseIdentifier:kCartWishGoodsCellId];
        
        if (self.wishGoodsArr.count) {
            wishGoodsCell.delegate = self;
            [wishGoodsCell thn_setGoodsInfoWithModel:self.wishGoodsArr[indexPath.row]];
        }
        
        return wishGoodsCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *goodsId = nil;
    
    if (indexPath.section == 0) {
        THNCartModelItem *item = self.cartGoodsArr[indexPath.row];
        goodsId = item.product.productRid;
        
    } else {
        THNGoodsModel *goodsModel = self.wishGoodsArr[indexPath.row];
        goodsId = goodsModel.rid;
    }
    
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:goodsId];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.cartTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self thn_getCartGoodsData];
    [self thn_getWishListGoodsData];
    [self thn_getCartGoodsCount];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCart;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [SVProgressHUD showInfoWithStatus:kTextEdit];
    }];
}

- (void)thn_showEditButton {
    NSString *editText = self.cartGoodsArr.count ? kTextEdit : @"";
    
    [self.navigationBarView setNavigationRightButtonOfText:editText textHexColor:kColorMain fontSize:15];
}

#pragma mark - getters and setters
- (UITableView *)cartTableView {
    if (!_cartTableView) {
        CGFloat originBottom = kDeviceiPhoneX ? 133 : 99;
        _cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - originBottom)
                                                      style:(UITableViewStyleGrouped)];
        _cartTableView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cartTableView.delegate = self;
        _cartTableView.dataSource = self;
        _cartTableView.showsVerticalScrollIndicator = NO;
        _cartTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _cartTableView.tableFooterView = [UIView new];
    }
    return _cartTableView;
}

- (THNCartFunctionView *)functionView {
    if (!_functionView) {
        _functionView = [[THNCartFunctionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cartTableView.frame), SCREEN_WIDTH, 50)];
        _functionView.delegate = self;
    }
    return _functionView;
}

@end
