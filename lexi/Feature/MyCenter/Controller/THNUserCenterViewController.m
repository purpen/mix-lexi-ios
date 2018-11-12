//
//  THNUserCenterViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/25.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNUserCenterViewController.h"
#import "THNShareViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNMyCenterHeaderView.h"
#import "THNTableViewFooterView.h"
#import "THNMyCenterMenuView.h"
#import "THNLikedGoodsTableViewCell.h"
#import "THNLikedWindowTableViewCell.h"
#import "THNFollowStoreTableViewCell.h"
#import "THNWindowListViewController.h"
#import "THNDynamicViewController.h"
#import "THNGoodsListViewController.h"
#import "THNUserManager.h"
#import "THNGoodsManager.h"
#import "THNLoginManager.h"
#import "THNGoodsInfoViewController.h"
#import "THNBrandHallViewController.h"
#import "THNShareViewController.h"
#import "THNUserListViewController.h"

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
/// key
static NSString *const kKeyUid = @"uid";

@interface THNUserCenterViewController () <
    THNNavigationBarViewDelegate,
    THNMyCenterHeaderViewDelegate
> {
    THNHeaderViewSelectedType _selectedDataType;
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) THNMyCenterHeaderView *headerView;
@property (nonatomic, strong) THNTableViewFooterView *footerView;
/// 数据
@property (nonatomic, strong) THNUserModel *userModel;
@property (nonatomic, strong) NSArray *likedGoodsArr;
@property (nonatomic, strong) NSArray *browsesGoodsArr;
@property (nonatomic, strong) NSArray *wishGoodsArr;
@property (nonatomic, strong) NSArray *windowArr;
@property (nonatomic, strong) NSArray *storeArr;

@end

@implementation THNUserCenterViewController

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self thn_setUserCenterData];
    [self thn_changTableViewDataSourceWithType:_selectedDataType];
}

#pragma mark - custom delegate
- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type {
    switch (type) {
        case THNHeaderViewSelectedTypeLiked:
        case THNHeaderViewSelectedTypeCollect:
        case THNHeaderViewSelectedTypeStore: {
            [self thn_changTableViewDataSourceWithType:type];
        }
            break;
            
        case THNHeaderViewSelectedTypeDynamic: {
            [self thn_openDynamicController];
        }
            break;
            
        case THNHeaderViewSelectedTypeFans: {
            [self thn_openUserListControllerWithType:(THNUserListTypeOtherFans)];
        }
            break;
            
        case THNHeaderViewSelectedTypeFollow: {
            [self thn_openUserListControllerWithType:(THNUserListTypeOtherFollow)];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - network
/**
 获取个人中心信息
 */
- (void)thn_getUserCenterDataWithGroup:(dispatch_group_t)group {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNUserManager getUserCenterWithUserId:self.userId Completion:^(THNUserModel *model, NSError *error) {
            dispatch_group_leave(group);
            
            if (error) return;
            
            weakSelf.userModel = model;
            weakSelf.userName = model.username;
            [SVProgressHUD dismiss];
        }];
    });
}

/**
 获取商品数据
 */
- (void)thn_getUserCenterGoodsDataWithGroup:(dispatch_group_t)group type:(THNUserCenterGoodsType)type {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getUserCenterProductsWithType:type
                                                params:@{kKeyUid: self.userId}
                                            completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                                dispatch_group_leave(group);
                                                if (error) return;
                                                
                                                switch (type) {
                                                    case THNUserCenterGoodsTypeLikedGoods:
                                                        weakSelf.likedGoodsArr = [NSArray arrayWithArray:goodsData];
                                                        break;
                                                        
                                                    case THNUserCenterGoodsTypeBrowses:
                                                        weakSelf.browsesGoodsArr = [NSArray arrayWithArray:goodsData];
                                                        break;
                                                        
                                                    case THNUserCenterGoodsTypeWishList:
                                                        weakSelf.wishGoodsArr = [NSArray arrayWithArray:goodsData];
                                                        break;
                                                }
                                                
                                                [SVProgressHUD dismiss];
        }];
    });
}

/**
 获取橱窗数据
 */
- (void)thn_getUserCenterWindowDataWithGroup:(dispatch_group_t)group {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNUserManager getUserLikedWindowWithParams:@{kKeyUid: self.userId, @"per_page": @(5)}
                                          completion:^(THNWindowModel *model, NSError *error) {
                                              dispatch_group_leave(group);
                                              if (error) return;
                                              
                                              weakSelf.windowArr = [NSArray arrayWithArray:model.shopWindows];
                                              [SVProgressHUD dismiss];
                                          }];
    });
}

/**
 获取关注的设计馆数据
 */
- (void)thn_getUserCenterFollowStoreDataWithGroup:(dispatch_group_t)group {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNUserManager getUserFollowStoreWithParams:@{kKeyUid: self.userId} completion:^(NSArray *storesData, NSError *error) {
            dispatch_group_leave(group);
            if (error) return;
            
            weakSelf.storeArr = [NSArray arrayWithArray:storesData];
            [SVProgressHUD dismiss];
        }];
    });
}

#pragma mark - set cell
- (void)thn_setUserCenterData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterDataWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self thn_setUserCenterHeaderView];
    });
}

- (void)thn_setUserLikedData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterGoodsDataWithGroup:group type:(THNUserCenterGoodsTypeLikedGoods)];
    [self thn_getUserCenterWindowDataWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self thn_setUserCenterLikedGoodsCell];
        [self thn_setUserCenterLikedWindowCell];
        [self thn_setTableViewFooterViewWithType:THNHeaderViewSelectedTypeLiked backgroundColorHex:@"#FFFFFF"];
    });
}

- (void)thn_setUserCollectData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterGoodsDataWithGroup:group type:(THNUserCenterGoodsTypeBrowses)];
    [self thn_getUserCenterGoodsDataWithGroup:group type:(THNUserCenterGoodsTypeWishList)];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self thn_setUserCenterBrowesGoodsCell];
        [self thn_setUserCenterWishGoodsCell];
        [self thn_setTableViewFooterViewWithType:THNHeaderViewSelectedTypeCollect backgroundColorHex:@"#FFFFFF"];
    });
}

- (void)thn_setUserFollowedStoreData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterFollowStoreDataWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self thn_setUserCenterFollowStoreCell];
        [self thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedTypeStore)
                              backgroundColorHex:self.dataSections.count ? kColorBackground : kColorWhite];
    });
}

- (void)thn_changTableViewDataSourceWithType:(THNHeaderViewSelectedType)type {
    _selectedDataType = type;
    
    [self.dataSections removeAllObjects];
    [self.tableView reloadData];
    
    if (type == THNHeaderViewSelectedTypeLiked) {
        [self thn_setUserLikedData];
        
    } else if (type == THNHeaderViewSelectedTypeCollect) {
        [self thn_setUserCollectData];
        
    } else if (type == THNHeaderViewSelectedTypeStore) {
        [self thn_setUserFollowedStoreData];
    }
}

/**
 头部用户信息
 */
- (void)thn_setUserCenterHeaderView {
    [self.headerView thn_setUserInfoModel:self.userModel];
    self.tableView.tableHeaderView = self.headerView;
}

/**
 喜欢的商品
 */
- (void)thn_setUserCenterLikedGoodsCell {
    if (!self.likedGoodsArr.count) {
        return;
    }
    
    WEAKSELF;
    
    THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeGoods) didSelectedItem:^(NSString *ids) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:ids];
    }];
    goodsCells.height = kCellHeightGoods;
    goodsCells.goodsDataArr = self.likedGoodsArr;
    
    THNTableViewSections *sections = [THNTableViewSections new];
    if (self.likedGoodsArr.count <= kMinGoodsCount) {    // 不显示“查看全部”按钮
        sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleLiked];
        
    } else {
        sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleLiked moreCompletion:^{
            [weakSelf thn_openGoodsListControllerWithGoodsType:(THNUserCenterGoodsTypeLikedGoods) title:kHeaderTitleLiked];
        }];
    }
    sections.index = 0;
    sections.dataCells = [@[goodsCells] mutableCopy];
    [self.dataSections addObject:sections];
}

/**
 喜欢的橱窗
 */
- (void)thn_setUserCenterLikedWindowCell {
    if (!self.windowArr.count) {
        return;
    }
    
    WEAKSELF;
    
    THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedWindow) didSelectedItem:^(NSString *ids) {
        [SVProgressHUD thn_showInfoWithStatus:[NSString stringWithFormat:@"打开橱窗：%@", ids]];
    }];
    cells.height = kCellHeightWindow;
    cells.windowDataArr = self.windowArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleWindow moreCompletion:^{
        [weakSelf thn_openLikedWindowController];
    }];
    sections.index = 1;
    sections.dataCells = [@[cells] mutableCopy];
    [self.dataSections addObject:sections];
}

/**
 最近浏览的商品
 */
- (void)thn_setUserCenterBrowesGoodsCell {
    if (!self.browsesGoodsArr.count) {
        return;
    }
    
    WEAKSELF;
    
    THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeGoods) didSelectedItem:^(NSString *ids) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:ids];
    }];
    goodsCells.height = kCellHeightGoods;
    goodsCells.goodsDataArr = self.browsesGoodsArr;
    
    THNTableViewSections *sections = [THNTableViewSections new];
    if (self.browsesGoodsArr.count <= kMinGoodsCount) {    // 不显示“查看全部”按钮
        sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleBrowses];
        
    } else {
        sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleBrowses moreCompletion:^{
            [weakSelf thn_openGoodsListControllerWithGoodsType:(THNUserCenterGoodsTypeBrowses) title:kHeaderTitleBrowses];
        }];
    }
    sections.index = 0;
    sections.dataCells = [@[goodsCells] mutableCopy];
    [self.dataSections addObject:sections];
}

/**
 心愿单的商品
 */
- (void)thn_setUserCenterWishGoodsCell {
    if (!self.wishGoodsArr.count) {
        return;
    }
    
    WEAKSELF;
    
    THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeGoods) didSelectedItem:^(NSString *ids) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:ids];
    }];
    goodsCells.height = kCellHeightGoods;
    goodsCells.goodsDataArr = self.wishGoodsArr;
    
    THNTableViewSections *sections = [THNTableViewSections new];
    if (self.wishGoodsArr.count <= kMinGoodsCount) {    // 不显示“查看全部”按钮
        sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleWishList];
        
    } else {
        sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleWishList moreCompletion:^{
            [weakSelf thn_openGoodsListControllerWithGoodsType:(THNUserCenterGoodsTypeWishList) title:kHeaderTitleWishList];
        }];
    }
    sections.index = 1;
    sections.dataCells = [@[goodsCells] mutableCopy];
    [self.dataSections addObject:sections];
}

/**
 关注的店铺
 */
- (void)thn_setUserCenterFollowStoreCell {
    if (!self.storeArr.count) {
        return;
    }
    
    WEAKSELF;
    
    for (NSDictionary *storeDict in self.storeArr) {
        THNStoreModel *model = [[THNStoreModel alloc] initWithDictionary:storeDict];
        
        THNTableViewCells *storeCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeFollowStore)
                                                            didSelectedItem:^(NSString *ids) {
                                                                [weakSelf thn_openBrandHallControllerWithBrandId:ids];
                                                            }];
        storeCells.height = kCellHeightStore;
        storeCells.storeModel = model;
        
        THNTableViewCells *goodsCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeFollowStore)
                                                            didSelectedItem:^(NSString *ids) {
                                                                [weakSelf thn_openGoodsInfoControllerWithGoodsId:ids];
                                                            }];
        goodsCells.height = kCellHeightGoods + 15.0;
        goodsCells.goodsDataArr = model.products;
        
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, goodsCells] mutableCopy]];
        sections.footerHeight = kSectionFooterHeight;
        [self.dataSections addObject:sections];
    }
}

#pragma mark - open other controller
/**
 打开商品详情视图
 */
- (void)thn_openGoodsInfoControllerWithGoodsId:(NSString *)goodsId {
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:goodsId];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

/**
 打开商品列表视图
 */
- (void)thn_openGoodsListControllerWithGoodsType:(THNUserCenterGoodsType)goodsType title:(NSString *)title {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithUserCenterGoodsType:goodsType
                                                                                                        title:title
                                                                                                       userId:self.userId];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

/**
 打开喜欢橱窗视图
 */
- (void)thn_openLikedWindowController {
    THNWindowListViewController *likedWindowVC = [[THNWindowListViewController alloc] initWithUserId:self.userId];
    [self.navigationController pushViewController:likedWindowVC animated:YES];
}

/**
 打开品牌馆详情
 */
- (void)thn_openBrandHallControllerWithBrandId:(NSString *)brandId {
    THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
    brandHallVC.rid = brandId;
    [self.navigationController pushViewController:brandHallVC animated:YES];
}

/**
 打开分享视图
 */
- (void)thn_openShareController {
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(ShareContentTypeGoods)];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

/**
 打开动态视图
 */
- (void)thn_openDynamicController {
    THNDynamicViewController *dynamicVC = [[THNDynamicViewController alloc] init];
    [self.navigationController pushViewController:dynamicVC animated:YES];
}

/**
 打开用户列表
 */
- (void)thn_openUserListControllerWithType:(THNUserListType)type {
    THNUserListViewController *userListVC = [[THNUserListViewController alloc] initWithType:type requestId:self.userId];
    [self.navigationController pushViewController:userListVC animated:YES];
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNTableViewCells *cells = sections.dataCells[indexPath.row];
    
    switch (cells.cellType) {
        case THNTableViewCellTypeGoods: {
            THNLikedGoodsTableViewCell *likedGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView
                                                                                                      cellStyle:(UITableViewCellStyleDefault)];
            cells.likedGoodsCell = likedGoodsCell;
            likedGoodsCell.cell = cells;
            [likedGoodsCell thn_setLikedGoodsData:cells.goodsDataArr];
            
            return likedGoodsCell;
        }
            break;
            
        case THNTableViewCellTypeLikedWindow: {
            THNLikedWindowTableViewCell *likedWindowCell = [THNLikedWindowTableViewCell initWindowCellWithTableView:tableView
                                                                                                          cellStyle:(UITableViewCellStyleDefault)];
            cells.likedWindowCell = likedWindowCell;
            likedWindowCell.cell = cells;
            [likedWindowCell thn_setWindowData:cells.windowDataArr];
            
            return likedWindowCell;
        }
            break;
            
        case THNTableViewCellTypeFollowStore: {
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
            break;
            
        default:
            break;
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
/**
 设置无数据时的默认视图
 */
- (void)thn_setTableViewFooterViewWithType:(THNHeaderViewSelectedType)type backgroundColorHex:(NSString *)colorHex {
    [self.footerView setSubHintLabelTextWithType:type];
    
    self.tableView.tableFooterView = !self.dataSections.count ? self.footerView : [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithHexString:colorHex];
    
    [self.tableView reloadData];
}

#pragma mark - setup UI
- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_nav_share_gray"];
}

/**
 显示导航栏标题
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 50) {
        self.navigationBarView.title = self.userName;
        
    } else if (scrollView.contentOffset.y < 80) {
        self.navigationBarView.title = @"";
    }
}

#pragma mark - getters and setters
- (THNMyCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNMyCenterHeaderView alloc] initWithType:(THNMyCenterHeaderViewTypeOther)];
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
