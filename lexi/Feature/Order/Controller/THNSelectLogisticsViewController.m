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
#import "NSString+Helper.h"

static NSString *const kURLExpress = @"/logistics/same_template_express";

@interface THNSelectLogisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *expressTableView;
/// 商品数组
@property (nonatomic, strong) NSArray *goodsArr;
/// 快递数组
@property (nonatomic, strong) NSMutableArray *expressArr;
/// 发货地
@property (nonatomic, strong) NSString *country;
/// 运费预览视图
@property (nonatomic, strong) THNLogisticsPriceView *priceView;
/// 选中的
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation THNSelectLogisticsViewController

- (instancetype)initWithGoodsData:(NSArray *)goodsData logisticsData:(NSDictionary *)expressParam {
    self = [super self];
    if (self) {
        self.goodsArr = [self thn_changeGoodsSkuDataToModes:goodsData];
        [self requestSameTemplateExpressWithParams:expressParam];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)requestSameTemplateExpressWithParams:(NSDictionary *)params {
    [SVProgressHUD thn_show];
    
    NSString *paramsExpressId = params[@"items"][0][@"express_id"];
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI postWithUrlString:kURLExpress requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        };
        
        for (NSDictionary *dict in result.data) {
            THNFreightModelItem *model = [[THNFreightModelItem alloc] initWithDictionary:dict];
            [weakSelf.expressArr addObject:model];
        }
    
        [weakSelf thn_defaultSelectedWithExpress:paramsExpressId];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showInfoWithStatus:[error localizedDescription]];
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

- (NSUInteger)thn_getDefaultExpressIndexWithId:(NSString *)expressId {
    for (THNFreightModelItem *model in self.expressArr) {
        if (model.expressId == [expressId integerValue]) {
            return [self.expressArr indexOfObject:model];
        }
    }
    
    return 0;
}

- (void)thn_defaultSelectedWithExpress:(NSString *)express {
    if (!self.expressArr.count) return;
    
    NSUInteger index = [self thn_getDefaultExpressIndexWithId:express];
    
    self.selectIndex = [NSIndexPath indexPathForRow:index + 1 inSection:1];
    [self.expressTableView selectRowAtIndexPath:self.selectIndex
                                       animated:NO
                                 scrollPosition:(UITableViewScrollPositionNone)];
    
    THNFreightModelItem *item = self.expressArr[index];
    [self.priceView thn_setLogisticsPriceValue:item.freight];
    
    [self.expressTableView reloadData];
}

- (void)thn_tableView:(UITableView *)tableView selectAtIndexPath:(NSIndexPath *)indexPath {
    THNSelectLogisticsTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.isSelected = NO;
    
    THNSelectLogisticsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    
    [self.priceView thn_setLogisticsPriceValue:cell.price];
    self.selectIndex = indexPath;
    
    if (self.didSelectedExpressItem) {
        self.didSelectedExpressItem(self.expressArr[indexPath.row - 1]);
    }
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
                logisticsCell.isSelected = indexPath == self.selectIndex;
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
    
    [self.view addSubview:self.expressTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSelectLogistics;
}

#pragma mark - getters and setters
- (UITableView *)expressTableView {
    if (!_expressTableView) {
        _expressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _expressTableView.delegate = self;
        _expressTableView.dataSource = self;
        _expressTableView.showsVerticalScrollIndicator = NO;
        _expressTableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _expressTableView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _expressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _expressTableView.tableFooterView = self.priceView;
    }
    return _expressTableView;
}

- (THNLogisticsPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[THNLogisticsPriceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 97)];
    }
    return _priceView;
}

- (NSMutableArray *)expressArr {
    if (!_expressArr) {
        _expressArr = [NSMutableArray array];
    }
    return _expressArr;
}

@end
