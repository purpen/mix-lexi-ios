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
#import "THNGoodsFunctionView.h"
#import "THNGoodsSkuView.h"

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
        [self.skuView thn_setTitleAttributedString:[self thn_getGoodsTitle]];
        [self.skuView thn_showGoodsSkuViewWithType:self.functionView.type handleType:type];
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
        if (model.labels.count > 0) {
            [self thn_setTagsContentWithGoodsModel:model];
        }
        
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
    titleCells.height = (model.name.length * 17) / (SCREEN_WIDTH - 40) > 1 ? 90 : 68;
    titleCells.goodsModel = model;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[titleCells] mutableCopy]];
    sections.index = 0;
    
    [self.dataSections addObject:sections];
    [self.tableView reloadData];
}

/**
 设置商品标签
 */
- (void)thn_setTagsContentWithGoodsModel:(THNGoodsModel *)model {
    THNGoodsTableViewCells *tagCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeTag) didSelectedItem:^{
        
    }];
    tagCells.height = 40;
    tagCells.tagsArr = model.labels;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[tagCells] mutableCopy]];
    sections.index = 1;
    
    [self.dataSections addObject:sections];
    [self.tableView reloadData];
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
            [tagCell thn_setGoodsTagWithTags:goodsCells.tagsArr];
            
            return tagCell;
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
