//
//  THNLifeCashBillDetailViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillDetailViewController.h"
#import "THNLifeCashBillInfoTableViewCell.h"
#import "THNLifeOrderProductTableViewCell.h"
#import "UIView+Helper.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

/// text
static NSString *const kTextDetail = @"收益详情";
/// cell id
static NSString *const kCashBillInfoTableViewCellId = @"THNLifeCashBillInfoTableViewCellId";
static NSString *const kOrderProductTableViewCellId = @"THNLifeOrderProductTableViewCellId";

@interface THNLifeCashBillDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *billTable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, strong) THNLifeCashBillOrderModel *dataModel;

@end

@implementation THNLifeCashBillDetailViewController

- (instancetype)initWithRid:(NSString *)rid detailModel:(THNLifeCashBillOrderModel *)model {
    self = [super self];
    if (self) {
        [self thn_getLifeOrderEarningsDetailWithOrderId:rid];
        self.dataModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
// 获取订单收益详情
- (void)thn_getLifeOrderEarningsDetailWithOrderId:(NSString *)orderId {
    if (!orderId.length) return ;
    
    [SVProgressHUD showInfoWithStatus:@""];
    
    WEAKSELF;
    [THNLifeManager getLifeOrdersSaleDetailCollectWithRid:orderId
                                                 storeRid:[THNLoginManager sharedManager].storeRid
                                               completion:^(NSArray *productData, NSError *error) {
                                                   [SVProgressHUD dismiss];
                                                   if (error) return ;
                                                   
                                                   weakSelf.goodsArr = [NSArray arrayWithArray:productData];
                                                   [weakSelf.billTable reloadData];
                                               }];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    
    [self.containerView addSubview:self.billTable];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeButton];
    [self.view addSubview:self.containerView];
    [self.containerView drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showTransform];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)thn_showTransform {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 92.0 : 115.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNLifeCashBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCashBillInfoTableViewCellId];
        if (!cell) {
            cell = [[THNLifeCashBillInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                           reuseIdentifier:kCashBillInfoTableViewCellId];
            cell.showDetail = NO;
        }
        
        if (self.dataModel) {
            [cell thn_setLifeCashBillOrderData:self.dataModel];
        }
        
        return cell;
    }
    
    THNLifeOrderProductTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:kOrderProductTableViewCellId];
    if (!productCell) {
        productCell = [[THNLifeOrderProductTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                              reuseIdentifier:kOrderProductTableViewCellId];
    }
    
    if (self.goodsArr.count) {
        productCell.showEearnings = YES;
        [productCell thn_setLifeOrderProductData:self.goodsArr[indexPath.row - 1]];
    }
    
    return productCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - getters and setters
- (UITableView *)billTable {
    if (!_billTable) {
        _billTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, 400) style:(UITableViewStylePlain)];
        _billTable.delegate = self;
        _billTable.dataSource = self;
        _billTable.backgroundColor = [UIColor whiteColor];
        _billTable.showsVerticalScrollIndicator = NO;
        _billTable.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _billTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _billTable.tableFooterView = [UIView new];
        _billTable.tableHeaderView = [UIView new];
    }
    return _billTable;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        _titleLabel.text = kTextDetail;
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame: \
                        CGRectMake(CGRectGetMaxX(self.titleLabel.frame) - 45, CGRectGetMinY(self.titleLabel.frame), 45, 45)];
        [_closeButton setImage:[UIImage imageNamed:@"icon_popup_close"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320) / 2, (SCREEN_HEIGHT - 400) / 2, 320, 400)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }
    return _containerView;
}

@end
