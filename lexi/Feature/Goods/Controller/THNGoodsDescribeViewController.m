//
//  THNGoodsDescribeViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsDescribeViewController.h"
#import "THNGoodsDescribeTableViewCell.h"
#import "YYLabel+Helper.h"

@interface THNGoodsDescribeViewController ()

/// 商品数据
@property (nonatomic, strong) THNGoodsModel *goodsModel;
/// 店铺 model
@property (nonatomic, strong) THNStoreModel *storeModel;
/// 运费 model
@property (nonatomic, strong) THNFreightModel *freightModel;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation THNGoodsDescribeViewController

- (instancetype)initWithGoodsModel:(THNGoodsModel *)goodsModel
                        storeModel:(THNStoreModel *)storeModel
                      freightModel:(THNFreightModel *)freightModel {
    self = [super init];
    if (self) {
        self.goodsModel = goodsModel;
        self.storeModel = storeModel;
        self.freightModel = freightModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_setDescribeCell];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 设置商品描述
 */
- (void)thn_setDescribeCell {
    if (!self.goodsModel) return;
    
    THNGoodsTableViewCells *desCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    desCells.height = [self thn_getGoodsFeaturesHeightWithModel:self.goodsModel];
    desCells.goodsModel = self.goodsModel;
    
    THNGoodsTableViewCells *salesReturnCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    NSString *salesReturnText = [self thn_getSalesReturnTextWithTitle:self.goodsModel.returnPolicyTitle
                                                              content:self.goodsModel.productReturnPolicy];
    salesReturnCells.height = [self thn_getContentHeightWithText:salesReturnText] + 75;
    salesReturnCells.goodsModel = self.goodsModel;
    
    WEAKSELF;
    
    THNGoodsTableViewCells *timeCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    timeCells.height = 80;
    
    if (!self.freightModel) {
        // 获取发货时间信息
        [THNGoodsManager getFreightTemplateDataWithRid:self.goodsModel.fid goodsId:self.goodsModel.rid storeId:self.goodsModel.storeRid completion:^(THNFreightModel *model, NSError *error) {
            timeCells.freightModel = model;
            [weakSelf.tableView reloadData];
        }];
        
    } else {
        timeCells.freightModel = self.freightModel;
        [self.tableView reloadData];
    }
    
    THNGoodsTableViewCells *dispatchCells = [THNGoodsTableViewCells initWithCellType:(THNGoodsTableViewCellTypeDescribe)];
    dispatchCells.height = 80;
    if (!self.storeModel) {
        // 获取店铺信息
        [THNGoodsManager getOfficialStoreInfoWithId:self.goodsModel.storeRid completion:^(THNStoreModel *model, NSError *error) {
            dispatchCells.storeModel = model;
            [weakSelf.tableView reloadData];
        }];
        
    } else {
        dispatchCells.storeModel = self.storeModel;
        [self.tableView reloadData];
    }
    
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
    CGFloat contentH = 70.0;

    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] init];
    
    // 亮点
    BOOL showFeatures = model.features.length > 0;
    if (showFeatures) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"亮点" content:model.features]];
    }
    
    // 材质
    BOOL showMaterial = model.materialName.length > 0;
    if (showMaterial) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"材质" content:model.materialName]];
    }
    
    // 特点
    if (model.isCustomService) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"特点" content:@"可提供订制化服务"]];
    }
    
    // 数量
    BOOL showCount = model.stockCount < 10;
    BOOL isSellOut = model.stockCount == 0;
    if (showCount) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"数量" content:[NSString stringWithFormat:@"仅剩最后%zi件", model.stockCount]]];
    }
    
    // 售罄
    if (isSellOut) {
        [textAtt appendAttributedString:[self thn_getDescribePrefixText:@"数量" content:@"已售罄"]];
    }
    
    textAtt.lineSpacing = 7;
    textAtt.paragraphSpacing = 3;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    
    // 生成排版结果
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:textAtt];
    contentH += textLayout.textBoundingSize.height;
    
    return contentH;
}

/**
 描述内容
 */
- (NSMutableAttributedString *)thn_getDescribePrefixText:(NSString *)text content:(NSString *)content {
    NSMutableAttributedString *prefixAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", text]];
    prefixAtt.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    prefixAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", content]];
    contentAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    contentAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    [prefixAtt appendAttributedString:contentAtt];
    [prefixAtt insertAttributedString:[self thn_getSymbolText] atIndex:0];
    
    return prefixAtt;
}

/**
 前缀符号
 */
- (NSMutableAttributedString *)thn_getSymbolText {
    NSMutableAttributedString *symbolAtt = [[NSMutableAttributedString alloc] initWithString:@"·  "];
    symbolAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
    symbolAtt.color = [UIColor colorWithHexString:kColorMain];
    
    return symbolAtt;
}

/**
 售后服务的内容
 */
- (NSString *)thn_getSalesReturnTextWithTitle:(NSString *)title content:(NSString *)content {
    NSString *titleText = title.length ? [NSString stringWithFormat:@"· %@\n", title] : @"";
    NSString *text = [NSString stringWithFormat:@"%@%@", titleText, content];
    
    return text;
}

/**
 内容的高度
 */
- (CGFloat)thn_getContentHeightWithText:(NSString *)text {
    CGFloat contentH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:text
                                                            fontSize:14
                                                         lineSpacing:7
                                                             fixSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)].height;
    
    return contentH;
}

#pragma mark - tableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNGoodsTableViewCells *goodsCells = sections.dataCells[indexPath.row];
    
    if (indexPath.row == 0) {
        THNGoodsDescribeTableViewCell *desInfoCell = [THNGoodsDescribeTableViewCell initGoodsCellWithTableView:tableView];
        goodsCells.desInfoCell = desInfoCell;
        desInfoCell.baseCell = goodsCells;
        [desInfoCell thn_setDescribeType:(THNGoodsDescribeCellTypeDes) goodsModel:goodsCells.goodsModel showIcon:YES];
        
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

- (void)dealloc {
    
}

@end
