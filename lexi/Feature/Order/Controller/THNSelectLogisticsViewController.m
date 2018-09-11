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
#import "THNLogisticsPriceView.h"

@interface THNSelectLogisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *iTableView;
/// 商品数组
@property (nonatomic, strong) NSMutableArray *goodsArr;
/// 快递数组
@property (nonatomic, strong) NSMutableArray *logisticsArr;
/// 运费预览视图
@property (nonatomic, strong) THNLogisticsPriceView *priceView;

@end

@implementation THNSelectLogisticsViewController

- (instancetype)initWithGoodsData:(NSArray *)goodsData logisticsData:(NSArray *)logisticsData {
    self = [super self];
    if (self) {
        [self.goodsArr addObjectsFromArray:goodsData];
        [self.logisticsArr addObjectsFromArray:logisticsData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 85 : 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? [UIView new] : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 44.0;
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
            [goodsCell thn_setGoodsInfoWithModel:self.goodsArr[indexPath.row]];
        }
        
        return goodsCell;
        
    } else if (indexPath.section == 1) {
        THNSelectLogisticsTableViewCell *logisticsCell = [THNSelectLogisticsTableViewCell initSelectLogisticsCellWithTableView:tableView];
        if (self.logisticsArr.count) {
            [logisticsCell thn_setLogisticsDataWithModel:self.logisticsArr[indexPath.row]];
        }
        
        return logisticsCell;
    }
    
    return nil;
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.iTableView];
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

- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

- (NSMutableArray *)logisticsArr {
    if (!_logisticsArr) {
        _logisticsArr = [NSMutableArray array];
    }
    return _logisticsArr;
}

@end
