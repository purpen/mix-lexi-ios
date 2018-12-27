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
#import "THNObtainedView.h"
#import "THNPaySuccessViewController.h"
#import "THNOrderDetailPayView.h"
#import "UIView+Helper.h"
#import "THNOrderDetailModel.h"
#import "THNPayManger.h"
#import "THNSelectAddressViewController.h"

static NSString *kTitleDone     = @"确认下单";
static NSString *kTextPayment   = @"选择支付方式";
static NSString *const kUrlRecordingPayType = @"/orders/pay_type";

@interface THNPaymentViewController ()<
UITableViewDelegate,
UITableViewDataSource,
THNNavigationBarViewDelegate
>

/// 进度条
@property (nonatomic, strong) THNBuyProgressView *progressView;
/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 支付方式
@property (nonatomic, strong) UITableView *paymentTable;
/// 价格
@property (nonatomic, strong) THNOrderDetailPayView *payDetailView;
///
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation THNPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadPaymentDetail) name:THNPayMentVCPayCallback object:nil];
    [self setupUI];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    [[THNPayManger sharedManager] loadThirdPayParamsWithRid:self.orderRid
                                        withFromPaymentType:FromPaymentTypePaymentVC
                                            withPaymentType:[self thn_getPaymentType]];
}



// 后台返回支付结果和支付详情
- (void)loadPaymentDetail {
    NSString *requestUrl = [NSString stringWithFormat:@"/orders/after_payment/%@",self.orderRid];
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        if ([result.data[@"pay_status"] isEqualToString:@"SUCCESS"]) {
            THNPaySuccessViewController *successVC = [[THNPaySuccessViewController alloc]init];
            successVC.detailModel = [THNOrderDetailModel mj_objectWithKeyValues:result.data];
            successVC.orders = result.data[@"orders"];
            [self.navigationController pushViewController:successVC animated:YES];
        } else {
            [SVProgressHUD thn_showInfoWithStatus:@"支付失败"];
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}



#pragma mark - private methods
- (THNPaymentType)thn_getPaymentType {
    switch (self.selectIndex.row) {
        case 0:
            return THNPaymentTypeWechat;
        case 1:
            return THNPaymentTypeAlipay;
        default:
            return THNPaymentTypeHuabei;
    }
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    CGFloat payDetailViewHeight = [self.payDetailView setOrderDetailPayView:self.detailModel];
    self.payDetailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, payDetailViewHeight);
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.paymentTable];
    [self.view addSubview:self.doneButton];
    self.paymentTable.tableHeaderView = self.payDetailView;
    [self.navigationBarView setNavigationBackButton];
    self.selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitlePayment;
}

- (void)recordingPayType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.orderRid;
    params[@"pay_type"] = @([self thn_getPaymentType]);
    THNRequest *request = [THNAPI postWithUrlString:kUrlRecordingPayType requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        // 从商品详情跳转中间Present出一个新的导航控制器过来的，直接diss
        if ([self.navigationController.viewControllers[0] isKindOfClass:[THNSelectAddressViewController class]]) {
             [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

       
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
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
    return 54.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNHeaderTitleView *titleView = [[THNHeaderTitleView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)
                                                                         title:kTextPayment];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    [headerView addSubview:titleView];
    
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
    if (indexPath == self.selectIndex) {
        paymentCell.isSelectedPayment = YES;
    }
    return paymentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNPaymentTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.isSelectedPayment = NO;
    
    THNPaymentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelectedPayment = YES;

    self.selectIndex = indexPath;
}

#pragma mark - THNNavigationBarViewDelegate
- (void)didNavigationBackButtonEvent {
    WEAKSELF;
    THNObtainedView *obtainedMuseumView = [THNObtainedView sharedManager];
    [obtainedMuseumView show:@"确认离开付款页面" withRightButtonTitle:@"继续支付" withLeftButtonTitle:@"确认离开"];
    
    obtainedMuseumView.obtainedleftBlock = ^{
        [weakSelf recordingPayType];
    };
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
                         CGRectMake(0, CGRectGetMaxY(self.progressView.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.progressView.frame) - originBottom)
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

- (THNOrderDetailPayView *)payDetailView {
    if (!_payDetailView) {
        _payDetailView = [THNOrderDetailPayView viewFromXib];
    }
    return _payDetailView;
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