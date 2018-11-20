//
//  THNGoodsInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsInfoViewController.h"
#import "NSString+Helper.h"
#import "YYLabel+Helper.h"
#import <TYAlertController/UIView+TYAlertView.h>
#import "THNGoodsManager.h"
#import "THNLoginManager.h"
#import "THNImagesView.h"
#import "THNGoodsFunctionView.h"
#import "THNGoodsSkuViewController.h"
#import "THNGoodsImagesViewController.h"
#import "THNGoodsDescribeViewController.h"
#import "THNUserListViewController.h"
#import "THNGoodsTitleTableViewCell.h"
#import "THNGoodsTagTableViewCell.h"
#import "THNGoodsActionTableViewCell.h"
#import "THNGoodsDirectTableViewCell.h"
#import "THNGoodsUserTableViewCell.h"
#import "THNGoodsDescribeTableViewCell.h"
#import "THNGoodsCheckTableViewCell.h"
#import "THNGoodsStoreTableViewCell.h"
#import "THNLikedGoodsTableViewCell.h"
#import "THNGoodsHeaderTableViewCell.h"
#import "THNGoodsContactTableViewCell.h"
#import "THNDealContentTableViewCell.h"
#import "THNGoodsCouponTableViewCell.h"
#import "THNCartViewController.h"
#import "THNBrandHallViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNShareViewController.h"
#import "THNUserCenterViewController.h"
#import "THNShareImageViewController.h"
#import "THNCouponDetailView.h"
#import "UITableViewCell+DealContent.h"

static NSInteger const kFooterHeight = 18;
///
static NSString *const kURLNotLoginCoupon   = @"/market/not_login_coupons";
static NSString *const kURLLoginCoupon      = @"/market/user_master_coupons";
static NSString *const kKeyStoreRid         = @"store_rid";

@interface THNGoodsInfoViewController () <THNGoodsFunctionViewDelegate, THNImagesViewDelegate, THNGoodsUserTableViewCellDelegate> {
    UIStatusBarStyle _statusBarStyle;
}

/// 商品的 id
@property (nonatomic, strong) NSString *goodsId;
/// 商品 model
@property (nonatomic, strong) THNGoodsModel *goodsModel;
/// 店铺 model
@property (nonatomic, strong) THNStoreModel *storeModel;
/// 运费 model
@property (nonatomic, strong) THNFreightModel *freightModel;
/// sku model
@property (nonatomic, strong) THNSkuModel *skuModel;
/// 喜欢商品的用户
@property (nonatomic, strong) NSArray *likedUserArr;
/// 相似的商品
@property (nonatomic, strong) NSArray *similarGoodsArr;
@property (nonatomic, strong) NSArray *fullReductions;
@property (nonatomic, strong) NSArray *allCouponsArr;
@property (nonatomic, strong) NSArray *loginCoupons;
@property (nonatomic, strong) NSArray *noLoginCoupons;
/// 图片列表
@property (nonatomic, strong) THNImagesView *imagesView;
/// 底部功能视图
@property (nonatomic, strong) THNGoodsFunctionView *functionView;
/// 优惠券详情视图
@property (nonatomic, strong) THNCouponDetailView *couponDetailView;
// 满减信息
@property (nonatomic, strong) NSMutableString *mutableString;

@end

@implementation THNGoodsInfoViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (instancetype)initWithGoodsId:(NSString *)idx {
    self = [super init];
    if (self) {
        self.goodsId = idx;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_getGoodsInfoDataWithGoodsId:self.goodsId];
}

#pragma mark - network
/**
 获取商品详情数据
 */
- (void)thn_getGoodsInfoDataWithGoodsId:(NSString *)goodsId {
    if (!goodsId.length) return;
    
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNGoodsManager getProductInfoWithId:self.goodsId completion:^(THNGoodsModel *model, NSError *error) {
        if (error) return;
    
        weakSelf.goodsModel = model;
        [weakSelf.functionView thn_setGoodsModel:model];
        [weakSelf thn_setGoodsInfoIsSoldOut:model.status != 1];
        [weakSelf thn_setGoodsInfoImageAssets:model.assets];
        
        dispatch_group_t group = dispatch_group_create();
        
        [weakSelf thn_getGoodsInfoSkuDataWithGroup:group];
        [weakSelf thn_getGoodsInfoLikedUserDataWithGroup:group];
        [weakSelf thn_getGoodsInfoStoreCouponDataWithGroup:group];
        if ([THNLoginManager isLogin]) {
            [weakSelf thn_getUserMasterCouponsDataWithGroup:group];
        }
        [weakSelf thn_getGoodsInfoStoreDataWithGroup:group];
        [weakSelf thn_getGoodsInfoFreightDataWithGroup:group];
        [weakSelf thn_getGoodsInfoSimilarGoodsDataWithGroup:group];

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [weakSelf thn_setGoodsInfoCell];
            [weakSelf thn_reloadGoodsInfoSections];
            [SVProgressHUD dismiss];
        });
    }];
}

/**
 购物车商品数量
 */
- (void)thn_getCartGoodsCount {
    if (![THNLoginManager isLogin]) return;
    
    WEAKSELF;
    
    [THNGoodsManager getCartGoodsCountCompletion:^(NSInteger goodsCount, NSError *error) {
        [weakSelf.functionView thn_setCartGoodsCount:error ? 0 : goodsCount];
    }];
}

/**
 设置商品图片
 */
- (void)thn_setGoodsInfoImageAssets:(NSArray *)assets {
    [self.imagesView thn_setImageAssets:assets];
    
    self.tableView.tableHeaderView = self.imagesView;
}

/**
 获取商品 SKU 数据
 */
- (void)thn_getGoodsInfoSkuDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getProductSkusInfoWithId:self.goodsId
                                           params:@{}
                                       completion:^(THNSkuModel *model, NSError *error) {
                                           dispatch_group_leave(group);
                                           if (error) return;
                                           
                                           weakSelf.skuModel = model;
                                       }];
    });
}

/**
 获取相似的商品
 */
- (void)thn_getGoodsInfoSimilarGoodsDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getSimilarGoodsWithGoodsId:self.goodsId
                                         completion:^(NSArray *goodsData, NSError *error) {
                                             dispatch_group_leave(group);
                                             if (error) return;
            
                                             weakSelf.similarGoodsArr = [NSArray arrayWithArray:goodsData];
                                         }];
    });
}

/**
 获取喜欢商品的用户
 */
- (void)thn_getGoodsInfoLikedUserDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    NSNumber *userCount = kDeviceiPhone5 ? @(10) : @(12);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getLikeGoodsUserDataWithGoodsId:self.goodsId
                                                  params:@{@"per_page": userCount}
                                              completion:^(NSArray *userData, NSError *error) {
                                                  dispatch_group_leave(group);
                                                  if (error) return;
                                                  
                                                  weakSelf.likedUserArr = [NSArray arrayWithArray:userData];
                                              }];
    });
}

/**
 获取发货时间信息
 */
- (void)thn_getGoodsInfoFreightDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getFreightTemplateDataWithRid:self.goodsModel.fid
                                               goodsId:self.goodsId
                                               storeId:self.goodsModel.storeRid
                                            completion:^(THNFreightModel *model, NSError *error) {
                                                dispatch_group_leave(group);
                                                if (error) return;
                                                
                                                weakSelf.freightModel = model;
                                            }];
    });
}

/**
 获取店铺信息
 */
- (void)thn_getGoodsInfoStoreDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [THNGoodsManager getOfficialStoreInfoWithId:self.goodsModel.storeRid
                                         completion:^(THNStoreModel *model, NSError *error) {
                                             dispatch_group_leave(group);
                                             if (error) return;
                                             
                                             weakSelf.storeModel = model;
                                         }];
    });
}

//已登录用户获取商家优惠券列表
- (void)thn_getUserMasterCouponsDataWithGroup:(dispatch_group_t)group  {
    WEAKSELF;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"store_rid"] = self.goodsModel.storeRid;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        THNRequest *request = [THNAPI getWithUrlString:kURLLoginCoupon requestDictionary:params delegate:nil];
        [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
            dispatch_group_leave(group);
            
            if (!result.success) {
                [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
                return;
            }
            weakSelf.loginCoupons = result.data[@"coupons"];
            
        } failure:^(THNRequest *request, NSError *error) {
            dispatch_group_leave(group);
        }];
    });
}

/**
 获取优惠券信息
 */
- (void)thn_getGoodsInfoStoreCouponDataWithGroup:(dispatch_group_t)group {
    WEAKSELF;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        THNRequest *request = [THNAPI getWithUrlString:kURLNotLoginCoupon
                                     requestDictionary:@{kKeyStoreRid: self.goodsModel.storeRid}
                                              delegate:nil];
        [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
            dispatch_group_leave(group);
            if (!result.isSuccess) {
                [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
                return ;
            }
            
            weakSelf.allCouponsArr = [NSArray arrayWithArray:result.data[@"coupons"]];
            
            // type = 3  满减   type = 1 或者 2  为优惠券
            NSPredicate *fullReductionPredicate = [NSPredicate predicateWithFormat:@"type = 3"];
            NSPredicate *couponPredicate = [NSPredicate predicateWithFormat:@"type = 1 || type = 2"];
            weakSelf.fullReductions = [weakSelf.allCouponsArr  filteredArrayUsingPredicate:fullReductionPredicate];
            
            if (![THNLoginManager isLogin]) {
                weakSelf.noLoginCoupons = [weakSelf.allCouponsArr  filteredArrayUsingPredicate:couponPredicate];
            }
            
        } failure:^(THNRequest *request, NSError *error) {
            dispatch_group_leave(group);
            [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        }];
    });
}

#pragma mark - set cell
- (void)thn_setGoodsInfoCell {
    [self thn_setGoodsInfoTitleCell];
    [self thn_setGoodsInfoTagsCell];
    [self thn_setGoodsInfoActionCell];
    [self thn_setGoodsInfoCouponCell];
    [self thn_setGoodsInfoLikedUserCell];
    [self thn_setGoodsInfoDirectSelectCell];
    [self thn_setGoodsInfoDescribeCell];
    [self thn_setGoodsInfoStoreCell];
    [self thn_setGoodsInfoSimilarGoodsCell];
    [self thn_setGoodsInfoDealContentCell];
}

/**
 设置商品标题、价格等基本信息
 */
- (void)thn_setGoodsInfoTitleCell {
    THNGoodsTableViewCells *titleCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTitle)];
    titleCells.height = [self thn_getGoodsInfoTitleHeight] + 60;
    titleCells.goodsModel = self.goodsModel;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[titleCells] mutableCopy]];
    sections.index = 0;
    
    [self.dataSections addObject:sections];
}

/**
 设置商品标签
 */
- (void)thn_setGoodsInfoTagsCell {
    THNGoodsTableViewCells *tagCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTag)];
    tagCells.height = self.goodsModel.labels.count ? 32 : 0.01;
    tagCells.goodsModel = self.goodsModel;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[tagCells] mutableCopy]];
    sections.index = 1;
    
    [self.dataSections addObject:sections];
}

/**
 商品操作的按钮
 */
- (void)thn_setGoodsInfoActionCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *actionCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeAction) didSelectedItem:^(NSString *rid) {
        [weakSelf.dataSections removeObjectAtIndex:5];
        
        dispatch_group_t group = dispatch_group_create();
        [weakSelf thn_getGoodsInfoLikedUserDataWithGroup:group];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [weakSelf thn_setGoodsInfoLikedUserCell];
            [weakSelf thn_reloadGoodsInfoSections];
        });
        
    }];
    actionCells.height = 49;
    actionCells.goodsModel = self.goodsModel;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[actionCells] mutableCopy]];
    sections.index = 2;
    
    [self.dataSections addObject:sections];
}

/**
 商品优惠券视图
 */
- (void)thn_setGoodsInfoCouponCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *couponCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeCoupon) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openCouponView];
    }];
    couponCells.height = self.allCouponsArr.count ? [self thn_getGoodsInfoCouponHeight] : 0.01;
    couponCells.couponData = self.allCouponsArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[couponCells] mutableCopy]];
    sections.index = 3;
    
    [self.dataSections addObject:sections];
}

/**
 设置“直接选择尺码”
 */
- (void)thn_setGoodsInfoDirectSelectCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *directCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeChoose) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsSkuController];
    }];
    directCells.height = self.goodsModel.isCustomMade ? 80 : 55;
    directCells.goodsModel = self.goodsModel;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[directCells] mutableCopy]];
    sections.index = 4;
    
    [self.dataSections addObject:sections];
}

/**
 喜欢商品的用户
 */
- (void)thn_setGoodsInfoLikedUserCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *userCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeUser) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openLikedUserController];
    }];
    userCells.height = self.likedUserArr.count == 0 ? 0.01 : 50;
    userCells.likeUserData = self.likedUserArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[userCells] mutableCopy]];
    sections.index = 5;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 设置商品描述
 */
- (void)thn_setGoodsInfoDescribeCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *desCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    desCells.height = [self thn_getGoodsInfoFeaturesHeight];
    desCells.goodsModel = self.goodsModel;
    
    THNGoodsTableViewCells *salesReturnCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    salesReturnCells.height = 130;
    salesReturnCells.goodsModel = self.goodsModel;
    
    THNGoodsTableViewCells *timeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    timeCells.height = 80;
    timeCells.freightModel = self.freightModel;
    
    THNGoodsTableViewCells *dispatchCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    dispatchCells.height = 80;
    dispatchCells.storeModel = self.storeModel;
    
    THNGoodsTableViewCells *checkCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsDescribeController];
    }];
    checkCells.height = 56;
    
    NSMutableArray *cellArr = [NSMutableArray arrayWithArray:@[desCells, dispatchCells, timeCells, salesReturnCells, checkCells]];
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:cellArr];
    sections.index = 6;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 设置店铺信息
 */
- (void)thn_setGoodsInfoStoreCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *storeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openBrandHallControllerWithRid:rid];
    }];
    storeCells.height = 85;
    storeCells.storeModel = self.storeModel;
    
    THNGoodsTableViewCells *storeGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:rid];
    }];
    storeGoodsCells.height = 105;
    storeGoodsCells.storeGoodsData = self.storeModel.products;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, storeGoodsCells] mutableCopy]];
    sections.index = 7;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 设置相似商品
 */
- (void)thn_setGoodsInfoSimilarGoodsCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *headerCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeSimilar)];
    headerCells.height = 56;
    
    THNGoodsTableViewCells *similarGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeSimilar) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:rid];
    }];
    similarGoodsCells.height = 105;
    similarGoodsCells.similarGoodsData = self.similarGoodsArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[headerCells, similarGoodsCells] mutableCopy]];
    sections.index = 8;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 设置商品详情内容
 */
- (void)thn_setGoodsInfoDealContentCell {
    THNGoodsTableViewCells *headerCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeContent)];
    headerCells.height = 56;
    
    THNGoodsTableViewCells *contentCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeContent)];
    contentCells.height = [UITableViewCell heightWithDaelContentData:self.goodsModel.dealContent type:(THNDealContentTypeGoodsInfo)];
    contentCells.goodsModel = self.goodsModel;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[headerCells, contentCells] mutableCopy]];
    sections.index = 9;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

#pragma mark - custom delegate
- (void)thn_openGoodsCart {
    THNCartViewController *cartVC = [[THNCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)thn_openGoodsSkuWithType:(THNGoodsButtonType)type {
    if (!self.goodsModel && !self.skuModel) return;
    
    if (type == THNGoodsButtonTypeSell) {
        [self thn_openGoodsShareImageController];
        
    } else {
        [self thn_openGoodsSkuControllerWithType:type];
    }
}

- (void)thn_didSelectImageAtIndex:(NSInteger)index {
    [self thn_openGoodsImageControllerWithIndex:index];
}

- (void)thn_didSelectedGoodsLikedUser:(NSString *)userId {
    [self thn_openUserCenterControllerWithUserId:userId];
}

#pragma mark - private methods
/**
 刷新“组”数据，视图
 */
- (void)thn_reloadGoodsInfoSections {
    [self thn_sortDataSecitons];
    
    [self.tableView reloadData];
}

/**
 商品已卖完/下架
 */
- (void)thn_setGoodsInfoIsSoldOut:(BOOL)soldOut {
    if (!soldOut) return;
    
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"很抱歉" message:@"该商品已下架"];
    alertView.layer.cornerRadius = 8;
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:kColorMain];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确认"
                                                  style:TYAlertActionStyleDefault
                                                handler:^(TYAlertAction *action) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView
                                                                          preferredStyle:TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 获取商品标题文字
 */
- (NSAttributedString *)thn_getGoodsInfoTitle {
    THNTableViewSections *sections = self.dataSections[0];
    THNGoodsTableViewCells *goodsCells = sections.dataCells[0];
    
    return goodsCells.titleCell.titleLabel.attributedText;
}

/**
 获取商品标题文字的高度
 */
- (CGFloat)thn_getGoodsInfoTitleHeight {
    return [YYLabel thn_getYYLabelTextLayoutSizeWithText:self.goodsModel.name
                                                fontSize:16
                                             lineSpacing:6
                                          fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
}

/**
 获取商品描述的高度
 */
- (CGFloat)thn_getGoodsInfoFeaturesHeight {
    CGFloat contentH = 50.0;
    
    contentH += self.goodsModel.isCustomService ? 30 : 0;
    contentH += self.goodsModel.materialName.length ? 30 : 0;
    contentH += self.goodsModel.stockCount < 10 ? 30 : 0;
    
    BOOL isHaveFeatures = self.goodsModel.features.length > 0;
    CGFloat featuresH = self.goodsModel.features.length > 24 ? 50 : 30;
    contentH += isHaveFeatures ? featuresH : 0;
    
    return contentH == 50.0 ? 0.01 : contentH;
}

/**
 获取优惠券的高度
 */
- (CGFloat)thn_getGoodsInfoCouponHeight {
    CGFloat cellHeight = 80;
    
    // 满减活动
    cellHeight -= !self.fullReductions.count ? 19 : 0;
    
    // 可领取红包
    cellHeight -= !self.allCouponsArr.count ? 26 : 0;
    
    return cellHeight;
}

#pragma mark - open other controller
/**
 打开卖货分享图片视图
 */
- (void)thn_openGoodsShareImageController {
    if (!self.goodsId.length) return;
    
    THNShareImageViewController *shareImageVC = [[THNShareImageViewController alloc] initWithType:(THNSharePosterTypeGoods)
                                                                                        requestId:self.goodsId];
    [self presentViewController:shareImageVC animated:NO completion:nil];
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
 打开商品描述视图
 */
- (void)thn_openGoodsDescribeController {
    THNGoodsDescribeViewController *describeVC = [[THNGoodsDescribeViewController alloc] initWithGoodsModel:self.goodsModel
                                                                                                 storeModel:self.storeModel
                                                                                               freightModel:self.freightModel];
    [self presentViewController:describeVC animated:YES completion:nil];
}

/**
 打开喜欢商品的用户列表
 */
- (void)thn_openLikedUserController {
    THNUserListViewController *userListVC = [[THNUserListViewController alloc] initWithType:(THNUserListTypeLikeGoods)
                                                                                  requestId:self.goodsId];
    [self.navigationController pushViewController:userListVC animated:YES];
}

/**
 打开用户中心
 */
- (void)thn_openUserCenterControllerWithUserId:(NSString *)userId {
    if ([[THNLoginManager sharedManager].userId isEqualToString:userId]) {
        return;
    }
    
    THNUserCenterViewController *userCenterVC = [[THNUserCenterViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:userCenterVC animated:YES];
}

/**
 打开品牌馆视图
 */
- (void)thn_openBrandHallControllerWithRid:(NSString *)rid {
    THNBrandHallViewController *brandHall = [[THNBrandHallViewController alloc] init];
    brandHall.rid = rid;
    [self.navigationController pushViewController:brandHall animated:YES];
}

/**
 查看商品图片
 */
- (void)thn_openGoodsImageControllerWithIndex:(NSInteger)index {
    THNGoodsImagesViewController *goodsImageVC = [[THNGoodsImagesViewController alloc] initWithGoodsModel:self.goodsModel
                                                                                                 skuModel:self.skuModel];
    [goodsImageVC thn_scrollContentWithIndex:index];
    [goodsImageVC thn_setSkuFunctionViewType:self.functionView.type
                                  handleType:self.goodsModel.isCustomMade ? THNGoodsButtonTypeCustom : THNGoodsButtonTypeBuy
                       titleAttributedString:[self thn_getGoodsInfoTitle]];
    goodsImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:goodsImageVC animated:NO completion:nil];
}

/**
 打开商品 SKU 视图
 */
- (void)thn_openGoodsSkuController {
    if (![THNLoginManager isLogin]) {
        [self thn_openUserLoginController];
        return;
    }
    
    THNGoodsSkuViewController *goodsSkuVC = [[THNGoodsSkuViewController alloc] initWithSkuModel:self.skuModel
                                                                                     goodsModel:self.goodsModel
                                                                                       viewType:(THNGoodsSkuTypeDirectSelect)];
    goodsSkuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    goodsSkuVC.functionType = self.functionView.type;
    [self presentViewController:goodsSkuVC animated:NO completion:nil];
}

- (void)thn_openGoodsSkuControllerWithType:(THNGoodsButtonType)type {
    WEAKSELF;
    
    THNGoodsSkuViewController *goodsSkuVC = [[THNGoodsSkuViewController alloc] initWithSkuModel:self.skuModel
                                                                                     goodsModel:self.goodsModel
                                                                                       viewType:(THNGoodsSkuTypeDefault)];
    goodsSkuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    goodsSkuVC.functionType = self.functionView.type;
    goodsSkuVC.handleType = type;
    goodsSkuVC.selectGoodsAddCartCompleted = ^(NSString *skuId) {
        [SVProgressHUD thn_showSuccessWithStatus:@"已添加到购物车"];
        [weakSelf thn_getCartGoodsCount];
    };
    [self presentViewController:goodsSkuVC animated:NO completion:nil];
}

/**
 打开商品详情视图
 */
- (void)thn_openGoodsInfoControllerWithGoodsId:(NSString *)goodsId {
    THNGoodsInfoViewController *goodsInfoVC = [[THNGoodsInfoViewController alloc] initWithGoodsId:goodsId];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

/**
 打开登录视图
 */
- (void)thn_openUserLoginController {
    THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
    THNBaseNavigationController *loginNavController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
    [self presentViewController:loginNavController animated:YES completion:nil];
}

/**
 优惠券视图
 */
- (void)thn_openCouponView {
    if (![THNLoginManager isLogin]) {
        [self thn_openUserLoginController];
        return;
    }
    
    self.mutableString = nil;
    for (NSDictionary *dict in self.fullReductions) {
        NSString *fullReductionStr = [NSString stringWithFormat:@"  %@",dict[@"type_text"]];
        [self.mutableString appendString:fullReductionStr];
    }
    
    [self.couponDetailView layoutCouponDetailView:self.mutableString
                                 withLoginCoupons:self.loginCoupons
                                withNologinCoupos:self.noLoginCoupons];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.couponDetailView.frame = window.bounds;
    [window addSubview:self.couponDetailView];
}

#pragma mark - tableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNGoodsTableViewCells *goodsCells = sections.dataCells[indexPath.row];
    
    switch (goodsCells.cellType) {
        case THNGoodsTableViewCellTypeTitle: {
            THNGoodsTitleTableViewCell *titleCell = [THNGoodsTitleTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.titleCell = titleCell;
            titleCell.baseCell = goodsCells;
            [titleCell thn_setGoodsTitleWithModel:goodsCells.goodsModel];
            
            return titleCell;
        }
            break;
        
        case THNGoodsTableViewCellTypeTag: {
            THNGoodsTagTableViewCell *tagCell = [THNGoodsTagTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.tagCell = tagCell;
            tagCell.baseCell = goodsCells;
            [tagCell thn_setGoodsTagWithTags:goodsCells.goodsModel.labels];
            
            return tagCell;
        }
            
        case THNGoodsTableViewCellTypeAction: {
            THNGoodsActionTableViewCell *actionCell = [THNGoodsActionTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.actionCell = actionCell;
            actionCell.baseCell = goodsCells;
            [actionCell thn_setActionButtonWithGoodsModel:goodsCells.goodsModel canPutaway:NO];
            
            return actionCell;
        }
            
        case THNGoodsTableViewCellTypeCoupon: {
            THNGoodsCouponTableViewCell *couponCell = [THNGoodsCouponTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.couponCell = couponCell;
            couponCell.baseCell = goodsCells;
            [couponCell thn_setCouponData:goodsCells.couponData];
            
            return couponCell;
        }
            
        case THNGoodsTableViewCellTypeChoose: {
            THNGoodsDirectTableViewCell *directCell = [THNGoodsDirectTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.directCell = directCell;
            directCell.baseCell = goodsCells;
            [directCell thn_setCustomNumberOfDays:goodsCells.goodsModel.madeCycle isIncludeHolidays:goodsCells.goodsModel.isMadeHoliday];
            
            return directCell;
        }
            
        case THNGoodsTableViewCellTypeUser: {
            THNGoodsUserTableViewCell *userCell = [THNGoodsUserTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.userCell = userCell;
            userCell.baseCell = goodsCells;
            userCell.delegate = self;
            [userCell thn_setLikedUserData:goodsCells.likeUserData];
            
            return userCell;
        }
            
        case THNGoodsTableViewCellTypeDescribe: {
            if (indexPath.row == 0) {
                THNGoodsDescribeTableViewCell *desInfoCell = [THNGoodsDescribeTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.desInfoCell = desInfoCell;
                desInfoCell.baseCell = goodsCells;
                [desInfoCell thn_setDescribeType:(THNGoodsDescribeCellTypeDes) goodsModel:goodsCells.goodsModel showIcon:NO];
                
                return desInfoCell;
                
            } else if (indexPath.row == 1) {
                THNGoodsDescribeTableViewCell *dispatchCell = [THNGoodsDescribeTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.dispatchCell = dispatchCell;
                dispatchCell.baseCell = goodsCells;
                [dispatchCell thn_setDescribeType:(THNGoodsDescribeCellTypeDispatch) storeModel:goodsCells.storeModel];
                
                return dispatchCell;
                
            } else if (indexPath.row == 2) {
                THNGoodsDescribeTableViewCell *timeCell = [THNGoodsDescribeTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.timeCell = timeCell;
                timeCell.baseCell = goodsCells;
                [timeCell thn_setDescribeType:(THNGoodsDescribeCellTypeTime) freightModel:goodsCells.freightModel];
                
                return timeCell;
                
            } else if (indexPath.row == 3) {
                THNGoodsDescribeTableViewCell *salesReturnCell = [THNGoodsDescribeTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.salesReturnCell = salesReturnCell;
                salesReturnCell.baseCell = goodsCells;
                [salesReturnCell thn_hiddenLine];
                [salesReturnCell thn_setDescribeType:(THNGoodsDescribeCellTypeSalesReturn) goodsModel:goodsCells.goodsModel showIcon:NO];
                
                return salesReturnCell;
                
            } else if (indexPath.row == 4) {
                THNGoodsCheckTableViewCell *cheakDesCell = [THNGoodsCheckTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.cheakDesCell = cheakDesCell;
                cheakDesCell.baseCell = goodsCells;
                [cheakDesCell thn_setGoodsCheckCellType:(THNGoodsCheckTableViewCellTypeAllDescribe)];
                
                return cheakDesCell;
            }
        }
            
        case THNGoodsTableViewCellTypeStore: {
            if (indexPath.row == 0) {
                THNGoodsStoreTableViewCell *storeCell = [THNGoodsStoreTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.storeCell = storeCell;
                storeCell.baseCell = goodsCells;
                [storeCell thn_setGoodsStoreInfoWithModel:goodsCells.storeModel];
                
                return storeCell;
                
            } else if (indexPath.row == 1) {
                THNLikedGoodsTableViewCell *storeGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
                goodsCells.storeGoodsCell = storeGoodsCell;
                storeGoodsCell.goodsCell = goodsCells;
                storeGoodsCell.itemWidth = 90;
                storeGoodsCell.goodsCellType = THNGoodsListCellViewTypeGoodsInfoStore;
                [storeGoodsCell thn_setLikedGoodsData:goodsCells.storeGoodsData];
                
                return storeGoodsCell;
            }
        }
            
        case THNGoodsTableViewCellTypeSimilar: {
            if (indexPath.row == 0) {
                THNGoodsHeaderTableViewCell *headerCell = [THNGoodsHeaderTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.similarHeaderCell = headerCell;
                headerCell.baseCell = goodsCells;
                [headerCell thn_setHeaderCellType:(THNGoodsHeaderCellTypeSimilar)];
                
                return headerCell;
                
            } else if (indexPath.row == 1) {
                THNLikedGoodsTableViewCell *similarGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
                goodsCells.similarGoodsCell = similarGoodsCell;
                similarGoodsCell.goodsCell = goodsCells;
                similarGoodsCell.itemWidth = 90;
                similarGoodsCell.goodsCellType = THNGoodsListCellViewTypeSimilarGoods;
                [similarGoodsCell thn_setLikedGoodsData:goodsCells.similarGoodsData];
                
                return similarGoodsCell;
            }
        }
            
        case THNGoodsTableViewCellTypeContent: {
            if (indexPath.row == 0) {
                THNGoodsHeaderTableViewCell *headerCell = [THNGoodsHeaderTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.infoHeaderCell = headerCell;
                headerCell.baseCell = goodsCells;
                [headerCell thn_setHeaderCellType:(THNGoodsHeaderCellTypeGoodsInfo)];
                
                return headerCell;
                
            } else if (indexPath.row == 1) {
                THNDealContentTableViewCell *contentCell = [THNDealContentTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.contentCell = contentCell;
                contentCell.baseCell = goodsCells;
                [contentCell thn_setDealContentData:goodsCells.goodsModel.dealContent type:(THNDealContentTypeGoodsInfo)];
                
                return contentCell;
            }
        }
            
        default:
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *secitons = self.dataSections[indexPath.section];
    THNGoodsTableViewCells *goodsCells = secitons.dataCells[indexPath.row];
    
    return goodsCells.height;
}

#pragma mark - setup UI
- (void)setupUI {
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 55, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.separatorStyle = THNTableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.functionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    
    if ([THNLoginManager isLogin]) {
        [self thn_getCartGoodsCount];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= (SCREEN_WIDTH - 44)) {
        [self thn_showNavigationBarView:YES];
        
    } else if (scrollView.contentOffset.y < (SCREEN_WIDTH - 44)) {
        [self thn_showNavigationBarView:NO];
    }
}

- (void)thn_showNavigationBarView:(BOOL)show {
    NSString *iconName = show ? @"icon_share_gray" : @"icon_share_white";
    NSString *title = show ? self.goodsModel.name : @"";
    
    self.navigationBarView.transparent = !show;
    self.navigationBarView.title = title;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:iconName];
    
    _statusBarStyle = show ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setNavigationBar {
    [self.navigationBarView setNavigationTransparent:YES showShadow:YES];
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_white"];
    
    WEAKSELF;
    
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf thn_openGoodsShareImageController];
    }];
}

#pragma mark - getters and setters
- (THNImagesView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[THNImagesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)
                                                fullScreen:NO];
        _imagesView.delegate = self;
    }
    return _imagesView;
}

- (THNGoodsFunctionView *)functionView {
    if (!_functionView) {
        CGFloat viewH = kDeviceiPhoneX ? 80 : 50;
        _functionView = [[THNGoodsFunctionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewH, SCREEN_WIDTH, viewH)
                                                               type:(THNGoodsFunctionViewTypeDefault)];
        _functionView.drawLine = YES;
        _functionView.delegate = self;
    }
    return _functionView;
}

- (THNCouponDetailView *)couponDetailView {
    if (!_couponDetailView) {
        _couponDetailView = [THNCouponDetailView viewFromXib];
    }
    return _couponDetailView;
}

- (NSMutableString *)mutableString {
    if (!_mutableString) {
        _mutableString = [NSMutableString string];
    }
    return _mutableString;
}

@end
