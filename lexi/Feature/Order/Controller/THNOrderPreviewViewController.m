//
//  THNOrderPreviewViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderPreviewViewController.h"
#import "THNPaySuccessViewController.h"
#import "THNSelectLogisticsViewController.h"
#import "THNBuyProgressView.h"
#import "THNOrderDetailLogisticsView.h"
#import "UIView+Helper.h"
#import "THNOrderDetailPayView.h"

static NSString *kTitleDone = @"提交订单";
static NSString *const kUrlCreateOrder = @"/orders/create";

@interface THNOrderPreviewViewController ()<UITableViewDelegate, UITableViewDataSource>

/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 进度条
@property (nonatomic, strong) THNBuyProgressView *progressView;
// 保存View
@property (nonatomic, strong) UIView *saveView;
// 寄送地址等信息
@property (nonatomic, strong) THNOrderDetailLogisticsView *logisticsView;
// 支付价格等明细
@property (nonatomic, strong) THNOrderDetailPayView *payDetailView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THNOrderPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
//    THNPaySuccessViewController *paySuccessVC = [[THNPaySuccessViewController alloc] init];
//    [self.navigationController pushViewController:paySuccessVC animated:YES];
    
    THNSelectLogisticsViewController *selectLogisticsVC = [[THNSelectLogisticsViewController alloc] init];
    [self.navigationController pushViewController:selectLogisticsVC animated:YES];
}

// 提交订单
- (void)commitOrder {
    
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.saveView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSubmitOrder;
}

#pragma mark - getters and setters
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

- (THNBuyProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[THNBuyProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44)
                                                            index:1];
    }
    return _progressView;
}

- (THNOrderDetailLogisticsView *)logisticsView {
    if (!_logisticsView) {
        _logisticsView = [THNOrderDetailLogisticsView viewFromXib];
    }
    return _logisticsView;
}

- (UIView *)saveView {
    if (!_saveView) {
        _saveView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_HEIGHT, 50)];
        _saveView.backgroundColor = [UIColor whiteColor];
        UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 40)];
        [saveButton setTitle:@"提交订单" forState:UIControlStateNormal];
        saveButton.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        [saveButton drawCornerWithType:0 radius:4];
        [saveButton addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
        [_saveView addSubview:saveButton];
    }
    return _saveView;
}

- (THNOrderDetailPayView *)payDetailView {
    if (!_payDetailView) {
        _payDetailView = [THNOrderDetailPayView viewFromXib];
    }
    return _payDetailView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource




@end
