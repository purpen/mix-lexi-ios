//
//  THNPaymentViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaymentViewController.h"
#import "THNBuyProgressView.h"
#import "THNPaymentTableViewCell.h"
#import "THNHeaderTitleView.h"
#import "THNPaymentPriceView.h"

static NSString *kTitleDone     = @"确认下单";
static NSString *kTextPayment   = @"选择支付方式";

@interface THNPaymentViewController () <UITableViewDelegate, UITableViewDataSource>

/// 进度条
@property (nonatomic, strong) THNBuyProgressView *progressView;
/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 支付方式
@property (nonatomic, strong) UITableView *paymentTable;
/// 价格
@property (nonatomic, strong) THNPaymentPriceView *priceView;
///
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation THNPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    switch ([self thn_getPaymentType]) {
        case THNPaymentTypeWechat: {
            [SVProgressHUD showSuccessWithStatus:@"微信支付"];
        }
            break;
            
        case THNPaymentTypeAlipay: {
            [SVProgressHUD showSuccessWithStatus:@"支付宝"];
        }
            break;
            
        case THNPaymentTypeHuabei: {
            [SVProgressHUD showSuccessWithStatus:@"花呗"];
        }
            break;
    }
}

#pragma mark - private methods
- (THNPaymentType)thn_getPaymentType {
    return (THNPaymentType)self.selectIndex.row;
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.paymentTable];
    [self.view addSubview:self.doneButton];
    
    // 示例
    [self.priceView thn_setPriceValue:self.paymentAmount totalPriceValue:self.totalPrice freightValue:self.totalFreight];
    self.paymentTable.tableHeaderView = self.priceView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitlePayment;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNHeaderTitleView *headerView = [[THNHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                                                                         title:kTextPayment];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNPaymentTableViewCell *paymentCell = [THNPaymentTableViewCell initPaymentCellWithTableView:tableView];
    [paymentCell thn_setPaymentTypeWithType:(THNPaymentType)indexPath.row];
    
    return paymentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNPaymentTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.selected = NO;
    
    THNPaymentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;

    self.selectIndex = indexPath;
}

#pragma mark - getters and setters
- (THNBuyProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[THNBuyProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44)
                                                            index:2];
    }
    return _progressView;
}

- (UITableView *)paymentTable {
    if (!_paymentTable) {
        CGFloat originBottom = kDeviceiPhoneX ? 82 : 50;
        _paymentTable = [[UITableView alloc] initWithFrame: \
                         CGRectMake(0, CGRectGetMaxY(self.progressView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.progressView.frame) - originBottom)
                                                     style:(UITableViewStyleGrouped)];
        _paymentTable.delegate = self;
        _paymentTable.dataSource = self;
        _paymentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _paymentTable.tableFooterView = [UIView new];
        _paymentTable.showsVerticalScrollIndicator = NO;
        _paymentTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _paymentTable.bounces = NO;
        _paymentTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    }
    return _paymentTable;
}

- (THNPaymentPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[THNPaymentPriceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    }
    return _priceView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        CGFloat originBottom = kDeviceiPhoneX ? 77 : 45;
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - originBottom, SCREEN_WIDTH - 30, 40)];
        [_doneButton setTitle:kTitleDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
