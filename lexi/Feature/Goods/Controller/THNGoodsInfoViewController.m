//
//  THNGoodsInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsInfoViewController.h"
#import "THNGoodsManager.h"
#import "THNImagesView.h"
#import "THNGoodsFunctionView.h"
#import "THNGoodsSkuView.h"
#import "NSString+Helper.h"
#import "YYLabel+Helper.h"
#import "THNGoodsImagesViewController.h"
#import "THNGoodsDescribeViewController.h"
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

static NSInteger const kFooterHeight = 18;

@interface THNGoodsInfoViewController () <THNGoodsFunctionViewDelegate, THNImagesViewDelegate> {
    UIStatusBarStyle _statusBarStyle;
}

/// 商品的 id
@property (nonatomic, strong) NSString *goodsId;
/// 商品 model
@property (nonatomic, strong) THNGoodsModel *goodsModel;
/// 图片列表
@property (nonatomic, strong) THNImagesView *imagesView;
/// 底部功能视图
@property (nonatomic, strong) THNGoodsFunctionView *functionView;
/// sku 视图
@property (nonatomic, strong) THNGoodsSkuView *skuView;

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
    [self thn_getGoodsSkuDataWithGoodsId:self.goodsId];
}

#pragma mark - custom delegate
- (void)thn_openGoodsCart {
    [SVProgressHUD showInfoWithStatus:@"打开购物车"];
}

- (void)thn_openGoodsSkuWithType:(THNGoodsButtonType)type {
    if (type == THNGoodsButtonTypeSell) {
        [self thn_openGoodsSellShareView];
        
    } else {
        [self.skuView thn_showGoodsSkuViewType:self.functionView.type
                                    handleType:type
                         titleAttributedString:[self thn_getGoodsTitle]];
    }
}

- (void)thn_didSelectImageAtIndex:(NSInteger)index {
    WEAKSELF;
    
    THNGoodsImagesViewController *goodsImageVC = [[THNGoodsImagesViewController alloc] initWithGoodsModel:self.goodsModel];
    goodsImageVC.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
    goodsImageVC.buyGoodsCompleted = ^{
        [weakSelf.skuView thn_showGoodsSkuViewType:weakSelf.functionView.type
                                        handleType:weakSelf.goodsModel.isCustomMade ? THNGoodsButtonTypeCustom : THNGoodsButtonTypeBuy
                             titleAttributedString:[weakSelf thn_getGoodsTitle]];
    };
    [self presentViewController:goodsImageVC animated:YES completion:nil];
}

#pragma mark - network
/**
 获取商品详情数据
 */
- (void)thn_getGoodsInfoDataWithGoodsId:(NSString *)goodsId {
    [SVProgressHUD show];
    [THNGoodsManager getProductAllDetailWithId:self.goodsId completion:^(THNGoodsModel *model, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) return;
        
        self.goodsModel = model;
        [self thn_setHeaderViewWithGoodsImageAssets:model.assets];
        [self thn_setTitleInfoWithGoodsModel:model];
        [self thn_setTagsContentWithGoodsModel:model];
        [self thn_setActionButtonWithGoodsModel:model];
        [self thn_setDirectSelectWithGoodsModel:model];
        [self thn_setLikedGoodsUserWithGoodsId:model.rid isReload:NO];
        [self thn_setDescribeCellWithGoodsModel:model];
        [self thn_setSimilarGoodsWithGoodsId:model.rid];
        [self thn_setGoodsDealContentWithGoodsModel:model];
        
        [self.functionView thn_setGoodsModel:model];
    }];
}

/**
 获取商品 SKU 数据
 */
- (void)thn_getGoodsSkuDataWithGoodsId:(NSString *)goodsId {
    WEAKSELF;
    
    [THNGoodsManager getProductSkusInfoWithId:goodsId params:@{} completion:^(THNSkuModel *model, NSError *error) {
        if (error) return;
        
        [weakSelf.skuView thn_setGoodsSkuModel:model];
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
- (void)thn_setTitleInfoWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *titleCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTitle)];
    CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:model.name fontSize:16 lineSpacing:6
                                                          fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
    titleCells.height = textH + 60;
    titleCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[titleCells] mutableCopy]];
    sections.index = 0;
    
    [self thn_addSections:sections];
}

/**
 设置商品标签
 */
- (void)thn_setTagsContentWithGoodsModel:(THNGoodsModel *)model {
    if (!model.labels.count) return;
    
    THNGoodsTableViewCells *tagCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTag) didSelectedItem:^{
        
    }];
    tagCells.height = 32;
    tagCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[tagCells] mutableCopy]];
    sections.index = 1;
    
    [self thn_addSections:sections];
}

/**
 商品操作的按钮
 */
- (void)thn_setActionButtonWithGoodsModel:(THNGoodsModel *)model {
    WEAKSELF;
    
    THNGoodsTableViewCells *actionCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeAction) didSelectedItem:^{
        [weakSelf thn_setLikedGoodsUserWithGoodsId:model.rid isReload:YES];
    }];
    actionCells.height = 49;
    actionCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[actionCells] mutableCopy]];
    sections.index = 2;
    
    [self thn_addSections:sections];
}

/**
 设置“直接选择尺码”
 */
- (void)thn_setDirectSelectWithGoodsModel:(THNGoodsModel *)model {
    WEAKSELF;
    
    THNGoodsTableViewCells *directCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeChoose) didSelectedItem:^{
        [weakSelf.skuView thn_showGoodsSkuViewType:weakSelf.functionView.type titleAttributedString:[weakSelf thn_getGoodsTitle]];
    }];
    directCells.height = model.isCustomMade ? 80 : 55;
    directCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[directCells] mutableCopy]];
    sections.index = 3;
    
    [self thn_addSections:sections];
}

/**
 喜欢商品的用户
 */
- (void)thn_setLikedGoodsUserWithGoodsId:(NSString *)goodsId isReload:(BOOL)reload {
    if (reload) [self.dataSections removeObjectAtIndex:4];
    
    [THNGoodsManager getLikeGoodsUserDataWithGoodsId:goodsId params:@{} completion:^(NSArray *userData, NSError *error) {
        THNGoodsTableViewCells *userCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeUser) didSelectedItem:^{
            [SVProgressHUD showInfoWithStatus:@"查看全部用户"];
        }];
        userCells.height = userData.count == 0 ? 0.01 : 50;
        userCells.likeUserData = userData;
        
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[userCells] mutableCopy]];
        sections.index = 4;
        sections.footerHeight = kFooterHeight;

        [self thn_addSections:sections];
    }];
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
    
    THNGoodsTableViewCells *dispatchCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    dispatchCells.height = 80;
    
    THNGoodsTableViewCells *checkCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe) didSelectedItem:^{
        THNGoodsDescribeViewController *describeVC = [[THNGoodsDescribeViewController alloc] initWithGoodsModel:goodsModel];
        [weakSelf presentViewController:describeVC animated:YES completion:nil];
    }];
    checkCells.height = 56;
    
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        // 获取发货时间信息
        [THNGoodsManager getFreightTemplateDataWithRid:goodsModel.fid goodsId:goodsModel.rid storeId:goodsModel.storeRid completion:^(THNFreightModel *model, NSError *error) {
            timeCells.freightModel = model;
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        // 获取店铺信息
        [THNGoodsManager getOfficialStoreInfoWithId:goodsModel.storeRid completion:^(THNStoreModel *model, NSError *error) {
            dispatchCells.storeModel = model;
            
            [weakSelf thn_setStoreInfoWithModel:model];
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        NSMutableArray *cellArr = [NSMutableArray arrayWithArray:@[desCells, dispatchCells, timeCells, salesReturnCells, checkCells]];
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:cellArr];
        sections.index = 5;
        sections.footerHeight = kFooterHeight;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self thn_addSections:sections];
        });
    });
}

/**
 设置店铺信息
 */
- (void)thn_setStoreInfoWithModel:(THNStoreModel *)model {
    THNGoodsTableViewCells *storeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^{
        [SVProgressHUD showInfoWithStatus:@"查看店铺信息"];
    }];
    storeCells.height = 85;
    storeCells.storeModel = model;
    
    THNGoodsTableViewCells *storeGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^{
        [SVProgressHUD showInfoWithStatus:@"查看商品信息"];
    }];
    storeGoodsCells.height = 105;
    storeGoodsCells.storeGoodsData = model.products;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, storeGoodsCells] mutableCopy]];
    sections.index = 6;
    sections.footerHeight = kFooterHeight;
    
    [self thn_addSections:sections];
}

/**
 设置相似商品
 */
- (void)thn_setSimilarGoodsWithGoodsId:(NSString *)goodsId {
    [THNGoodsManager getSimilarGoodsWithGoodsId:goodsId completion:^(NSArray *goodsData, NSError *error) {
        if (error) return;
        
        THNGoodsTableViewCells *headerCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeSimilar)];
        headerCells.height = 56;
        
        THNGoodsTableViewCells *similarGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeSimilar) didSelectedItem:^{
            [SVProgressHUD showInfoWithStatus:@"查看商品信息"];
        }];
        similarGoodsCells.height = 105;
        similarGoodsCells.similarGoodsData = goodsData;
        
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[headerCells, similarGoodsCells] mutableCopy]];
        sections.index = 7;
        sections.footerHeight = kFooterHeight;
        
        [self thn_addSections:sections];
    }];
}

/**
 设置商品详情内容
 */
- (void)thn_setGoodsDealContentWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *contentCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeContent)];
    contentCells.height = [self thn_getGoodsDealContentHeightWithContent:model.dealContent];
    contentCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[contentCells] mutableCopy]];
    sections.index = 8;
    sections.footerHeight = kFooterHeight;
    
    [self thn_addSections:sections];
}

#pragma mark - private methods
/**
 打开卖货分享图片视图
 */
- (void)thn_openGoodsSellShareView {
    [SVProgressHUD showInfoWithStatus:@"卖货"];
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
 添加“组”
 */
- (void)thn_addSections:(THNTableViewSections *)section {
    [self.dataSections addObject:section];
    [self thn_sortDataSecitons];
    
    [self.tableView reloadData];
}

/**
 获取商品详情的高度
 */
- (CGFloat)thn_getGoodsDealContentHeightWithContent:(NSArray *)content {
    CGFloat contentH = 0.0;
    CGFloat imageH = (kScreenWidth - 30) * 0.66;
    
    for (THNGoodsModelDealContent *model in content) {
        if ([model.type isEqualToString:@"text"]) {
            CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:model.content
                                                                 fontSize:14
                                                              lineSpacing:7
                                                                  fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
            contentH += (textH + 10);
            
        } else if ([model.type isEqualToString:@"image"]) {
            contentH += (imageH + 10);
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
                [desInfoCell thn_hiddenLine];
                [desInfoCell thn_setDescribeType:(THNGoodsDescribeCellTypeDes) goodsModel:goodsCells.goodsModel];
                
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
                [salesReturnCell thn_setDescribeType:(THNGoodsDescribeCellTypeSalesReturn) goodsModel:goodsCells.goodsModel];
                
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
            THNGoodsContentTableViewCell *contentCell = [THNGoodsContentTableViewCell initGoodsCellWithTableView:tableView];
            goodsCells.contentCell = contentCell;
            contentCell.baseCell = goodsCells;
            [contentCell thn_setContentWithGoodsModel:goodsCells.goodsModel];
            
            return contentCell;
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

- (void)setupUI {
    [self setNavigationBar];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 55, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.separatorStyle = THNTableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.functionView];
    [self.view addSubview:self.skuView];
}

- (void)setNavigationBar {
    [self.navigationBarView setNavigationTransparent:YES showShadow:YES];
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_white"];
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [SVProgressHUD showInfoWithStatus:@"分享商品"];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.view bringSubviewToFront:self.skuView];
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
        _functionView.delegate = self;
    }
    return _functionView;
}

- (THNGoodsSkuView *)skuView {
    if (!_skuView) {
        _skuView = [[THNGoodsSkuView alloc] init];
    }
    return _skuView;
}

- (void)dealloc {
    
}

@end
