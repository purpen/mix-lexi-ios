//
//  THNLifeCashBillDetailViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillDetailViewController.h"
#import "THNLifeCashBillInfoTableViewCell.h"
#import "UIView+Helper.h"

/// text
static NSString *const kTextDetail = @"收益详情";
/// cell id
static NSString *const kCashBillInfoTableViewCellId = @"THNLifeCashBillInfoTableViewCellId";

@interface THNLifeCashBillDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *billTable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation THNLifeCashBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];

    [self.view addSubview:self.billTable];
//    [self.billTable drawCornerWithType:(UILayoutCornerRadiusBottom) radius:4];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel drawCornerWithType:(UILayoutCornerRadiusTop) radius:4];
    
    [self.view addSubview:self.closeButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 92.0 : 114.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLifeCashBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCashBillInfoTableViewCellId];
    if (!cell) {
        cell = [[THNLifeCashBillInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kCashBillInfoTableViewCellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showInfoWithStatus:@"商品详情"];
}

#pragma mark - getters and setters
- (UITableView *)billTable {
    if (!_billTable) {
        _billTable = [[UITableView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320) / 2, (SCREEN_HEIGHT - 400) / 2 + 45, 320, 400) style:(UITableViewStylePlain)];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320) / 2, CGRectGetMinY(self.billTable.frame) - 45, 320, 45)];
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

@end
