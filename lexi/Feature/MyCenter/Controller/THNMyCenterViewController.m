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
#import "THNMyCenterMenuView.h"
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
#import "THNGoodsInfoViewController.h"
#import "THNOrderViewController.h"
#import "THNBrandHallViewController.h"
#import "THNUserApplyViewController.h"
#import "THNSettingViewController.h"
#import "THNSettingUserInfoViewController.h"
#import "THNLifeManagementViewController.h"
#import "THNShareViewController.h"
#import "THNMyCouponViewController.h"

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

@interface THNMyCenterViewController () <
    THNNavigationBarViewDelegate,
    THNMyCenterHeaderViewDelegate,
    THNMyCenterMenuViewDelegate
> {
    THNHeaderViewSelectedType _selectedDataType;
}

/// 用户昵称
@property (nonatomic, strong) NSString *userName;
/// 顶部视图：用户信息
@property (nonatomic, strong) THNMyCenterHeaderView *headerView;
/// 底部视图：数据缺省
@property (nonatomic, strong) THNTableViewFooterView *footerView;
/// 用户数据
@property (nonatomic, strong) THNUserModel *userModel;
/// 内容视图
@property (nonatomic, strong) UIScrollView *containerView;
/// 管理按钮
@property (nonatomic, strong) THNMyCenterMenuView *menuView;
/// 生活馆管理
@property (nonatomic, strong) THNLifeManagementViewController *lifeStoreVC;

@end

@implementation THNMyCenterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewUI];
}

#pragma mark - custom delegate
- (void)thn_didSelectedMenuButtonIndex:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
    }];
}

- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type {
    switch (type) {
        case THNHeaderViewSelectedTypeLiked:
        case THNHeaderViewSelectedTypeCollect:
        case THNHeaderViewSelectedTypeStore: {
            [self thn_changTableViewDataSourceWithType:type];
        }
            break;
            
        case THNHeaderViewSelectedTypeDynamic: {
            THNDynamicTableViewController *dynamicVC = [[THNDynamicTableViewController alloc] init];
            [self.navigationController pushViewController:dynamicVC animated:YES];
        }
            break;
            
        case THNHeaderViewSelectedTypeActivity: {
            THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(ShareContentTypeGoods)];
            shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:shareVC animated:NO completion:nil];
        }
            break;
            
        case THNHeaderViewSelectedTypeOrder: {
            THNOrderViewController *order = [[THNOrderViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
            
        case THNHeaderViewSelectedTypeCoupon: {
            THNMyCouponViewController *couponVC = [[THNMyCouponViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
            
        case THNHeaderViewSelectedTypeService: {
            [SVProgressHUD thn_showInfoWithStatus:@"客服"];
        }
            break;
    }
}

- (void)thn_selectedUserHeadImage {
    THNSettingUserInfoViewController *setUserInfoVC = [[THNSettingUserInfoViewController alloc] init];
    [self.navigationController pushViewController:setUserInfoVC animated:YES];
}

- (void)didNavigationRightButtonOfIndex:(NSInteger)index {
    if (index == 0) {
        THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(ShareContentTypeGoods)];
        shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:shareVC animated:NO completion:nil];
        
    } else if (index == 1) {
        if (self.userModel) {
            THNSettingViewController *settingVC = [[THNSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }
}

#pragma mark - private methods
- (void)thn_getUserCenterGoodsData {
    _selectedDataType = THNHeaderViewSelectedTypeLiked;
    [self thn_changTableViewDataSourceWithType:_selectedDataType];
}

#pragma mark - network
// 头部用户信息
- (void)thn_setUserHeaderView {
    WEAKSELF;
    
    [THNUserManager getUserCenterCompletion:^(THNUserModel *model, NSError *error) {
        if (error) return;
        
        weakSelf.userModel = model;
        weakSelf.userName = model.username;
        [weakSelf.headerView thn_setUserInfoModel:model];
        weakSelf.tableView.tableHeaderView = self.headerView;
    }];
}

// 用户资料
- (void)thn_getUserData {
    [[THNLoginManager sharedManager] getUserProfile:nil];
}

// 商品信息
- (void)thn_setGoodsTableViewCellWithType:(THNUserCenterGoodsType)type {
    NSArray *titleArr = @[kHeaderTitleLiked, kHeaderTitleBrowses, kHeaderTitleWishList];
    NSString *headerTitle = titleArr[(NSInteger)type];

    [SVProgressHUD thn_showWithStatus:nil maskType:(SVProgressHUDMaskTypeClear)];
    
    WEAKSELF;
    
    [THNGoodsManager getUserCenterProductsWithType:type params:@{} completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error) return;
        
        THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedGoods) didSelectedItem:^(NSString *ids) {
            THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:ids];
            [weakSelf.navigationController pushViewController:goodsInfoVC animated:YES];
        }];
        goodsCells.height = kCellHeightGoods;
        goodsCells.goodsDataArr = goodsData;
        
        THNTableViewSections *sections = nil;
        if (goodsData.count <= kMinGoodsCount) {    // 不显示“查看全部”按钮
            sections = [THNTableViewSections initSectionsWithHeaderTitle:headerTitle];
            
        } else {
            sections = [THNTableViewSections initSectionsWithHeaderTitle:headerTitle moreCompletion:^{
                THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] \
                                                           initWithUserCenterGoodsType:type title:headerTitle];
                [weakSelf.navigationController pushViewController:goodsListVC animated:YES];
            }];
        }
        sections.index = (NSInteger)type;
        sections.dataCells = [@[goodsCells] mutableCopy];
        
        if (goodsData.count) {
            [weakSelf.dataSections addObject:sections];
            [weakSelf thn_sortDataSecitons];
        }
        
        if (type == THNUserCenterGoodsTypeLikedGoods) {
//            [weakSelf thn_setLikedWindowTableViewCell];
        }
        
        [weakSelf thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedTypeCollect)];
        weakSelf.tableView.backgroundColor = [UIColor whiteColor];
        
        [SVProgressHUD dismiss];
    }];
}

// 喜欢的橱窗
- (void)thn_setLikedWindowTableViewCell {
    WEAKSELF;
    
    [THNUserManager getUserLikedWindowWithParams:@{} completion:^(NSArray *windowData, NSError *error) {
        if (error) return;
        
        THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedWindow) didSelectedItem:^(NSString *ids) {
            [SVProgressHUD thn_showInfoWithStatus:[NSString stringWithFormat:@"橱窗ID == %@", ids]];
        }];
        cells.height = kCellHeightWindow;
        cells.windowDataArr = windowData;
        
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleWindow moreCompletion:^{
            THNLikedWindowViewController *likedWindowVC = [[THNLikedWindowViewController alloc] init];
            [weakSelf.navigationController pushViewController:likedWindowVC animated:YES];
        }];
        sections.index = 1;
        sections.dataCells = [@[cells] mutableCopy];
        
        if (windowData.count) {
            [weakSelf.dataSections addObject:sections];
            [weakSelf thn_sortDataSecitons];
        }
        
        [weakSelf thn_setTableViewFooterViewWithType:THNHeaderViewSelectedTypeLiked];
        weakSelf.tableView.backgroundColor = [UIColor whiteColor];
    }];
}

// 关注的设计馆
- (void)thn_setFollowStoreTableViewCell {
    [SVProgressHUD thn_showWithStatus:nil maskType:(SVProgressHUDMaskTypeClear)];
    
    WEAKSELF;
    
    [THNUserManager getUserFollowStoreWithParams:@{} completion:^(NSArray *storesData, NSError *error) {
        if (error) return;
        
        for (NSDictionary *storeDict in storesData) {
            THNStoreModel *model = [[THNStoreModel alloc] initWithDictionary:storeDict];
            
            THNTableViewCells *storeCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeFollowStore) didSelectedItem:^(NSString *ids) {
                THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
                brandHallVC.rid = ids;
                [self.navigationController pushViewController:brandHallVC animated:YES];
            }];
            storeCells.height = kCellHeightStore;
            storeCells.storeModel = model;
            
            THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeFollowStore) didSelectedItem:^(NSString *ids) {
                THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:ids];
                [weakSelf.navigationController pushViewController:goodsInfoVC animated:YES];
            }];
            goodsCells.height = kCellHeightGoods + 15.0;
            goodsCells.goodsDataArr = model.products;

            THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, goodsCells] mutableCopy]];
            sections.footerHeight = kSectionFooterHeight;
            [weakSelf.dataSections addObject:sections];
        }
        
        [weakSelf thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedTypeStore)];
        weakSelf.tableView.backgroundColor = [UIColor colorWithHexString:weakSelf.dataSections.count ? kColorBackground : kColorWhite];
        
        [SVProgressHUD dismiss];
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
            storeGoodsCell.goodsCellType = THNGoodsListCellViewTypeUserCenter;
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
            cell.cell.selectedCellBlock(cells.storeModel.rid);
        }
    }
}

#pragma mark - private methods
- (void)thn_changTableViewDataSourceWithType:(THNHeaderViewSelectedType)type {
    _selectedDataType = type;
    [self.dataSections removeAllObjects];
    [self.tableView reloadData];
    
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
- (void)setupTableViewUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSeparatorStyle:THNTableViewCellSeparatorStyleNone];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self.view addSubview:self.menuView];
    [self.containerView addSubview:self.tableView];
    
    [self addChildViewController:self.lifeStoreVC];

    [self.containerView addSubview:self.lifeStoreVC.view];
    [self.view addSubview:self.containerView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 50) {
        self.navigationBarView.title = self.userName;
        
    } else if (scrollView.contentOffset.y < 50) {
        self.navigationBarView.title = @"";
    }
}

- (void)thn_uploadViewFrame {
    CGRect menuViewFrame = self.menuView.frame;
    CGFloat height = [THNLoginManager sharedManager].openingUser ? 44 : 0;
    menuViewFrame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, height);
    self.menuView.frame = menuViewFrame;
    
    CGFloat tabbarH = kDeviceiPhoneX ? 81 : 49;
    
    CGRect containerFrame = self.menuView.frame;
    CGFloat containerH = SCREEN_HEIGHT - CGRectGetMaxY(self.menuView.frame) - tabbarH;
    containerFrame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame), SCREEN_WIDTH, containerH);
    self.containerView.frame = containerFrame;
    
    NSInteger pageCount = [THNLoginManager sharedManager].openingUser ? 2 : 1;
    self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, 0);
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, containerH);
    self.lifeStoreVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, containerH);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    
    if ([THNLoginManager isLogin]) {
        [self thn_setUserHeaderView];
        [self thn_getUserData];
        [self thn_getUserCenterGoodsData];
        [self thn_uploadViewFrame];
    }
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamedArray:@[@"icon_nav_share_gray",
                                                                        @"icon_setting_gray"]];
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

- (THNMyCenterMenuView *)menuView {
    if (!_menuView) {
        CGFloat height = [THNLoginManager sharedManager].openingUser ? 44 : 0;
        _menuView = [[THNMyCenterMenuView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, height)];
        _menuView.delegate = self;
    }
    return _menuView;
}

- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor orangeColor];
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.pagingEnabled = YES;
        _containerView.scrollEnabled = NO;
        _containerView.bounces = NO;
    }
    return _containerView;
}

- (THNLifeManagementViewController *)lifeStoreVC {
    if (!_lifeStoreVC) {
        _lifeStoreVC = [[THNLifeManagementViewController alloc] init];
    }
    return _lifeStoreVC;
}

@end
