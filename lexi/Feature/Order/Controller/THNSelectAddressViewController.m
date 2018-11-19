//
//  THNSelectAddressViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectAddressViewController.h"
#import "THNOrderPreviewViewController.h"
#import "THNBuyProgressView.h"
#import "THNAddressTableViewCell.h"
#import "THNNewlyAddressTableViewCell.h"
#import "NSString+Helper.h"
#import "THNNewShippingAddressViewController.h"

static NSString *const kTitleDone  = @"继续以确认订单";
///
static NSString *const kURLAddress = @"/address";
static NSString *const kKeyData    = @"data";

@interface THNSelectAddressViewController () <
    THNNavigationBarViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    THNAddressTableViewCellDelegate
>

/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 进度条
@property (nonatomic, strong) THNBuyProgressView *progressView;
/// 收货地址
@property (nonatomic, strong) UITableView *addressTable;
/// 数据
@property (nonatomic, strong) NSMutableArray *addressArr;
/// 选中的单元格
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation THNSelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)thn_requestAddressData {
    if (self.addressArr.count) {
        [self.addressArr removeAllObjects];
    }
    
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI getWithUrlString:kURLAddress requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        for (NSDictionary *dict in result.responseDict[kKeyData]) {
            THNAddressModel *model = [[THNAddressModel alloc] initWithDictionary:dict];
            [weakSelf.addressArr addObject:model];
        }
        [weakSelf thn_setDefaultAddress];
        [weakSelf.addressTable reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    THNOrderPreviewViewController *orderPreviewVC = [[THNOrderPreviewViewController alloc] init];
    orderPreviewVC.addressModel = [self thn_getSelectedAddress];
    orderPreviewVC.skuItems = self.selectedSkuItems;
    orderPreviewVC.totalPrice = self.goodsTotalPrice;
    [self.navigationController pushViewController:orderPreviewVC animated:YES];
}

#pragma mark - custom delegate
- (void)thn_didSelectedAddressCell:(THNAddressTableViewCell *)cell {
    if (self.selectedIndex == [self.addressTable indexPathForCell:cell]) {
        return;
    }
    
    self.selectedIndex = [self.addressTable indexPathForCell:cell];
    [self.addressTable reloadData];
}

#pragma mark - private methods
- (void)thn_setDefaultAddress {
    if (!self.addressArr.count) {
        self.selectedIndex = nil;
        [self thn_setDoneButtonStatus:NO];
        
        return;
    }
    
    self.selectedIndex = self.selectedIndex ? self.selectedIndex : [NSIndexPath indexPathForRow:0 inSection:0];
    [self thn_setDoneButtonStatus:YES];
}

/**
 跨境物流
 */
- (BOOL)thn_isOverseasLogistics {
    if (!self.selectedIndex) {
        return NO;
    }

    THNAddressModel *selectAddress = self.addressArr[self.selectedIndex.row];
    if (![self.deliveryCountrys containsObject:selectAddress.countryName]) {
        return YES;
    }
    
    return NO;
}

/**
 获取选择的地址
 */
- (THNAddressModel *)thn_getSelectedAddress {
    if (!self.addressArr.count && !self.selectedIndex) {
        return nil;
    }
    
    return self.addressArr[self.selectedIndex.row];
}

/**
 完成按钮是否可选
 */
- (void)thn_setDoneButtonStatus:(BOOL)status {
    self.doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:status ? 1 : 0.5];
    self.doneButton.userInteractionEnabled = status;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.addressArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 105.0 : 40.0;
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
    return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNAddressTableViewCell *addressCell = [THNAddressTableViewCell initAddressCellWithTableView:tableView
                                                                                                type:(THNAddressCellTypeSelect)];
        
        if (self.addressArr.count) {
            addressCell.model = self.addressArr[indexPath.row];
            addressCell.isSelected = indexPath == self.selectedIndex;
            addressCell.delegate = self;
        }
        
        return addressCell;
        
    } else {
        THNNewlyAddressTableViewCell *newlyCell = [THNNewlyAddressTableViewCell initNewlyAddressCellWithTableView:tableView];
        return newlyCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNNewShippingAddressViewController *newAddressVC = [[THNNewShippingAddressViewController alloc] init];
    if (indexPath.section == 0) {
        newAddressVC.addressModel = self.addressArr[indexPath.row];
    }
    newAddressVC.isSaveCustom = [self thn_isOverseasLogistics];
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.addressTable];
    [self.view addSubview:self.doneButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self thn_requestAddressData];
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    self.navigationBarView.title = kTitleSelectAddress;
    [self.navigationBarView setNavigationLeftButtonOfImageNamed:@"icon_back_gray"];
    
    WEAKSELF;
    
    [self.navigationBarView didNavigationLeftButtonCompletion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - getters and setters
- (UITableView *)addressTable {
    if (!_addressTable) {
        CGFloat originBottom = kDeviceiPhoneX ? 82 : 50;
        _addressTable = [[UITableView alloc] initWithFrame: \
                         CGRectMake(0, CGRectGetMaxY(self.progressView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.progressView.frame) - originBottom)
                                                     style:(UITableViewStyleGrouped)];
        _addressTable.delegate = self;
        _addressTable.dataSource = self;
        _addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addressTable.tableHeaderView = [UIView new];
        _addressTable.tableFooterView = [UIView new];
        _addressTable.showsVerticalScrollIndicator = NO;
        _addressTable.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
        _addressTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    }
    return _addressTable;
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

- (THNBuyProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[THNBuyProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44)
                                                            index:0];
    }
    return _progressView;
}

- (NSMutableArray *)addressArr {
    if (!_addressArr) {
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}

@end
