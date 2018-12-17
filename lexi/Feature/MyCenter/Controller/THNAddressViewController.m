//
//  THNAddressViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAddressViewController.h"
#import "THNAddressTableViewCell.h"
#import "THNNewlyAddressTableViewCell.h"
#import "THNNewShippingAddressViewController.h"

/// text
static NSString *const kTitleAddrss = @"收货地址";
/// key
static NSString *const kURLAddress  = @"/address";
static NSString *const kKeyData     = @"data";

@interface THNAddressViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNNavigationBarViewDelegate,
    THNAddressTableViewCellDelegate
>

@end

@interface THNAddressViewController ()

@property (nonatomic, strong) UITableView *addressTable;
@property (nonatomic, strong) NSMutableArray *addressArr;

@end

@implementation THNAddressViewController

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
        
        if (![result hasData] || !result.isSuccess) return ;
        
        for (NSDictionary *dict in result.responseDict[kKeyData]) {
            THNAddressModel *model = [[THNAddressModel alloc] initWithDictionary:dict];
            [weakSelf.addressArr addObject:model];
        }
        [weakSelf.addressTable reloadData];

    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
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
        THNAddressTableViewCell *addressCell = [THNAddressTableViewCell initAddressCellWithTableView:tableView
                                                                                                type:(THNAddressCellTypeNormal)];
        
        if (self.addressArr.count) {
            [addressCell thn_setAddressModel:self.addressArr[indexPath.row]];
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
    newAddressVC.isFromMycenter = YES;
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.addressTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self thn_requestAddressData];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleAddrss;
}

#pragma mark - getters and setters
- (UITableView *)addressTable {
    if (!_addressTable) {
        _addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _addressTable.delegate = self;
        _addressTable.dataSource = self;
        _addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addressTable.tableHeaderView = [UIView new];
        _addressTable.tableFooterView = [UIView new];
        _addressTable.showsVerticalScrollIndicator = NO;
        _addressTable.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _addressTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    }
    return _addressTable;
}

- (NSMutableArray *)addressArr {
    if (!_addressArr) {
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}


@end
