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

static NSString *kTitleDone  = @"继续以确认订单";
///
static NSString *kURLAddress = @"/address";
static NSString *kKeyData    = @"data";

@interface THNSelectAddressViewController () <THNNavigationBarViewDelegate, UITableViewDelegate, UITableViewDataSource>

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
    [self thn_requestAddressData];
}

#pragma mark - network
- (void)thn_requestAddressData {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLAddress requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"------------- 收货地址：%@", result.responseDict);
        [SVProgressHUD dismiss];
        
        for (NSDictionary *dict in result.responseDict[kKeyData]) {
            THNAddressModel *model = [[THNAddressModel alloc] initWithDictionary:dict];
            [self.addressArr addObject:model];
        }
        
        [self.addressTable reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    THNOrderPreviewViewController *orderPreviewVC = [[THNOrderPreviewViewController alloc] init];
    [self.navigationController pushViewController:orderPreviewVC animated:YES];
}

- (void)thn_tableView:(UITableView *)tableView selectAddressAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    
    THNAddressTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:weakSelf.selectedIndex];
    selectedCell.isSelected = NO;
    
    THNAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    
    weakSelf.selectedIndex = indexPath;
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
        THNAddressTableViewCell *addressCell = [THNAddressTableViewCell initAddressCellWithTableView:tableView];
        
        if (self.addressArr.count) {
            [addressCell thn_setAddressModel:self.addressArr[indexPath.row]];
            
            WEAKSELF;
            addressCell.selectedCellCompleted = ^{
                [weakSelf thn_tableView:tableView selectAddressAtIndexPath:indexPath];
            };
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
    
    [self.navigationController pushViewController:newAddressVC animated:YES];
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
