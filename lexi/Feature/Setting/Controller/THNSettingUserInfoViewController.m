//
//  THNSettingUserInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNSettingUserInfoViewController.h"
#import "THNSettingUserView.h"
#import "THNLoginManager.h"
#import "THNSettingInfoTableViewCell.h"

static NSString *const kTitleSetting = @"编辑个人资料";
static NSString *const kTextSave     = @"保存";

@interface THNSettingUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *settingTable;
@property (nonatomic, strong) THNSettingUserView *headerView;
@property (nonatomic, strong) THNUserDataModel *userModel;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation THNSettingUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_getLoginUserData];
    [self setupUI];
}

#pragma mark - event response
- (void)saveButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"保存资料"];
}

#pragma mark - private methods
- (void)thn_getLoginUserData {
    self.userModel = [THNUserDataModel mj_objectWithKeyValues:[THNLoginManager sharedManager].userData];
    [self.headerView thn_setUserInfoData:self.userModel];
    self.settingTable.tableHeaderView = self.headerView;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.settingTable];
    [self.view addSubview:self.saveButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSetting;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSettingInfoTableViewCell *cell = [THNSettingInfoTableViewCell initCellWithTableView:tableView
                                                                                      tyep:(THNSettingInfoType)indexPath.row];
    if (self.userModel) {
        [cell thn_setUserInfoData:self.userModel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - getters and setters
- (UITableView *)settingTable {
    if (!_settingTable) {
        CGFloat originBottom = kDeviceiPhoneX ? 82 : 50;
        _settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - originBottom)
                                                     style:(UITableViewStylePlain)];
        _settingTable.delegate = self;
        _settingTable.dataSource = self;
        _settingTable.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _settingTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _settingTable.showsVerticalScrollIndicator = NO;
        _settingTable.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _settingTable.tableFooterView = [UIView new];
    }
    return _settingTable;
}

- (THNSettingUserView *)headerView {
    if (!_headerView) {
        _headerView = [[THNSettingUserView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
    }
    return _headerView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.settingTable.frame) + 5, SCREEN_WIDTH - 30, 40)];
        _saveButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _saveButton.layer.cornerRadius = 4;
        [_saveButton setTitle:kTextSave forState:(UIControlStateNormal)];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveButton;
}

@end
