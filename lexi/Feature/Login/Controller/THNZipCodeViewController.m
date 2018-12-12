//
//  THNZipCodeViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNZipCodeViewController.h"
#import <YYKit/YYKit.h>
#import "THNAreaModel.h"
#import "THNZipCodeTableViewCell.h"
#import "UIView+Helper.h"

/// 获取手机号地区编码
static NSString *const kURLAreaCode = @"/auth/area_code";
static NSString *const kParamStatus = @"status";
/// text
static NSString *const kTextTitle   = @"选择国家与地区";
static NSString *const kTextHint    = @"常用";
/// tableViewCell id
static NSString *const kTableViewCellIdentifier = @"THNZipCodeTableViewCellId";

@interface THNZipCodeViewController () <UITableViewDelegate, UITableViewDataSource>

/// 国家区号列表
@property (nonatomic, strong) UITableView *zipCodeTable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YYLabel *hintLabel;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 国家区号数据
@property (nonatomic, strong) NSArray *zipCodeArray;

@end

@implementation THNZipCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self networkGetAreaCode];
}

#pragma mark - network
- (void)networkGetAreaCode {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI getWithUrlString:kURLAreaCode requestDictionary:@{kParamStatus: @(1)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        THNAreaModel *areaModel = [THNAreaModel mj_objectWithKeyValues:result.data];
        weakSelf.zipCodeArray = [NSArray arrayWithArray:areaModel.area_codes];
        [weakSelf.zipCodeTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView delegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zipCodeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.hintLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNZipCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell) {
        cell = [[THNZipCodeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTableViewCellIdentifier];
    }
    
    if (self.zipCodeArray.count) {
        [cell thn_setAreaCodeInfoModel:self.zipCodeArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zipCodeArray.count) {
        THNAreaCodeModel *codeModel = self.zipCodeArray[indexPath.row];
        
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectAreaCodeBlock(codeModel.areacode);
        }];
    }
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.zipCodeTable];
    [self.view addSubview:self.closeButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(kDeviceiPhoneX ? -60 : -30);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (UITableView *)zipCodeTable {
    if (!_zipCodeTable) {
        _zipCodeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                     style:(UITableViewStylePlain)];
        _zipCodeTable.delegate = self;
        _zipCodeTable.dataSource = self;
        _zipCodeTable.tableFooterView = [UIView new];
        _zipCodeTable.tableHeaderView = self.titleLabel;
        _zipCodeTable.bounces = NO;
        _zipCodeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _zipCodeTable.showsVerticalScrollIndicator = NO;
    }
    return _zipCodeTable;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextTitle;
    }
    return _titleLabel;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _hintLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.text = kTextHint;
        _hintLabel.textContainerInset = UIEdgeInsetsMake(5, 20, 0, 0);
        
        [_hintLabel drawViewBorderType:(UIViewBorderLineTypeBottom) width:1 color:[UIColor colorWithHexString:@"#E9E9E9"]];
    }
    return _hintLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_black"] forState:(UIControlStateNormal)];
        [_closeButton setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

@end
