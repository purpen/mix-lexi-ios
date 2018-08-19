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
#import "THNLikedGoodsTableViewCell.h"
#import "THNLikedWindowTableViewCell.h"
#import "THNLikedWindowViewController.h"
#import "THNLikedGoodsViewController.h"
#import "THNUserManager.h"
#import "THNApplyStoreViewController.h"
#import "THNDynamicTableViewController.h"

static NSString *const kHeaderTitleGoods    = @"喜欢的商品";
static NSString *const kHeaderTitleWindow   = @"喜欢的橱窗";
static NSString *const kHeaderTitleBrowses  = @"最近查看";
static NSString *const kHeaderTitleWishList = @"心愿单";
static CGFloat const kCellHeightGoods       = 100.0;
static CGFloat const kCellHeightWindow      = 162.0;
/// 商品数量低于最小值不显示“查看全部”
static NSInteger const kMinGoodsCount       = 2;

@interface THNMyCenterViewController () <THNNavigationBarViewDelegate, THNMyCenterHeaderViewDelegate> {
    THNHeaderViewSelectedType _selectedDataType;
}

@property (nonatomic, strong) THNMyCenterHeaderView *headerView;

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
        
        [self.headerView thn_setUserInfoModel:model];
        self.tableView.tableHeaderView = self.headerView;
    }];
}

// 商品信息
- (void)thn_setGoodsTableViewCellWithType:(THNProductsType)type {
    NSArray *titleArr = @[kHeaderTitleGoods, kHeaderTitleBrowses, kHeaderTitleWishList];
    NSString *headerTitle = titleArr[(NSInteger)type];
    
    [THNUserManager getProductsWithType:type params:@{} completion:^(NSArray *goodsData, NSError *error) {
        if (error || !goodsData.count) return;
        
        THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedGoods) didSelectedItem:^(NSString *ids) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"商品ID == %@", ids]];
        }];
        cells.goodsDataArr = goodsData;
        cells.height = kCellHeightGoods;
        
        THNTableViewSections *sections = nil;
        if (goodsData.count <= kMinGoodsCount) {
            sections = [THNTableViewSections initSectionsWithHeaderTitle:headerTitle];
        } else {
            sections = [THNTableViewSections initSectionsWithHeaderTitle:headerTitle moreCompletion:^{
                THNLikedGoodsViewController *likedGoodsVC = [[THNLikedGoodsViewController alloc] initWithShowProductsType:type];
                likedGoodsVC.title = titleArr[(NSInteger)type];
                [self.navigationController pushViewController:likedGoodsVC animated:YES];
            }];
        }
        sections.index = (NSInteger)type;
        sections.dataCells = [@[cells] mutableCopy];
        
        [self.dataSections addObject:sections];
        [self thn_sortDataSecitons];
        
        [self.tableView reloadData];
    }];
}

// 喜欢的橱窗
- (void)thn_setLikedWindowTableViewCell {
    [THNUserManager getUserLikedWindowWithParams:@{} completion:^(NSArray *windowData, NSError *error) {
        if (error || !windowData.count) return;
        
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
        
        [self.dataSections addObject:sections];
        [self thn_sortDataSecitons];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNTableViewCells *cells = sections.dataCells[indexPath.row];

    if (cells.cellType == THNTableViewCellTypeLikedGoods) {
        THNLikedGoodsTableViewCell *likedGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView
                                                                                                  cellStyle:(UITableViewCellStyleDefault)];
        cells.likedGoodsCell = likedGoodsCell;
        likedGoodsCell.cell = cells;
        [likedGoodsCell thn_setLikedGoodsData:cells.goodsDataArr];
        
        return likedGoodsCell;
    
    } else if (cells.cellType == THNTableViewCellTypeLikedWindow) {
        THNLikedWindowTableViewCell *likedWindowCell = [THNLikedWindowTableViewCell initWindowCellWithTableView:tableView
                                                                                                      cellStyle:(UITableViewCellStyleDefault)];
        cells.likedWindowCell = likedWindowCell;
        likedWindowCell.cell = cells;
        [likedWindowCell thn_setWindowData:cells.windowDataArr];

        return likedWindowCell;
    }
    
    return nil;
}

#pragma mark - private methods
- (void)thn_changTableViewDataSourceWithType:(THNHeaderViewSelectedType)type {
    _selectedDataType = type;
    [self.dataSections removeAllObjects];
    
    switch (type) {
        case THNHeaderViewSelectedTypeLiked: {
            [self thn_setGoodsTableViewCellWithType:(THNProductsTypeLikedGoods)];
            [self thn_setLikedWindowTableViewCell];
        }
            break;
            
        case THNHeaderViewSelectedTypeCollect: {
            [self thn_setGoodsTableViewCellWithType:(THNProductsTypeBrowses)];
            [self thn_setGoodsTableViewCellWithType:(THNProductsTypeWishList)];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setup UI
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"------- %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= 60) {
        self.navigationBarView.title = @"乐喜客户端";
    } else if (scrollView.contentOffset.y < 60) {
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
            [SVProgressHUD showInfoWithStatus:@"活动"];
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
        [SVProgressHUD showInfoWithStatus:@"分享"];
        THNApplyStoreViewController *applyVC = [[THNApplyStoreViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
        
    } else if (index == 1) {
        [SVProgressHUD showInfoWithStatus:@"设置"];
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

@end
