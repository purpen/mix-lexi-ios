//
//  THNPaySuccessViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaySuccessViewController.h"
#import "THNPaySuccessTintView.h"
#import "UIView+Helper.h"
#import "THNPaySuccessTableViewCell.h"
#import "THNOrderDetailLogisticsView.h"
#import "THNOrderDetailPayView.h"
#import "THNOrderDetailModel.h"
#import "THNOrderViewController.h"
#import "THNBaseTabBarController.h"

static NSString *const kPaySuccessCellIdentifier = @"kPaySuccessCellIdentifier";

@interface THNPaySuccessViewController ()

@property (nonatomic, strong) THNPaySuccessTintView *paySuccessTintView;
@property (nonatomic, strong) THNOrderDetailLogisticsView *logisticsView;
@property (nonatomic, strong) THNOrderDetailPayView *payDetailView;


@end

@implementation THNPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.navigationBarView.hidden = YES;
     CGFloat y = kDeviceiPhoneX ? -88 : -64;
    self.tableView.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    [self.tableView registerNib:[UINib nibWithNibName:@"THNPaySuccessTableViewCell" bundle:nil] forCellReuseIdentifier:kPaySuccessCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNPaySuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaySuccessCellIdentifier forIndexPath:indexPath];
    THNOrderDetailModel *detailModel = [THNOrderDetailModel mj_objectWithKeyValues:self.orders[indexPath.row]];
    [cell setDetailModel:detailModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderDetailModel *detailModel = [THNOrderDetailModel mj_objectWithKeyValues:self.orders[indexPath.row]];
    return detailModel.items.count * 95 + 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat payDetailViewHeight = [self.payDetailView setOrderDetailPayView:self.detailModel];
    return 110 + 221 + payDetailViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat payDetailViewHeight = [self.payDetailView setOrderDetailPayView:self.detailModel];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110 + 221 + payDetailViewHeight)];
    [headerView addSubview:self.paySuccessTintView];
    
    WEAKSELF
    self.paySuccessTintView.paySuccessTintViewBlcok = ^{
        THNOrderViewController *orderVC = [[THNOrderViewController alloc]init];
        orderVC.pushOrderDetailType = PushOrderDetailTypePaySuccess;
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    
    self.paySuccessTintView.paySuccessCloseBlock = ^{
        THNBaseTabBarController *tabVC = [[THNBaseTabBarController alloc]init];
        tabVC.selectedIndex = 0;
        [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    };
    
    self.logisticsView.frame = CGRectMake(0,CGRectGetMaxY(self.paySuccessTintView.frame), SCREEN_WIDTH, 110);
    [headerView addSubview:self.logisticsView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.logisticsView.frame), SCREEN_WIDTH, 0.5)];
    [headerView addSubview:lineView];
    [self.logisticsView setDetailModel:self.detailModel];
    self.payDetailView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH, payDetailViewHeight);
    [headerView addSubview:self.payDetailView];
    return headerView;
}

#pragma mark - lazy

- (THNOrderDetailLogisticsView *)logisticsView {
    if (!_logisticsView) {
        _logisticsView = [THNOrderDetailLogisticsView viewFromXib];
    }
    return _logisticsView;
}

- (THNOrderDetailPayView *)payDetailView {
    if (!_payDetailView) {
        _payDetailView = [THNOrderDetailPayView viewFromXib];
    }
    return _payDetailView;
}

- (THNPaySuccessTintView *)paySuccessTintView {
    if (!_paySuccessTintView) {
        _paySuccessTintView = [THNPaySuccessTintView viewFromXib];
        CGFloat height = 157 + 64;
        _paySuccessTintView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    }
    return _paySuccessTintView;
}


@end

