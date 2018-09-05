//
//  THNGoodsDescribeViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsDescribeViewController.h"
#import "THNGoodsManager.h"
#import "THNGoodsDescribeTableViewCell.h"
#import "YYLabel+Helper.h"

@interface THNGoodsDescribeViewController ()

/// 商品数据
@property (nonatomic, strong) THNGoodsModel *model;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation THNGoodsDescribeViewController

- (instancetype)initWithGoodsModel:(THNGoodsModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_setDescribeCellWithGoodsModel:self.model];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 设置商品描述
 */
- (void)thn_setDescribeCellWithGoodsModel:(THNGoodsModel *)goodsModel {
    THNGoodsTableViewCells *desCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    desCells.height = [self thn_getGoodsFeaturesHeightWithModel:goodsModel];
    desCells.goodsModel = goodsModel;
    
    THNGoodsTableViewCells *salesReturnCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    salesReturnCells.height = [self thn_getSalesReturnHeightWithModel:goodsModel];
    salesReturnCells.goodsModel = goodsModel;
    
    THNGoodsTableViewCells *timeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    timeCells.height = 80;
    // 获取发货时间信息
    [THNGoodsManager getFreightTemplateDataWithRid:goodsModel.fid goodsId:goodsModel.rid storeId:goodsModel.storeRid completion:^(THNFreightModel *model, NSError *error) {
        timeCells.freightModel = model;
        [self.tableView reloadData];
    }];
    
    THNGoodsTableViewCells *dispatchCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    dispatchCells.height = 80;
    // 获取店铺信息
    [THNGoodsManager getOfficialStoreInfoWithId:goodsModel.storeRid completion:^(THNStoreModel *model, NSError *error) {
        dispatchCells.storeModel = model;
        [self.tableView reloadData];
    }];
    
    NSMutableArray *cellArr = [NSMutableArray arrayWithArray:@[desCells, dispatchCells, timeCells, salesReturnCells]];
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:cellArr];
    sections.index = 0;
    
    [self.dataSections addObject:sections];
    [self.tableView reloadData];
}

#pragma mark - private methods
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
 售后政策内容的高度
 */
- (CGFloat)thn_getSalesReturnHeightWithModel:(THNGoodsModel *)model {
    
    CGFloat policyH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:model.productReturnPolicy
                                                           fontSize:14
                                                        lineSpacing:7
                                                            fixSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)].height;
    return policyH + 100;
}

#pragma mark - tableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNGoodsTableViewCells *goodsCells = sections.dataCells[indexPath.row];
    
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
    }
    
    return nil;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.navigationBarView setNavigationTransparent:YES showShadow:NO];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -  80);
    self.separatorStyle = THNTableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.closeButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-35);
    }];
}

#pragma mark - getters and setters
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_black"] forState:(UIControlStateNormal)];
        [_closeButton setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

@end
