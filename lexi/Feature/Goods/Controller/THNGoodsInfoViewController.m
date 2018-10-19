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
#import "THNGoodsContentTableViewCell.h"
#import "THNCartViewController.h"
#import "THNBrandHallViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNShareViewController.h"

static NSInteger const kFooterHeight = 18;

@interface THNGoodsInfoViewController () <THNGoodsFunctionViewDelegate, THNImagesViewDelegate> {
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
/// 详情的高度
@property (nonatomic, assign) CGFloat dealContentH;
/// 图片列表
@property (nonatomic, strong) THNImagesView *imagesView;
/// 底部功能视图
@property (nonatomic, strong) THNGoodsFunctionView *functionView;

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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD thn_showWithStatus:nil maskType:(SVProgressHUDMaskTypeClear)];
    });
    
    WEAKSELF;
    
    [THNGoodsManager getProductInfoWithId:self.goodsId completion:^(THNGoodsModel *model, NSError *error) {
        if (error) return;
    
        weakSelf.goodsModel = model;
        [weakSelf thn_goodsIsSoldOut:model.status != 1];
        [weakSelf.functionView thn_setGoodsModel:model];
        [weakSelf thn_setHeaderViewWithGoodsImageAssets:model.assets];
        [weakSelf thn_getGoodsSkuDataWithGoodsId:model.rid];
        [weakSelf thn_getSimilarGoodsDataWithGoodsId:model.rid];
        [weakSelf thn_getLikedGoodsUserDataWithGoodsId:model.rid reload:NO];
        [weakSelf thn_getGoodsFreightTemplateWithGoodsModel:model];
        [weakSelf thn_getGoodsOfficialStoreInfoWithStoreId:model.storeRid];
        weakSelf.dealContentH = [weakSelf thn_getGoodsDealContentHeightWithContent:model.dealContent];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf thn_setTitleInfoCellWithGoodsModel:model];
            [weakSelf thn_setTagsContentCellWithGoodsModel:model];
            [weakSelf thn_setActionButtonCellWithGoodsModel:model];
            [weakSelf thn_setDirectSelectCellWithGoodsModel:model];
            [weakSelf thn_setDescribeCellWithGoodsModel:model];
            [weakSelf thn_setGoodsDealContentCellWithGoodsModel:model];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf thn_reloadSections];
            });
        });
    }];
}

/**
 获取商品 SKU 数据
 */
- (void)thn_getGoodsSkuDataWithGoodsId:(NSString *)goodsId {
    WEAKSELF;
    
    [THNGoodsManager getProductSkusInfoWithId:goodsId
                                       params:@{}
                                   completion:^(THNSkuModel *model, NSError *error) {
                                       if (error) return;
        
                                       weakSelf.skuModel = model;
                                   }];
}

/**
 设置商品图片
 */
- (void)thn_setHeaderViewWithGoodsImageAssets:(NSArray *)assets {
    [self.imagesView thn_setImageAssets:assets];
    self.tableView.tableHeaderView = self.imagesView;
}

/**
 设置商品标题、价格等基本信息
 */
- (void)thn_setTitleInfoCellWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *titleCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTitle)];
    titleCells.height = [self thn_getGoodsTitleHeightWithTitle:model.name] + 60;
    titleCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[titleCells] mutableCopy]];
    sections.index = 0;
    
    [self.dataSections addObject:sections];
}

/**
 设置商品标签
 */
- (void)thn_setTagsContentCellWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *tagCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTag)];
    tagCells.height = model.labels.count ? 32 : 0.01;
    tagCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[tagCells] mutableCopy]];
    sections.index = 1;
    
    [self.dataSections addObject:sections];
}

/**
 商品操作的按钮
 */
- (void)thn_setActionButtonCellWithGoodsModel:(THNGoodsModel *)model {
    WEAKSELF;
    
    THNGoodsTableViewCells *actionCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeAction) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_getLikedGoodsUserDataWithGoodsId:rid reload:YES];
    }];
    actionCells.height = 49;
    actionCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[actionCells] mutableCopy]];
    sections.index = 2;
    
    [self.dataSections addObject:sections];
}

/**
 设置“直接选择尺码”
 */
- (void)thn_setDirectSelectCellWithGoodsModel:(THNGoodsModel *)model {
    WEAKSELF;
    
    THNGoodsTableViewCells *directCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeChoose) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsSkuController];
    }];
    directCells.height = model.isCustomMade ? 80 : 55;
    directCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[directCells] mutableCopy]];
    sections.index = 3;
    
    [self.dataSections addObject:sections];
}

/**
 设置商品描述
 */
- (void)thn_setDescribeCellWithGoodsModel:(THNGoodsModel *)goodsModel {
    WEAKSELF;
    
    THNGoodsTableViewCells *desCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    desCells.height = [self thn_getGoodsFeaturesHeightWithModel:goodsModel];
    desCells.goodsModel = goodsModel;
    
    THNGoodsTableViewCells *salesReturnCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    salesReturnCells.height = 130;
    salesReturnCells.goodsModel = goodsModel;
    
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
    sections.index = 5;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 获取发货时间信息
 */
- (void)thn_getGoodsFreightTemplateWithGoodsModel:(THNGoodsModel *)goodsModel {
    [THNGoodsManager getFreightTemplateDataWithRid:goodsModel.fid
                                           goodsId:goodsModel.rid
                                           storeId:goodsModel.storeRid
                                        completion:^(THNFreightModel *model, NSError *error) {
                                            if (error) return;
        
                                            self.freightModel = model;
                                        }];
}

/**
 喜欢商品的用户
 */
- (void)thn_setLikedGoodsUserCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *userCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeUser) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openLikeGoodsUserController];
    }];
    userCells.height = self.likedUserArr.count == 0 ? 0.01 : 50;
    userCells.likeUserData = self.likedUserArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[userCells] mutableCopy]];
    sections.index = 4;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 获取喜欢商品的用户
 */
- (void)thn_getLikedGoodsUserDataWithGoodsId:(NSString *)goodsId reload:(BOOL)reload {
    if (reload) {
        [self.dataSections removeObjectAtIndex:4];
    }
    
    [THNGoodsManager getLikeGoodsUserDataWithGoodsId:goodsId
                                              params:@{}
                                          completion:^(NSArray *userData, NSError *error) {
                                              if (error) return;
        
                                              self.likedUserArr = [NSArray arrayWithArray:userData];
                                              [self thn_setLikedGoodsUserCell];
                                              [self thn_reloadSections];
                                          }];
}

/**
 设置店铺信息
 */
- (void)thn_setStoreInfoCellWithModel:(THNStoreModel *)model {
    WEAKSELF;
    
    THNGoodsTableViewCells *storeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openBrandHallControllerWithRid:rid];
    }];
    storeCells.height = 85;
    storeCells.storeModel = model;
    
    THNGoodsTableViewCells *storeGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:rid];
    }];
    storeGoodsCells.height = 105;
    storeGoodsCells.storeGoodsData = model.products;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, storeGoodsCells] mutableCopy]];
    sections.index = 6;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 获取店铺信息
 */
- (void)thn_getGoodsOfficialStoreInfoWithStoreId:(NSString *)storeRid {
    [THNGoodsManager getOfficialStoreInfoWithId:storeRid completion:^(THNStoreModel *model, NSError *error) {
        if (error) return;
        
        self.storeModel = model;
        [self thn_setStoreInfoCellWithModel:model];
        [self thn_reloadSections];
    }];
}

/**
 设置相似商品
 */
- (void)thn_setSimilarGoodsCell {
    WEAKSELF;
    
    THNGoodsTableViewCells *headerCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeSimilar)];
    headerCells.height = 56;
    
    THNGoodsTableViewCells *similarGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeSimilar) didSelectedItem:^(NSString *rid) {
        [weakSelf thn_openGoodsInfoControllerWithGoodsId:rid];
    }];
    similarGoodsCells.height = 105;
    similarGoodsCells.similarGoodsData = self.similarGoodsArr;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[headerCells, similarGoodsCells] mutableCopy]];
    sections.index = 7;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
}

/**
 获取相似的商品
 */
- (void)thn_getSimilarGoodsDataWithGoodsId:(NSString *)goodsId {
    [THNGoodsManager getSimilarGoodsWithGoodsId:goodsId completion:^(NSArray *goodsData, NSError *error) {
        if (error) return;
        
        self.similarGoodsArr = [NSArray arrayWithArray:goodsData];
        [self thn_setSimilarGoodsCell];
        [self thn_reloadSections];
    }];
}

/**
 设置商品详情内容
 */
- (void)thn_setGoodsDealContentCellWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *headerCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeContent)];
    headerCells.height = 56;
    
    THNGoodsTableViewCells *contentCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeContent)];
    contentCells.height = self.dealContentH;
    contentCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[headerCells, contentCells] mutableCopy]];
    sections.index = 8;
    sections.footerHeight = kFooterHeight;
    
    [self.dataSections addObject:sections];
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

#pragma mark - custom delegate
- (void)thn_openGoodsCart {
    THNCartViewController *cartVC = [[THNCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)thn_openGoodsSkuWithType:(THNGoodsButtonType)type {
    if (!self.goodsModel && !self.skuModel) return;
    
    if (type == THNGoodsButtonTypeSell) {
        [self thn_openGoodsSellShareView];
        
    } else {
        THNGoodsSkuViewController *goodsSkuVC = [[THNGoodsSkuViewController alloc] initWithSkuModel:self.skuModel
                                                                                         goodsModel:self.goodsModel
                                                                                           viewType:(THNGoodsSkuTypeDefault)];
        goodsSkuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        goodsSkuVC.functionType = self.functionView.type;
        goodsSkuVC.handleType = type;
        goodsSkuVC.selectGoodsAddCartCompleted = ^(NSString *skuId) {
            [SVProgressHUD thn_showSuccessWithStatus:@"添加成功"];
            [self thn_getCartGoodsCount];
        };
        [self presentViewController:goodsSkuVC animated:NO completion:nil];
    }
}

- (void)thn_didSelectImageAtIndex:(NSInteger)index {
    THNGoodsImagesViewController *goodsImageVC = [[THNGoodsImagesViewController alloc] initWithGoodsModel:self.goodsModel
                                                                                                 skuModel:self.skuModel];
    [goodsImageVC thn_scrollContentWithIndex:index];
    [goodsImageVC thn_setSkuFunctionViewType:self.functionView.type
                                  handleType:self.goodsModel.isCustomMade ? THNGoodsButtonTypeCustom : THNGoodsButtonTypeBuy
                       titleAttributedString:[self thn_getGoodsTitle]];
    goodsImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:goodsImageVC animated:NO completion:nil];
}

#pragma mark - private methods
/**
 刷新“组”数据，视图
 */
- (void)thn_reloadSections {
    [self thn_sortDataSecitons];
    [self.tableView reloadData];
}

/**
 商品已卖完/下架
 */
- (void)thn_goodsIsSoldOut:(BOOL)soldOut {
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
 打开卖货分享图片视图
 */
- (void)thn_openGoodsSellShareView {
    [SVProgressHUD thn_showInfoWithStatus:@"卖货"];
}

/**
 获取商品标题文字
 */
- (NSAttributedString *)thn_getGoodsTitle {
    THNTableViewSections *sections = self.dataSections[0];
    THNGoodsTableViewCells *goodsCells = sections.dataCells[0];
    
    return goodsCells.titleCell.titleLabel.attributedText;
}

/**
 获取商品标题文字的高度
 */
- (CGFloat)thn_getGoodsTitleHeightWithTitle:(NSString *)title {
    return [YYLabel thn_getYYLabelTextLayoutSizeWithText:title
                                                fontSize:16
                                             lineSpacing:6
                                          fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
}

/**
 获取图文详情的高度
 */
- (CGFloat)thn_getGoodsDealContentHeightWithContent:(NSArray *)content {
    CGFloat contentH = 0.0;
    
    for (THNGoodsModelDealContent *model in content) {
        if ([model.type isEqualToString:@"text"]) {
            CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:model.content
                                                                 fontSize:14
                                                              lineSpacing:7
                                                                  fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
            contentH += (textH + 10);
            
        } else if ([model.type isEqualToString:@"image"]) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.content]];
            YYImageType imageType = YYImageDetectType((__bridge CFDataRef _Nonnull)(imageData));
            
            if (imageType == YYImageTypeJPEG || imageType == YYImageTypePNG) {
                YYImage *contentImage = [YYImage imageWithData:imageData];
                CGFloat image_scale = (kScreenWidth - 30) / contentImage.size.width;
                CGFloat image_h = contentImage.size.height * image_scale;
                
                contentH += (image_h + 10);
                
            } else {
                contentH += 220;
            }
        }
    }

    return contentH + 20;
}

/**
 获取商品描述的高度
 */
- (CGFloat)thn_getGoodsFeaturesHeightWithModel:(THNGoodsModel *)model {
    CGFloat contentH = 50.0;
    
    contentH += model.isCustomService ? 30 : 0;
    contentH += model.materialName.length ? 30 : 0;
    contentH += model.stockCount < 10 ? 30 : 0;
    
    BOOL isHaveFeatures = model.features.length > 0;
    CGFloat featuresH = model.features.length > 24 ? 50 : 30;
    contentH += isHaveFeatures ? featuresH : 0;
    
    return contentH == 50.0 ? 0.01 : contentH;
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
- (void)thn_openLikeGoodsUserController {
    THNUserListViewController *userListVC = [[THNUserListViewController alloc] initWithType:(THNUserListTypeLikeGoods)
                                                                                  requestId:self.goodsId];
    [self.navigationController pushViewController:userListVC animated:YES];
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
                THNGoodsContentTableViewCell *contentCell = [THNGoodsContentTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.contentCell = contentCell;
                contentCell.baseCell = goodsCells;
                [contentCell thn_setContentWithGoodsModel:goodsCells.goodsModel];
                
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
        THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(ShareContentTypeGoods)];
        shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:shareVC animated:NO completion:nil];
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

@end
