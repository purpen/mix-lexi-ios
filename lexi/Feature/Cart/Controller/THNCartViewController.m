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
#import "THNHeaderTitleView.h"
#import "THNCartFunctionView.h"

#define kTextGoodsCount(count) [NSString stringWithFormat:@"%zi件礼品", count]

static NSString *const kTextEdit = @"编辑";
static NSString *const kTextWish = @"心愿单";
///
static NSString *const kCartNormalGoodsCellId   = @"kCartNormalGoodsCellId";
static NSString *const kCartEditGoodsCellId     = @"kCartEditGoodsCellId";
static NSString *const kCartWishGoodsCellId     = @"kCartWishGoodsCellId";

@interface THNCartViewController () <UITableViewDelegate, UITableViewDataSource>

/// 购物车商品列表
@property (nonatomic, strong) UITableView *cartTableView;
/// 商品数据
@property (nonatomic, strong) NSMutableArray *cartGoodsArr;
/// 心愿单数据
@property (nonatomic, strong) NSMutableArray *wishGoodsArr;
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
        
        [self.cartGoodsArr addObjectsFromArray:goodsData];
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
        
        [self.wishGoodsArr addObjectsFromArray:goodsData];
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
    THNHeaderTitleView *headerView = [[THNHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (self.cartGoodsArr.count || self.wishGoodsArr.count) {
        headerView.title = section == 0 ? kTextGoodsCount(self.goodsCount) : kTextWish;
    }
    
    return headerView;
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
            [wishGoodsCell thn_setGoodsInfoWithModel:self.wishGoodsArr[indexPath.row]];
        }
        
        return wishGoodsCell;
    }
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.functionView];
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
        [SVProgressHUD showInfoWithStatus:@"编辑"];
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
        _functionView.totalPrice = 613.4;
    }
    return _functionView;
}

- (NSMutableArray *)cartGoodsArr {
    if (!_cartGoodsArr) {
        _cartGoodsArr = [NSMutableArray array];
    }
    return _cartGoodsArr;
}

- (NSMutableArray *)wishGoodsArr {
    if (!_wishGoodsArr) {
        _wishGoodsArr = [NSMutableArray array];
    }
    return _wishGoodsArr;
}

@end
