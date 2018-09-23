//
//  THNSelectLogisticsViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectLogisticsViewController.h"
#import "THNGoodsInfoTableViewCell.h"
#import "THNSelectLogisticsTableViewCell.h"
#import "THNLogisticsPlaceTableViewCell.h"
#import "THNLogisticsPriceView.h"
#import "THNSkuModelItem.h"

static NSString *const kURLExpress = @"/logistics/same_template_express";

@interface THNSelectLogisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *iTableView;
/// 商品数组
@property (nonatomic, strong) NSArray *goodsArr;
/// 快递数组
@property (nonatomic, strong) NSArray *expressArr;
/// 发货地
@property (nonatomic, strong) NSString *country;
/// 运费预览视图
@property (nonatomic, strong) THNLogisticsPriceView *priceView;
/// 选中的
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation THNSelectLogisticsViewController

- (instancetype)initWithGoodsData:(NSArray *)goodsData logisticsData:(NSArray *)logisticsData {
    self = [super self];
    if (self) {
        self.goodsArr = [self thn_changeGoodsSkuDataToModes:goodsData];
        self.expressArr = [self thn_changeExpressDataToModels:logisticsData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)requestSameTemplateExpress {
    THNRequest *request = [THNAPI postWithUrlString:kURLExpress requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - private methods
- (NSArray *)thn_changeGoodsSkuDataToModes:(NSArray *)goodsData {
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSDictionary *dict in goodsData) {
        THNSkuModelItem *item = [[THNSkuModelItem alloc] initWithDictionary:dict];
        self.country = item.deliveryProvince;
        [models addObject:item];
    }
    
    return [models copy];
}

- (NSArray *)thn_changeExpressDataToModels:(NSArray *)expressData {
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSDictionary *dict in expressData) {
        THNFreightModelItem *item = [[THNFreightModelItem alloc] initWithDictionary:dict];
        [models addObject:item];
    }
    
    return [models copy];
}

- (void)thn_tableView:(UITableView *)tableView selectAtIndexPath:(NSIndexPath *)indexPath {
    THNSelectLogisticsTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.selected = NO;
    
    THNSelectLogisticsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    
    [self.priceView thn_setLogisticsPriceValue:cell.price];
    self.selectIndex = indexPath;
    
    self.didSelectedExpressItem(self.expressArr[indexPath.row - 1]);
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.goodsArr.count : self.expressArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85.0;
    }
    
    return indexPath.row == 0 ? 44.0 : 90.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNGoodsInfoTableViewCell *goodsCell = [THNGoodsInfoTableViewCell initGoodsInfoCellWithTableView:tableView
                                                                                                    type:(THNGoodsInfoCellTypeSelectLogistics)];
        if (self.goodsArr.count) {
            [goodsCell thn_setSkuGoodsInfoWithModel:self.goodsArr[indexPath.row]];
            goodsCell.showLine = indexPath.row == self.goodsArr.count - 1 ? NO : YES;
        }
        
        return goodsCell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            THNLogisticsPlaceTableViewCell *placeCell = [THNLogisticsPlaceTableViewCell initPlaceCellWithTableView:tableView];
                placeCell.place = self.country;
            
            return placeCell;
            
        } else {
            THNSelectLogisticsTableViewCell *logisticsCell = [THNSelectLogisticsTableViewCell initSelectLogisticsCellWithTableView:tableView];
            if (self.expressArr.count) {
                [logisticsCell thn_setLogisticsDataWithModel:self.expressArr[indexPath.row - 1]];
                logisticsCell.showLine = indexPath.row - 1 == self.goodsArr.count - 1 ? NO : YES;
            }
            
            return logisticsCell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    if (indexPath.row == 0) return;
    
    [self thn_tableView:tableView selectAtIndexPath:indexPath];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.iTableView];
    
    if (self.goodsArr.count && self.expressArr.count) {
        self.selectIndex = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.iTableView selectRowAtIndexPath:self.selectIndex
                                     animated:NO
                               scrollPosition:(UITableViewScrollPositionNone)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSelectLogistics;
}

#pragma mark - getters and setters
- (UITableView *)iTableView {
    if (!_iTableView) {
        _iTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _iTableView.delegate = self;
        _iTableView.dataSource = self;
        _iTableView.showsVerticalScrollIndicator = NO;
        _iTableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _iTableView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _iTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _iTableView.tableFooterView = self.priceView;
    }
    return _iTableView;
}

- (THNLogisticsPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[THNLogisticsPriceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 97)];
        [_priceView thn_setLogisticsPriceValue:18.0];
    }
    return _priceView;
}

@end
