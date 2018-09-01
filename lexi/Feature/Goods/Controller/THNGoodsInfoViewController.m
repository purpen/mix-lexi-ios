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
#import "THNGoodsTitleTableViewCell.h"
#import "THNGoodsTagTableViewCell.h"
#import "THNGoodsDirectTableViewCell.h"
#import "THNGoodsUserTableViewCell.h"
#import "THNGoodsStoreTableViewCell.h"
#import "THNLikedGoodsTableViewCell.h"
#import "THNGoodsContactTableViewCell.h"
#import "THNGoodsFunctionView.h"
#import "THNGoodsSkuView.h"
#import "NSString+Helper.h"

@interface THNGoodsInfoViewController () <THNGoodsFunctionViewDelegate>

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
    return UIStatusBarStyleLightContent;
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
    [self.tableView reloadData];
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
        
        [self thn_setHeaderViewWithGoodsImageAssets:model.assets];
        [self thn_setTitleInfoWithGoodsModel:model];
        [self thn_setTagsContentWithGoodsModel:model];
        [self thn_setDirectSelectWithGoodsModel:model];
        [self thn_setLikedUserHeaderWithGoodsModel:model];
        [self thn_setStoreInfoWithId:model.storeRid];
        
        [self.functionView thn_setGoodsModel:model];
    }];
}

/**
 获取商品 SKU 数据
 */
- (void)thn_getGoodsSkuDataWithGoodsId:(NSString *)goodsId {
    [THNGoodsManager getProductSkusInfoWithId:goodsId params:@{} completion:^(THNSkuModel *model, NSError *error) {
        if (error) return;
        
        [self.skuView thn_setGoodsSkuModel:model];
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
    titleCells.height = [model.name boundingSizeWidthWithFontSize:17] / (SCREEN_WIDTH - 30) > 1 ? 90 : 68;
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
    tagCells.height = 40;
    tagCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[tagCells] mutableCopy]];
    sections.index = 1;
    
    [self thn_addSections:sections];
}

/**
 设置“直接选择尺码”
 */
- (void)thn_setDirectSelectWithGoodsModel:(THNGoodsModel *)model {
    WEAKSELF;
    THNGoodsTableViewCells *directCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe) didSelectedItem:^{
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
- (void)thn_setLikedUserHeaderWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *userCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeUser) didSelectedItem:^{
        NSLog(@"查看全部用户");
    }];
    userCells.height = 50;
    userCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[userCells] mutableCopy]];
    sections.index = 4;
    sections.footerHeight = 18;
    
    [self thn_addSections:sections];
}

/**
 设置店铺信息
 */
- (void)thn_setStoreInfoWithId:(NSString *)storeId {
    [THNGoodsManager getOfficialStoreInfoWithId:storeId completion:^(THNStoreModel *model, NSError *error) {
        if (error) return;
        
        THNGoodsTableViewCells *storeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^{
            [SVProgressHUD showInfoWithStatus:@"查看店铺信息"];
        }];
        storeCells.height = 85;
        storeCells.storeModel = model;
        
        THNGoodsTableViewCells *storeGoodsCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^{
            [SVProgressHUD showInfoWithStatus:@"查看商品信息"];
        }];
        storeGoodsCells.height = 90;
        storeGoodsCells.storeGoodsData = model.products;
        
        THNGoodsTableViewCells *contactCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeStore) didSelectedItem:^{
            [SVProgressHUD showInfoWithStatus:@"联系店铺"];
        }];
        contactCells.height = 50;
        
        THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[storeCells, storeGoodsCells, contactCells] mutableCopy]];
        sections.index = 6;
        sections.footerHeight = 18;
        
        [self thn_addSections:sections];
    }];
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
            
        case THNGoodsTableViewCellTypeDescribe: {
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
            [userCell thn_setLikedUserData:goodsCells.goodsModel.productLikeUsers];
            
            return userCell;
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
                
            } else if (indexPath.row == 2) {
                THNGoodsContactTableViewCell *contactCell = [THNGoodsContactTableViewCell initGoodsCellWithTableView:tableView];
                goodsCells.contactCell = contactCell;
                contactCell.baseCell = goodsCells;
                
                return contactCell;
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setupUI {
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 55, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.separatorStyle = THNTableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.functionView];
    [self.view addSubview:self.skuView];
}

- (void)setNavigationBar {
    [self.navigationBarView setNavigationTransparent:YES showShadow:YES];
    [self.navigationBarView setNavigationTitleHidden:YES];
}

#pragma mark - getters and setters
- (THNImagesView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[THNImagesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
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

@end
