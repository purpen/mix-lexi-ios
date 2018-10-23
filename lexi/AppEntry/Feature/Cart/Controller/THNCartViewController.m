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
#import "THNLoginManager.h"
#import "THNCartDefaultView.h"

#define kTextGoodsCount(count) [NSString stringWithFormat:@"%zi件礼品", count]

static NSString *const kTextEdit = @"编辑";
static NSString *const kTextDone = @"完成";
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
@property (nonatomic, strong) NSMutableArray *cartGoodsArr;
/// 心愿单数据
@property (nonatomic, strong) NSMutableArray *wishGoodsArr;
/// 记录心愿单数据
@property (nonatomic, strong) NSMutableArray *recordWishArr;
/// 商品数量
@property (nonatomic, assign) NSInteger goodsCount;
/// 底部功能栏
@property (nonatomic, strong) THNCartFunctionView *functionView;
/// 缺省视图
@property (nonatomic, strong) THNCartDefaultView *defaultView;
/// 编辑状态
@property (nonatomic, assign) BOOL isCartEdit;
/// 记录选中
@property (nonatomic, strong) NSMutableArray *selectedArr;
/// 购物车商品数量视图
@property (nonatomic, strong) THNHeaderTitleView *countHeaderView;

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
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNGoodsManager getCartGoodsCompletion:^(NSArray *goodsData, NSError *error) {
        if (error) return;
        
        weakSelf.cartGoodsArr = [NSMutableArray arrayWithArray:goodsData];
        [weakSelf thn_getCartGoodsCount];
        [weakSelf thn_setDefaultCartView];
        [SVProgressHUD dismiss];
    }];
}

/**
 心愿单商品
 */
- (void)thn_getWishListGoodsData {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNGoodsManager getUserCenterProductsWithType:(THNUserCenterGoodsTypeWishList)
                                            params:@{@"per_page": @(10)}
                                        completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                            if (error) return;
        
                                            weakSelf.wishGoodsArr = [NSMutableArray arrayWithArray:goodsData];
                                            weakSelf.recordWishArr = [NSMutableArray arrayWithArray:goodsData];
                                            
                                            [weakSelf.cartTableView reloadData];
                                            [SVProgressHUD dismiss];
                                        }];
}

/**
 购物车商品数量
 */
- (void)thn_getCartGoodsCount {
    WEAKSELF;
    
    [THNGoodsManager getCartGoodsCountCompletion:^(NSInteger goodsCount, NSError *error) {
        if (error) return;
        
        weakSelf.goodsCount = goodsCount;
    }];
}

#pragma mark - custom delegate
// 心愿单商品加购物车
- (void)thn_didSelectedAddGoodsToCart:(THNGoodsInfoTableViewCell *)cell {
    NSIndexPath *indexPath = [self.cartTableView indexPathForCell:cell];
    
    if (indexPath.section != 1) return;
    
    THNGoodsModel *model = self.wishGoodsArr[indexPath.row];
    
    WEAKSELF;
    
    [self thn_openGoodsSkuControllerWithGoodsModel:model completed:^(NSString *skuId) {
        [SVProgressHUD thn_showSuccessWithStatus:@"添加成功"];
        [weakSelf thn_getCartGoodsData];
    }];
}

// 选中的商品
- (void)thn_didSelectedEditGoodsCell:(THNGoodsInfoTableViewCell *)cell {
    NSIndexPath *indexPath = [self.cartTableView indexPathForCell:cell];
    
    if ([self.selectedArr containsObject:indexPath]) {
        [self.selectedArr removeObject:indexPath];
        
    } else {
        [self.selectedArr addObject:indexPath];
    }
    
    [self.cartTableView reloadData];
}

// 修改选中的商品数量
- (void)thn_didSelectedEditGoodsCountCell:(THNGoodsInfoTableViewCell *)cell count:(NSInteger)count {
    NSIndexPath *indexPath = [self.cartTableView indexPathForCell:cell];
    THNCartModelItem *item = self.cartGoodsArr[indexPath.row];
    item.quantity = count;
    
    [self thn_setCartGoodsTotalPriceWithData:self.cartGoodsArr];
    
    // 更新购物车商品数量
    [THNGoodsManager putCartGoodsCountWithSkuId:item.rid
                                          count:count
                                     completion:^(NSError *error) {
                                         [self thn_getCartGoodsCount];
                                     }];
}

// 重选商品规格
- (void)thn_didSelectedResetSkuGoodsCell:(THNGoodsInfoTableViewCell *)cell {
    NSIndexPath *indexPath = [self.cartTableView indexPathForCell:cell];
    if (indexPath.section != 0) return;
    
    [self.selectedArr addObject:indexPath];
    
    THNCartModelItem *item = self.cartGoodsArr[indexPath.row];

    WEAKSELF;
    
    [THNGoodsManager getProductInfoWithId:item.product.productRid completion:^(THNGoodsModel *model, NSError *error) {
        if (error) {
            [SVProgressHUD thn_showErrorWithStatus:@"获取商品信息错误"];
            return;
        }
        
        NSArray *skuIds = [self thn_getSelectedDataWithType:(THNSelectedCartDataTypeSku)];
        [weakSelf thn_openGoodsSkuControllerWithGoodsModel:model completed:^(NSString *skuId) {
            // 添加新 sku 成功后，删除记录的 sku
            [weakSelf thn_deleteSkuItemWithSkuIds:skuIds];
        }];
    }];
}

// 结算商品
- (void)thn_didSettleShoppingCartItems {
    [self thn_openAddressSelectedController];
}

// 删除商品
- (void)thn_didRemoveShoppingCartItems {
    NSArray *skuIds = [self thn_getSelectedDataWithType:(THNSelectedCartDataTypeSku)];
    [self thn_deleteSkuItemWithSkuIds:skuIds];
}

// 添加到心愿单
- (void)thn_didShoppingCartItemsToWishlist {
    NSArray *productIds = [[NSSet setWithArray:[self thn_getSelectedDataWithType:(THNSelectedCartDataTypeProduct)]] allObjects];
    if (!productIds.count) return;
    
    WEAKSELF;
    
    [THNGoodsManager postAddGoodsToWishListWithRids:productIds completion:^(NSError *error) {
        if (error) return;
        
        // 从购物车移除
        NSArray *skuIds = [weakSelf thn_getSelectedDataWithType:(THNSelectedCartDataTypeSku)];
        [weakSelf thn_deleteSkuItemWithSkuIds:skuIds];
    }];
}

#pragma mark - private methods
- (void)thn_openAddressSelectedController {
    if (!self.cartGoodsArr.count) {
        return;
    }
    
    THNSelectAddressViewController *selectAddressVC = [[THNSelectAddressViewController alloc] init];
    selectAddressVC.selectedSkuItems = [self thn_getCartGoodsSkuItems];
    selectAddressVC.deliveryCountrys = [self thn_getCartGoodsDeliveryCountrys];
    selectAddressVC.goodsTotalPrice = self.functionView.totalPrice;
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}

// 购物车商品 sku 数据
- (NSArray *)thn_getCartGoodsSkuItems {
    NSMutableArray *cartItems = [NSMutableArray array];
    NSMutableArray *storeIdArr = [NSMutableArray array];
    
    for (THNCartModelItem *item in self.cartGoodsArr) {

        if (item.product.status == 1) {
            NSMutableDictionary *skuItem = [@{kKeySkuId: item.rid,
                                      kKeyQuantity: @(item.quantity)} mutableCopy];
            
            NSMutableDictionary *storeItem = [@{item.product.storeRid: skuItem} mutableCopy];
        
            [cartItems addObject:storeItem];
            [storeIdArr addObject:item.product.storeRid];
        }
    }
    
    return [self thn_getSettleShoppingCartWithItems:[cartItems copy] storeIds:[storeIdArr copy]];
}

// 结算时合并同一家店铺的商品
- (NSArray *)thn_getSettleShoppingCartWithItems:(NSArray *)items storeIds:(NSArray *)storeIds {
    NSArray *sameStoreIds = [[NSSet setWithArray:storeIds] allObjects];
    NSMutableArray *skuItems = [NSMutableArray array];
    
    for (NSString *storeId in sameStoreIds) {
        NSMutableArray *skuItemArr = [NSMutableArray array];
        
        for (NSDictionary *skuDict in [items valueForKey:storeId]) {
            if (![skuDict isKindOfClass:[NSNull class]]) {
                [skuItemArr addObject:skuDict];
            }
        }
        
        [skuItems addObject:[@{kKeyRid: storeId,
                              kKeySkuItems: skuItemArr} mutableCopy]];
    }
    
    return [skuItems copy];
}

// 每件商品的发货国家
- (NSArray *)thn_getCartGoodsDeliveryCountrys {
    NSMutableArray *countrys = [NSMutableArray array];
    
    for (THNCartModelItem *item in self.cartGoodsArr) {
        [countrys addObject:item.product.deliveryCountry];
    }
    
    return [countrys copy];
}

// 购物车商品合计总价
- (void)thn_setCartGoodsTotalPriceWithData:(NSArray *)data {
    CGFloat totalPrice = 0.0;
    
    for (THNCartModelItem *item in data) {
        CGFloat goodsPrice = item.product.salePrice == 0 ? item.product.price : item.product.salePrice;
        totalPrice += item.quantity * goodsPrice;
    }
    
    self.functionView.totalPrice = totalPrice;
}

// 打开商品的 SKU 选择视图
- (void)thn_openGoodsSkuControllerWithGoodsModel:(THNGoodsModel *)goodsModel completed:(void (^)(NSString *skuId))completed {
    if (!goodsModel.rid.length) return;
    
    THNGoodsSkuViewController *goodsSkuVC = [[THNGoodsSkuViewController alloc] initWithGoodsModel:goodsModel];
    goodsSkuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    goodsSkuVC.handleType = THNGoodsButtonTypeAddCart;
    goodsSkuVC.selectGoodsAddCartCompleted = completed;
    [self presentViewController:goodsSkuVC animated:NO completion:nil];
}

// 默认购物车商品视图
- (void)thn_setDefaultCartView {
    // 编辑按钮
    if (self.isCartEdit) {
        [self thn_showEditButtonWithText:kTextDone];
        
    } else {
        [self thn_showEditButtonWithText:self.cartGoodsArr.count ? kTextEdit : @""];
    }
    
    // 缺省视图
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.cartTableView.tableHeaderView = self.cartGoodsArr.count ? tableHeader : self.defaultView;
    
    // 结算视图
    [self thn_setCartGoodsTotalPriceWithData:[self.cartGoodsArr copy]];
    self.functionView.hidden = self.cartGoodsArr.count ? NO : YES;
    
    [self.cartTableView reloadData];
}

// 开始编辑购物车商品
- (void)thn_startEditCartGoods:(BOOL)start {
    self.isCartEdit = start;
    self.functionView.status = start ? THNCartFunctionStatusEdit : THNCartFunctionStatusDefault;
    [self.selectedArr removeAllObjects];
    
    if (start) {
        [self.wishGoodsArr removeAllObjects];
        [self thn_showEditButtonWithText:kTextDone];
        
    } else {
        [self thn_getWishListGoodsData];
//        [self.wishGoodsArr addObjectsFromArray:[self.recordWishArr copy]];
        [self thn_showEditButtonWithText:self.cartGoodsArr.count ? kTextEdit : @""];
    }
    
    [self.cartTableView reloadData];
}

// 删除所选商品
- (void)thn_deleteSkuItemWithSkuIds:(NSArray *)skuIds {
    if (!skuIds.count) return;

    WEAKSELF;
    
    [THNGoodsManager postRemoveCartGoodsWithSkuRids:skuIds completion:^(NSError *error) {
        if (error) {
            [SVProgressHUD thn_showErrorWithStatus:@"删除失败"];
            return;
        };
        
        [weakSelf thn_removeCartGoods];
    }];
}

// 从购物车中移除所选商品
- (void)thn_removeCartGoods {
    NSMutableArray *selectedItems = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.selectedArr) {
        THNCartModelItem *item = self.cartGoodsArr[indexPath.row];
        [selectedItems addObject:item];
    }
    
    [self.cartGoodsArr removeObjectsInArray:[selectedItems copy]];
    [self.selectedArr removeAllObjects];
    [self thn_getCartGoodsData];
    
    if (!self.cartGoodsArr.count) {
        // 商品删除完，结束编辑状态
        [self thn_startEditCartGoods:NO];
    }
}

// 清除数据
- (void)thn_clearData {
    [self.cartGoodsArr removeAllObjects];
    [self.wishGoodsArr removeAllObjects];
    [self.recordWishArr removeAllObjects];
    [self.selectedArr removeAllObjects];
    
    [self thn_setDefaultCartView];
}

// 返回
- (void)thn_defaultCartBack {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
        self.navigationController.tabBarController.selectedIndex = 0;
    }
}

// 获取选中的数据
- (NSArray *)thn_getSelectedDataWithType:(THNSelectedCartDataType)type {
    NSMutableArray *selectedArr = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.selectedArr) {
        THNCartModelItem *item = self.cartGoodsArr[indexPath.row];
        switch (type) {
            case THNSelectedCartDataTypeItem:
                [selectedArr addObject:item];
                break;
                
            case THNSelectedCartDataTypeSku:
                [selectedArr addObject:item.rid];
                break;
                
            case THNSelectedCartDataTypeProduct:
                [selectedArr addObject:item.product.productRid];
                break;
        }
    }
    
    return [selectedArr copy];
}

// 购物车商品数量
- (void)setGoodsCount:(NSInteger)goodsCount {
    _goodsCount = goodsCount;
    
    self.countHeaderView.title = kTextGoodsCount(goodsCount);
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
    if (section == 0) {
        return self.cartGoodsArr.count ? 44.0 : 0.01;
        
    } else {
        return self.wishGoodsArr.count ? 44.0 : 0.01;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.cartGoodsArr.count ? self.countHeaderView : [UIView new];
        
    } else {
        THNHeaderTitleView *headerView = [[THNHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerView.title = kTextWish;
        
        return self.wishGoodsArr.count ? headerView : [UIView new];
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
        THNGoodsInfoTableViewCell *cartGoodsCell = [[THNGoodsInfoTableViewCell alloc] init];
    
        if (self.isCartEdit) {
            cartGoodsCell = [THNGoodsInfoTableViewCell initGoodsInfoCellWithTableView:tableView
                                                                                 type:(THNGoodsInfoCellTypeCartEdit)
                                                                      reuseIdentifier:kCartEditGoodsCellId];
        } else {
            cartGoodsCell = [THNGoodsInfoTableViewCell initGoodsInfoCellWithTableView:tableView
                                                                                 type:(THNGoodsInfoCellTypeCartNormal)
                                                                      reuseIdentifier:kCartNormalGoodsCellId];
        }
        
        cartGoodsCell.delegate = self;
        
        if (self.cartGoodsArr.count) {
            [cartGoodsCell thn_setCartGoodsInfoWithModel:self.cartGoodsArr[indexPath.row]];
        }
        
        if (self.selectedArr.count) {
            cartGoodsCell.isSelected = [self.selectedArr containsObject:indexPath];
        } else {
            cartGoodsCell.isSelected = NO;
        }
        
        if (indexPath.row == self.cartGoodsArr.count - 1) {
            cartGoodsCell.showLine = NO;
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
        
        if (indexPath.row == self.wishGoodsArr.count - 1) {
            wishGoodsCell.showLine = NO;
        }
        
        return wishGoodsCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCartEdit) return;
    
    NSString *goodsId = nil;
    
    if (indexPath.section == 0) {
        THNCartModelItem *item = self.cartGoodsArr[indexPath.row];
        goodsId = item.product.productRid;
        
    } else {
        THNGoodsModel *goodsModel = self.wishGoodsArr[indexPath.row];
        goodsId = goodsModel.rid;
    }
    
    if (!goodsId.length) return;
    
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:goodsId];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.functionView];
    
    [self thn_setDefaultCartView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    
    if ([THNLoginManager isLogin]) {
        [self thn_getCartGoodsData];
        [self thn_getWishListGoodsData];
        
    } else {
        [self thn_clearData];
    }
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCart;

    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf thn_startEditCartGoods:!self.isCartEdit];
    }];
}

- (void)thn_showEditButtonWithText:(NSString *)text {
    [self.navigationBarView setNavigationRightButtonOfText:text textHexColor:kColorMain fontSize:15];
}

#pragma mark - getters and setters
- (CGFloat)thn_originBottom {
    CGFloat tabbarH = self.tabBarController.tabBar.frame.size.height;
    CGFloat originBottom = self.navigationController.viewControllers.count == 1 ? tabbarH : 32.0;
    
    return originBottom;
}

- (UITableView *)cartTableView {
    if (!_cartTableView) {
        _cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [self thn_originBottom])
                                                      style:(UITableViewStylePlain)];
        _cartTableView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cartTableView.delegate = self;
        _cartTableView.dataSource = self;
        _cartTableView.showsVerticalScrollIndicator = NO;
        _cartTableView.contentInset = UIEdgeInsetsMake(44, 0, 50, 0);
        _cartTableView.tableFooterView = [UIView new];
    }
    return _cartTableView;
}

- (THNCartFunctionView *)functionView {
    if (!_functionView) {
        _functionView = [[THNCartFunctionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cartTableView.frame) - 50, SCREEN_WIDTH, 50)];
        _functionView.delegate = self;
        _functionView.status = THNCartFunctionStatusDefault;
    }
    return _functionView;
}

- (THNCartDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[THNCartDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 295)];
        
        WEAKSELF;
        
        _defaultView.cartDefaultDiscoverBlock = ^{
            [weakSelf thn_defaultCartBack];
        };
    }
    return _defaultView;
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

- (THNHeaderTitleView *)countHeaderView {
    if (!_countHeaderView) {
        _countHeaderView = [[THNHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }
    return _countHeaderView;
}

@end
