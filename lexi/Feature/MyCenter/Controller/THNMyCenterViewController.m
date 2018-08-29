//
//  THNMyCenterViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNMyCenterViewController.h"
#import "THNShareViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNMyCenterHeaderView.h"
#import "THNTableViewFooterView.h"
#import "THNLikedGoodsTableViewCell.h"
#import "THNLikedWindowTableViewCell.h"
#import "THNFollowStoreTableViewCell.h"
#import "THNLikedWindowViewController.h"
#import "THNApplyStoreViewController.h"
#import "THNDynamicTableViewController.h"
#import "THNGoodsListViewController.h"
#import "THNUserManager.h"
#import "THNGoodsManager.h"
#import "THNLoginManager.h"

/// seciton header 默认的标题
static NSString *const kHeaderTitleLiked    = @"喜欢的商品";
static NSString *const kHeaderTitleWindow   = @"喜欢的橱窗";
static NSString *const kHeaderTitleBrowses  = @"最近查看";
static NSString *const kHeaderTitleWishList = @"心愿单";
/// cell 的高度
static CGFloat const kCellHeightGoods       = 100.0;
static CGFloat const kCellHeightWindow      = 162.0;
static CGFloat const kCellHeightStore       = 72.0;
static CGFloat const kSectionFooterHeight   = 11.0;
/// 商品数量低于最小值不显示“查看全部”
static NSInteger const kMinGoodsCount       = 2;
/// 单元格
static NSString *const kLikedGodsTableViewCellId    = @"LikedGodsTableViewCellId";
static NSString *const kBrowsesGodsTableViewCellId  = @"BrowsesGodsTableViewCellId";
static NSString *const kWishListGodsTableViewCellId = @"WishListGodsTableViewCellId";
static NSString *const kStoreGodsTableViewCellId    = @"StoreGodsTableViewCellId";

@interface THNMyCenterViewController () <THNNavigationBarViewDelegate, THNMyCenterHeaderViewDelegate> {
    THNHeaderViewSelectedType _selectedDataType;
}

/// 用户昵称
@property (nonatomic, strong) NSString *userName;
/// 顶部视图：用户信息
@property (nonatomic, strong) THNMyCenterHeaderView *headerView;
/// 底部视图：数据缺省
@property (nonatomic, strong) THNTableViewFooterView *footerView;

@end

@implementation THNMyCenterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.separatorStyle = THNTableViewCellSeparatorStyleNone;
    _selectedDataType = THNHeaderViewSelectedTypeLiked;
    
    [self thn_setUserHeaderView];
    [self thn_changTableViewDataSourceWithType:_selectedDataType];
}

// 头部用户信息
- (void)thn_setUserHeaderView {
    [THNUserManager getUserCenterCompletion:^(THNUserModel *model, NSError *error) {
        if (error) return;
        
        self.userName = model.username;
        [self.headerView thn_setUserInfoModel:model];
        self.tableView.tableHeaderView = self.headerView;
    }];
}

// 商品信息
- (void)thn_setGoodsTableViewCellWithType:(THNUserCenterGoodsType)type {
    NSArray *titleArr = @[kHeaderTitleLiked, kHeaderTitleBrowses, kHeaderTitleWishList];
    NSString *headerTitle = titleArr[(NSInteger)type];
    
    [THNGoodsManager getUserCenterProductsWithType:type params:@{} completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error) return;
        
        THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedGoods)
                                                                 cellHeight:kCellHeightGoods
                                                            didSelectedItem:^(NSString *ids) {
                                                                [SVProgressHUD showInfoWithStatus: \
                                                                 [NSString stringWithFormat:@"商品ID == %@", ids]];
                                                            }];
        goodsCells.goodsDataArr = goodsData;
        
        THNTableViewSections *sections = nil;
        if (goodsData.count <= kMinGoodsCount) {    // 不显示“查看全部”按钮
            sections = [THNTableViewSections initSectionsWithHeaderTitle:headerTitle];
            
        } else {
            sections = [THNTableViewSections initSectionsWithHeaderTitle:headerTitle moreCompletion:^{
                THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] \
                                                           initWithUserCenterGoodsType:type title:headerTitle];
                [self.navigationController pushViewController:goodsListVC animated:YES];
            }];
        }
        sections.index = (NSInteger)type;
        sections.dataCells = [@[goodsCells] mutableCopy];
        
        if (goodsData.count) {
            [self.dataSections addObject:sections];
            [self thn_sortDataSecitons];
        }
        
        if (type == THNUserCenterGoodsTypeLikedGoods) {
            [self thn_setLikedWindowTableViewCell];
        }
        
        [self thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedTypeCollect)];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }];
}

// 喜欢的橱窗
- (void)thn_setLikedWindowTableViewCell {
    [THNUserManager getUserLikedWindowWithParams:@{} completion:^(NSArray *windowData, NSError *error) {
        if (error) return;
        
        THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedWindow) didSelectedItem:^(NSString *ids) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"橱窗ID == %@", ids]];
        }];
        cells.height = kCellHeightWindow;
        cells.windowDataArr = windowData;
        
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleWindow moreCompletion:^{
            THNLikedWindowViewController *likedWindowVC = [[THNLikedWindowViewController alloc] init];
            [self.navigationController pushViewController:likedWindowVC animated:YES];
        }];
        sections.index = 1;
        sections.dataCells = [@[cells] mutableCopy];
        
        if (windowData.count) {
            [self.dataSections addObject:sections];
            [self thn_sortDataSecitons];
        }
        
        [self thn_setTableViewFooterViewWithType:THNHeaderViewSelectedTypeLiked];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }];
}

// 关注的设计馆
- (void)thn_setFollowStoreTableViewCell {
    [THNUserManager getUserFollowStoreWithParams:@{} completion:^(NSArray *storesData, NSError *error) {
        if (error) return;
        
        for (NSDictionary *storeDict in storesData) {
            THNStoreModel *model = [THNStoreModel mj_objectWithKeyValues:storeDict];
            
            THNTableViewCells *storeCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeFollowStore) didSelectedItem:^(NSString *ids) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"店铺ID == %@", ids]];
            }];
            storeCells.height = kCellHeightStore;
            storeCells.storeModel = model;
            
            THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeFollowStore) didSelectedItem:^(NSString *ids) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"商品ID == %@", ids]];
            }];
            goodsCells.height = kCellHeightGoods + 15.0;
            goodsCells.goodsDataArr = model.products;

            THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, goodsCells] mutableCopy]];
            sections.footerHeight = kSectionFooterHeight;
            [self.dataSections addObject:sections];
        }
        
        [self thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedTypeStore)];
        self.tableView.backgroundColor = [UIColor colorWithHexString:self.dataSections.count ? kColorBackground : kColorWhite];
    }];
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNTableViewCells *cells = sections.dataCells[indexPath.row];

    if (cells.cellType == THNTableViewCellTypeLikedGoods) { // 商品列表
        THNLikedGoodsTableViewCell *likedGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView
                                                                                                  cellStyle:(UITableViewCellStyleDefault)];
        cells.likedGoodsCell = likedGoodsCell;
        likedGoodsCell.cell = cells;
        [likedGoodsCell thn_setLikedGoodsData:cells.goodsDataArr];
        
        return likedGoodsCell;
    
    } else if (cells.cellType == THNTableViewCellTypeLikedWindow) { // 橱窗列表
        THNLikedWindowTableViewCell *likedWindowCell = [THNLikedWindowTableViewCell initWindowCellWithTableView:tableView
                                                                                                      cellStyle:(UITableViewCellStyleDefault)];
        cells.likedWindowCell = likedWindowCell;
        likedWindowCell.cell = cells;
        [likedWindowCell thn_setWindowData:cells.windowDataArr];

        return likedWindowCell;
    
    } else if (cells.cellType == THNTableViewCellTypeFollowStore) { // 设计馆列表
        if (indexPath.row == 0) {
            THNFollowStoreTableViewCell *followStoreCell = [THNFollowStoreTableViewCell initStoreCellWithTableView:tableView
                                                                                                         cellStyle:(UITableViewCellStyleDefault)];
            cells.followStoreCell = followStoreCell;
            followStoreCell.cell = cells;
            [followStoreCell thn_setStoreData:cells.storeModel];
            
            return followStoreCell;
            
        } else if (indexPath.row == 1) {
            THNLikedGoodsTableViewCell *storeGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView
                                                                                                  initWithStyle:(UITableViewCellStyleDefault)
                                                                                                reuseIdentifier:kStoreGodsTableViewCellId];
            cells.likedGoodsCell = storeGoodsCell;
            storeGoodsCell.cell = cells;
            storeGoodsCell.itemWidth = kCellHeightGoods;
            [storeGoodsCell thn_setLikedGoodsData:cells.goodsDataArr];
            
            return storeGoodsCell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNTableViewCells *cells = sections.dataCells[indexPath.row];
    
    if (cells.cellType == THNTableViewCellTypeFollowStore) {
        if (indexPath.row == 0) {
            THNFollowStoreTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.cell.selectedCellBlock([NSString stringWithFormat:@"%zi", cells.storeModel.rid]);
        }
    }
}

#pragma mark - private methods
- (void)thn_changTableViewDataSourceWithType:(THNHeaderViewSelectedType)type {
    _selectedDataType = type;
    [self.dataSections removeAllObjects];
    
    switch (type) {
        case THNHeaderViewSelectedTypeLiked: {
            [self thn_setGoodsTableViewCellWithType:(THNUserCenterGoodsTypeLikedGoods)];
        }
            break;
            
        case THNHeaderViewSelectedTypeCollect: {
            [self thn_setGoodsTableViewCellWithType:(THNUserCenterGoodsTypeBrowses)];
            [self thn_setGoodsTableViewCellWithType:(THNUserCenterGoodsTypeWishList)];
        }
            break;
            
        case THNHeaderViewSelectedTypeStore: {
            [self thn_setFollowStoreTableViewCell];
        }
            break;
            
        default:
            break;
    }
}

- (void)thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedType)type {
    [self.footerView setSubHintLabelTextWithType:type];
    self.tableView.tableFooterView = !self.dataSections.count ? self.footerView : [UIView new];
    [self.tableView reloadData];
}

#pragma mark - setup UI
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 50) {
        self.navigationBarView.title = self.userName;
    } else if (scrollView.contentOffset.y < 50) {
        self.navigationBarView.title = @"";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamedArray:@[@"icon_nav_share_gray",
                                                                        @"icon_setting_gray"]];
}

#pragma mark - custom delegate
- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type {
    switch (type) {
        case THNHeaderViewSelectedTypeLiked:
        case THNHeaderViewSelectedTypeCollect:
        case THNHeaderViewSelectedTypeStore:{
            [self thn_changTableViewDataSourceWithType:type];
        }
            break;
            
        case THNHeaderViewSelectedTypeDynamic:{
            THNDynamicTableViewController *dynamicVC = [[THNDynamicTableViewController alloc] init];
            [self.navigationController pushViewController:dynamicVC animated:YES];
        }
            break;
            
        case THNHeaderViewSelectedTypeActivity:{
//            [SVProgressHUD showInfoWithStatus:@"活动"];
            THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithCategoryId:85 categoryName:@"分类"];
            [self.navigationController pushViewController:goodsListVC animated:YES];
        }
            break;
            
        case THNHeaderViewSelectedTypeOrder:{
            [SVProgressHUD showInfoWithStatus:@"订单"];
        }
            break;
            
        case THNHeaderViewSelectedTypeCoupon:{
            [SVProgressHUD showInfoWithStatus:@"优惠券"];
        }
            break;
            
        case THNHeaderViewSelectedTypeService:{
            [SVProgressHUD showInfoWithStatus:@"客服"];
        }
            break;
    }
}

- (void)didNavigationRightButtonOfIndex:(NSInteger)index {
    if (index == 0) {
        THNApplyStoreViewController *applyVC = [[THNApplyStoreViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
        
    } else if (index == 1) {
        [THNLoginManager userLogoutCompletion:^(NSError *error) {
            if (error) return;
            [SVProgressHUD showSuccessWithStatus:@"退出登录"];
        }];
    }
}

#pragma mark - getters and setters
- (THNMyCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNMyCenterHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (THNTableViewFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[THNTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _footerView;
}

@end
