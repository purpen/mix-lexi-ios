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
#import "THNWindowListViewController.h"
#import "THNApplyStoreViewController.h"
#import "THNDynamicViewController.h"
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
#import "THNUserListViewController.h"
#import "THNShopWindowDetailViewController.h"
#import "THNShopWindowModel.h"
#import "UIScrollView+THNMJRefresh.h"
#import "THNInvitationViewController.h"
#import "THNAdvertInviteView.h"
#import "THNAdvertUpdateViewController.h"

#define kShareUserInfo(obj) [NSString stringWithFormat:@"@%@在#乐喜#悄悄收藏了一些原创精品好物", obj]

/// seciton header 默认的标题
static NSString *const kHeaderTitleLiked    = @"喜欢的商品";
static NSString *const kHeaderTitleWindow   = @"喜欢的橱窗";
static NSString *const kHeaderTitleBrowses  = @"最近查看";
static NSString *const kHeaderTitleWishList = @"心愿单";
static NSString *const kShareDes            = @"快来看看吧";
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
    THNMyCenterMenuViewDelegate,
    THNMJRefreshDelegate
> {
    THNHeaderViewSelectedType _selectedDataType;
}

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) THNMyCenterHeaderView *headerView;
@property (nonatomic, strong) THNTableViewFooterView *footerView;
/// 数据
@property (nonatomic, strong) THNUserModel *userModel;
@property (nonatomic, strong) NSArray *likedGoodsArr;
@property (nonatomic, strong) NSArray *browsesGoodsArr;
@property (nonatomic, strong) NSArray *wishGoodsArr;
@property (nonatomic, strong) NSArray *windowArr;
@property (nonatomic, strong) NSMutableArray *storeArr;
/// 记录列表数据
@property (nonatomic, strong) NSMutableArray *likedSectionsArr;
@property (nonatomic, strong) NSMutableArray *collectSectionsArr;
@property (nonatomic, strong) NSMutableArray *storeSectionsArr;
/// 内容视图
@property (nonatomic, strong) UIScrollView *containerView;
/// 管理按钮
@property (nonatomic, strong) THNMyCenterMenuView *menuView;
/// 生活馆管理
@property (nonatomic, strong) THNLifeManagementViewController *lifeStoreVC;
/// 记录请求的用户id
@property (nonatomic, strong) NSString *recordUid;

@end

@implementation THNMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordUid = [THNLoginManager sharedManager].userId;
    [self setupUI];
    [self thn_switchCurrentListDataWithType:THNHeaderViewSelectedTypeLiked];
    [self thn_openUpdateController];
}

#pragma mark - custom delegate
/**
 个人主页的操作事件
 */
- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type {
    switch (type) {
        case THNHeaderViewSelectedTypeLiked:
        case THNHeaderViewSelectedTypeCollect:
        case THNHeaderViewSelectedTypeStore: {
            [self thn_switchCurrentListDataWithType:type];
        }
            break;
            
        case THNHeaderViewSelectedTypeDynamic: {
            [self thn_openDynamicController];
        }
            break;
            
        case THNHeaderViewSelectedTypeActivity: {
            [self thn_openInvitationController];
        }
            break;
            
        case THNHeaderViewSelectedTypeOrder: {
            [self thn_openOrderController];
        }
            break;
            
        case THNHeaderViewSelectedTypeCoupon: {
            [self thn_openCouponController];
        }
            break;
            
        case THNHeaderViewSelectedTypeService: {
            [SVProgressHUD thn_showInfoWithStatus:@"客服"];
        }
            break;

        case THNHeaderViewSelectedTypeFans: {
            [self thn_openUserListControllerWithType:(THNUserListTypeFans)];
        }
            break;
            
        case THNHeaderViewSelectedTypeFollow: {
            [self thn_openUserListControllerWithType:(THNUserListTypeFollow)];
        }
            break;
    }
}

/**
 设置用户信息
 */
- (void)thn_selectedUserHeadImage {
    [self thn_openUserSettingController];
}

/**
 顶部菜单栏按钮
 */
- (void)didNavigationRightButtonOfIndex:(NSInteger)index {
    if (index == 0) {
        [self thn_openShareController];
        
    } else if (index == 1) {
        [self thn_openSettingController];
    }
}

/**
 切换“生活馆”/“个人中心”视图
 */
- (void)thn_didSelectedMenuButtonIndex:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
    }];
}

#pragma mark 数据刷新&加载
/**
 加载更多(设计馆列表)
 */
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    [self thn_setUserFollowedStoreDataWithPage:currentPage.integerValue];
}

/**
 刷新列表数据
 */
- (void)beginRefreshing {
    [self.tableView resetCurrentPageNumber];
    [self thn_refreshTableViewDataSourceWithType:_selectedDataType];
}

#pragma mark - private methods
/**
 切换当前加载的列表数据
 */
- (void)thn_switchCurrentListDataWithType:(THNHeaderViewSelectedType)type {
    _selectedDataType = type;
    
    [self thn_setLoadMoreDataFooter];
    [self thn_replaceCurrentListDataWithType:type];
    
    if (self.dataSections.count) {
        [self.tableView reloadData];
        
    } else {
        [self.tableView beginHeaderRefresh];
    }
}

/**
 刷新当前要显示的数据
 */
- (void)thn_refreshTableViewDataSourceWithType:(THNHeaderViewSelectedType)type {
    switch (type) {
        case THNHeaderViewSelectedTypeLiked: {
            [self thn_setUserLikedData];
        }
            break;
            
        case THNHeaderViewSelectedTypeCollect: {
            [self thn_setUserCollectData];
        }
            break;
            
        case THNHeaderViewSelectedTypeStore: {
            [self.storeSectionsArr removeAllObjects];
            [self thn_setUserFollowedStoreDataWithPage:1];
        }
            break;
            
        default:
            break;
    }
}

/**
 品牌馆列表可以"加载更多"
 */
- (void)thn_setLoadMoreDataFooter {
    if (_selectedDataType == THNHeaderViewSelectedTypeStore) {
        [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
        [self.tableView resetCurrentPageNumber];
        
    } else {
        [self.tableView removeFooterRefresh];
    }
}

/**
 替换当前加载的列表数据
 */
- (void)thn_replaceCurrentListDataWithType:(THNHeaderViewSelectedType)type {
    NSDictionary *sectionsDict = @{@(THNHeaderViewSelectedTypeLiked)    : self.likedSectionsArr,
                                   @(THNHeaderViewSelectedTypeCollect)  : self.collectSectionsArr,
                                   @(THNHeaderViewSelectedTypeStore)    : self.storeSectionsArr};
    
    self.dataSections = (NSMutableArray *)sectionsDict[@(type)];
}

/**
 设置列表的背景颜色
 */
- (void)thn_setTableViewBgColor {
    NSDictionary *bgColorDict = @{@(THNHeaderViewSelectedTypeLiked)    : @"#FFFFFF",
                                  @(THNHeaderViewSelectedTypeCollect)  : @"#FFFFFF",
                                  @(THNHeaderViewSelectedTypeStore)    : self.dataSections.count ? kColorBackground : kColorWhite};
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:bgColorDict[@(_selectedDataType)]];
}

/**
 加载个人主页视图
 */
- (void)thn_loadUserCenterTableView {
    [self thn_replaceCurrentListDataWithType:_selectedDataType];
    
    [self.footerView setSubHintLabelTextWithType:_selectedDataType];
    self.tableView.tableFooterView = !self.dataSections.count ? self.footerView : [UIView new];
    [self thn_setTableViewBgColor];
    
    [self.tableView reloadData];
    
    if ([THNLoginManager isTodayFirstLaunch]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self thn_showInvitationView];
        });
    }
}

/**
 切换用户重新加载数据
 */
- (void)thn_changeUserReloadData {
    if (![[THNLoginManager sharedManager].userId isEqualToString:self.recordUid]) {
        [self.dataSections removeAllObjects];
        [self.tableView reloadData];
        [self.tableView beginHeaderRefresh];
    }
}

/**
 显示邀请视图
 */
- (void)thn_showInvitationView {
    THNAdvertInviteView *inviteView = [[THNAdvertInviteView alloc] init];
    inviteView.advertInviteDoneBlock = ^{
        [self thn_openInvitationController];
    };
    
    [inviteView show];
}

#pragma mark - network
/**
 获取用户资料
 */
- (void)thn_getUserProfileData {
    [[THNLoginManager sharedManager] getUserProfile:^(THNResponse *data, NSError *error) {
        if (error) return;
    }];
}

/**
 获取个人中心信息
 */
- (void)thn_getUserCenterDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNUserManager getUserCenterWithUserId:@"" Completion:^(THNUserModel *model, NSError *error) {
            dispatch_group_leave(group);
            
            if (error) return;
            
            weakSelf.userModel = model;
            weakSelf.userName = model.username;
        }];
    });
}

/**
 获取商品数据
 */
- (void)thn_getUserCenterGoodsDataWithGroup:(dispatch_group_t)group type:(THNUserCenterGoodsType)type {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getUserCenterProductsWithType:type
                                                params:@{}
                                            completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
                                                dispatch_group_leave(group);
                                                [self.tableView endHeaderRefresh];
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
                                            }];
    });
}

/**
 获取橱窗数据
 */
- (void)thn_getUserCenterWindowDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNUserManager getUserLikedWindowWithParams:@{@"per_page": @(5)}
                                          completion:^(THNWindowModel *model, NSError *error) {
                                              dispatch_group_leave(group);
                                              [self.tableView endHeaderRefresh];
                                              if (error) return;
                                              
                                              weakSelf.windowArr = [NSArray arrayWithArray:model.shopWindows];
                                          }];
    });
}

/**
 获取关注的设计馆数据
 */
- (void)thn_getUserCenterFollowStoreDataWithGroup:(dispatch_group_t)group currentPage:(NSInteger)currentPage {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNUserManager getUserFollowStoreWithParams:@{@"page": @(currentPage)} completion:^(NSArray *storesData, NSError *error) {
            dispatch_group_leave(group);
            [self.tableView endHeaderRefresh];
            if (error) {
                [self.tableView endFooterRefreshAndCurrentPageChange:NO];
                return;
            };
            
            [self.tableView endFooterRefreshAndCurrentPageChange:YES];
            
            if (storesData.count) {
                for (NSDictionary *storeDict in storesData) {
                    THNStoreModel *model = [[THNStoreModel alloc] initWithDictionary:storeDict];
                    [weakSelf.storeArr addObject:model];
                }
                
            } else {
                [self.tableView noMoreData];
            }
        }];
    });
}

#pragma mark - set cell
/**
 用户信息
 */
- (void)thn_setUserCenterData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterDataWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self thn_setUserCenterHeaderView];
    });
}

/**
 喜欢的列表
 */
- (void)thn_setUserLikedData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterGoodsDataWithGroup:group type:(THNUserCenterGoodsTypeLikedGoods)];
    [self thn_getUserCenterWindowDataWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.likedSectionsArr removeAllObjects];
        [self thn_setUserCenterLikedGoodsCell];
        [self thn_setUserCenterLikedWindowCell];
        [self thn_loadUserCenterTableView];
    });
}

/**
 浏览的列表（原“收藏”）
 */
- (void)thn_setUserCollectData {
    dispatch_group_t group = dispatch_group_create();
    
    [self thn_getUserCenterGoodsDataWithGroup:group type:(THNUserCenterGoodsTypeBrowses)];
    [self thn_getUserCenterGoodsDataWithGroup:group type:(THNUserCenterGoodsTypeWishList)];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.collectSectionsArr removeAllObjects];
        [self thn_setUserCenterBrowesGoodsCell];
        [self thn_setUserCenterWishGoodsCell];
        [self thn_loadUserCenterTableView];
    });
}

/**
 关注的设计馆
 */
- (void)thn_setUserFollowedStoreDataWithPage:(NSInteger)page {
    dispatch_group_t group = dispatch_group_create();
    
    [self.storeArr removeAllObjects];
    [self thn_getUserCenterFollowStoreDataWithGroup:group currentPage:page];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self thn_setUserCenterFollowStoreCell];
        [self thn_loadUserCenterTableView];
    });
}

/**
 头部用户信息
 */
- (void)thn_setUserCenterHeaderView {
    [self.headerView thn_setUserInfoModel:self.userModel];
}

/**
 喜欢的商品
 */
- (void)thn_setUserCenterLikedGoodsCell {
    if (!self.likedGoodsArr.count) return;
    
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
    [self.likedSectionsArr addObject:sections];
}

/**
 喜欢的橱窗
 */
- (void)thn_setUserCenterLikedWindowCell {
    if (!self.windowArr.count) return;
    
    WEAKSELF;
    
    THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedWindow)
                                                 didSelectedWindow:^(THNWindowModelShopWindows *model) {
                                                     [weakSelf thn_openWindowDetailContollerWithModel:model];
                                                 }];
    cells.height = kCellHeightWindow;
    cells.windowDataArr = self.windowArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithHeaderTitle:kHeaderTitleWindow moreCompletion:^{
        [weakSelf thn_openLikedWindowController];
    }];
    sections.index = 1;
    sections.dataCells = [@[cells] mutableCopy];
    [self.likedSectionsArr addObject:sections];
}

/**
 最近浏览的商品
 */
- (void)thn_setUserCenterBrowesGoodsCell {
    if (!self.browsesGoodsArr.count) return;
    
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
    [self.collectSectionsArr addObject:sections];
}

/**
 心愿单的商品
 */
- (void)thn_setUserCenterWishGoodsCell {
    if (!self.wishGoodsArr.count) return;
    
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
    [self.collectSectionsArr addObject:sections];
}

/**
 关注的店铺
 */
- (void)thn_setUserCenterFollowStoreCell {
    if (!self.storeArr.count) return;
    
    WEAKSELF;
    
    for (THNStoreModel *model in self.storeArr) {
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
        [self.storeSectionsArr addObject:sections];
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
                                                                                                       userId:nil];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

/**
 打开喜欢橱窗视图
 */
- (void)thn_openLikedWindowController {
    THNWindowListViewController *likedWindowVC = [[THNWindowListViewController alloc] initWithUserId:nil];
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
 打开设置视图
 */
- (void)thn_openSettingController {
    THNSettingViewController *settingVC = [[THNSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

/**
 打开用户设置视图
 */
- (void)thn_openUserSettingController {
    THNSettingUserInfoViewController *setUserInfoVC = [[THNSettingUserInfoViewController alloc] init];
    [self.navigationController pushViewController:setUserInfoVC animated:YES];
}

/**
 打开分享视图
 */
- (void)thn_openShareController {
    if (!self.userModel.uid.length) return;

    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeNone)];
    [shareVC shareObjectWithTitle:kShareUserInfo(self.userModel.username)
                            descr:kShareDes
                        thumImage:self.userModel.avatar
                           webUrl:[NSString stringWithFormat:@"%@%@", kShareUserUrlPrefix, self.userModel.uid]];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

/**
 邀请好友得35元
 */
- (void)thn_openInvitationController {
    if (!self.userModel.uid) return;

    THNInvitationViewController *invitationVC = [[THNInvitationViewController alloc] initWithUserModel:self.userModel];
    [self.navigationController pushViewController:invitationVC animated:YES];
}

/**
 打开优惠券视图
 */
- (void)thn_openCouponController {
    THNMyCouponViewController *couponVC = [[THNMyCouponViewController alloc] init];
    [self.navigationController pushViewController:couponVC animated:YES];
}

/**
 打开订单视图
 */
- (void)thn_openOrderController {
    THNOrderViewController *order = [[THNOrderViewController alloc] init];
    [self.navigationController pushViewController:order animated:YES];
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
    THNUserListViewController *userListVC = [[THNUserListViewController alloc] initWithType:type requestId:@""];
    [self.navigationController pushViewController:userListVC animated:YES];
}

/**
 橱窗主页
 */
- (void)thn_openWindowDetailContollerWithModel:(THNWindowModelShopWindows *)model {
    if (!model.rid) return;
    
    THNShopWindowModel *shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:[model toDictionary]];
    
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc] init];
    shopWindowDetail.shopWindowModel = shopWindowModel;
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

/**
 打开版本更新视图
 */
- (void)thn_openUpdateController {
    THNAdvertUpdateViewController *updateVC = [[THNAdvertUpdateViewController alloc] init];
    updateVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:updateVC animated:NO completion:nil];
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

#pragma mark - setup UI
- (void)setupUI {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView setRefreshHeaderWithClass:nil beginRefresh:NO animation:NO delegate:self];
    
    [self.view addSubview:self.menuView];
    [self.containerView addSubview:self.tableView];
    [self addChildViewController:self.lifeStoreVC];
    [self.containerView addSubview:self.lifeStoreVC.view];
    [self.view addSubview:self.containerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    
    if (![THNLoginManager isLogin]) return;
    
    [self thn_uploadViewFrame];
    [self thn_setUserCenterData];
    [self thn_getUserProfileData];
    [self thn_changeUserReloadData];
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamedArray:@[@"icon_share",
                                                                        @"icon_setting_gray"]];
}

/**
 显示导航栏标题
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 80) {
        self.navigationBarView.title = self.userName;
        
    } else if (scrollView.contentOffset.y < 80) {
        self.navigationBarView.title = @"";
    }
}

/**
 是否拥有“生活馆”，更新视图
 */
- (void)thn_uploadViewFrame {
    BOOL hasLifeStore = [THNLoginManager sharedManager].openingUser;
    
    self.menuView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44);
    self.menuView.hidden = !hasLifeStore;
    
    CGFloat tabbarH = kDeviceiPhoneX ? 83 : 49;
    CGFloat navbarH = kDeviceiPhoneX ? 88 : 64;
    CGFloat menuH = hasLifeStore ? 44 : 0;
    CGFloat originY = navbarH + menuH;
    
    CGFloat containerH = SCREEN_HEIGHT - originY - tabbarH;
    CGRect containerFrame = self.containerView.frame;
    containerFrame = CGRectMake(0, originY, SCREEN_WIDTH, containerH);
    self.containerView.frame = containerFrame;
    
    NSInteger pageCount = hasLifeStore ? 2 : 1;
    self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, 0);
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, containerH);
    self.lifeStoreVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, containerH);
}

#pragma mark - getters and setters
- (THNMyCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNMyCenterHeaderView alloc] initWithType:(THNMyCenterHeaderViewTypeDefault)];
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
        _menuView = [[THNMyCenterMenuView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        _menuView.hidden = YES;
    }
    return _menuView;
}

- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor whiteColor];
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

- (NSMutableArray *)storeArr {
    if (!_storeArr) {
        _storeArr = [NSMutableArray array];
    }
    return _storeArr;
}

- (NSMutableArray *)likedSectionsArr {
    if (!_likedSectionsArr) {
        _likedSectionsArr = [NSMutableArray array];
    }
    return _likedSectionsArr;
}

- (NSMutableArray *)collectSectionsArr {
    if (!_collectSectionsArr) {
        _collectSectionsArr = [NSMutableArray array];
    }
    return _collectSectionsArr;
}

- (NSMutableArray *)storeSectionsArr {
    if (!_storeSectionsArr) {
        _storeSectionsArr = [NSMutableArray array];
    }
    return _storeSectionsArr;
}

@end
