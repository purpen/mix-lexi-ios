//
//  THNSettingViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNSettingViewController.h"
#import "THNSettingHeaderView.h"
#import <YYKit/YYKit.h>
#import "THNLoginManager.h"
#import "THNCustomTextTableViewCell.h"
#import "THNOrderViewController.h"
#import "THNAddressViewController.h"
#import "THNApplyStoreViewController.h"
#import "THNSettingUserInfoViewController.h"
#import "THNSettingAboutViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNBaseTabBarController.h"

/// cell id
static NSString *const kTextTableViewCellId = @"THNCustomTextTableViewCellId";
/// text
static NSString *const kTitleSetting = @"设置";
static NSString *const kTextLoginOut = @"退出登录";

@interface THNSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *settingTable;
@property (nonatomic, strong) THNSettingHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, strong) NSArray *mainTexts;
@property (nonatomic, strong) THNUserDataModel *userModel;
@property (nonatomic, assign) BOOL backHome;

@end

@implementation THNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
// 用户资料
- (void)thn_getUserData {
    self.userModel = [THNUserDataModel mj_objectWithKeyValues:[THNLoginManager sharedManager].userData];
    [self.headerView thn_setNickname:self.userModel.username headImageUrl:self.userModel.avatar];
}

#pragma mark - event response
- (void)loginOutButtonAction:(UIButton *)button {
    self.backHome = YES;
    [[THNLoginManager sharedManager] clearLoginInfo];
    [SVProgressHUD thn_showSuccessWithStatus:kTextLoginSuccess];
    [[THNLoginManager sharedManager]updateUserLivingHallStatus:NO storeId:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLivingHallStatus object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)openSettingUserController:(UITapGestureRecognizer *)tap {
    THNSettingUserInfoViewController *editUserInfoVC = [[THNSettingUserInfoViewController alloc] init];
    [self.navigationController pushViewController:editUserInfoVC animated:YES];
}

#pragma mark - private methods
- (YYLabel *)thn_creatSectionHeaderLabelWithText:(NSString *)text {
    YYLabel *textLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    textLabel.text = text;
    textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textContainerInset = UIEdgeInsetsMake(15, 15, 0, 0);
    
    return textLabel;
}

#pragma mark - setup UI
- (void)setupUI {
    self.settingTable.tableHeaderView = self.headerView;
    [self.view addSubview:self.settingTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self thn_getUserData];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSetting;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.backHome) {
        THNBaseTabBarController *rootTab = (THNBaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        rootTab.selectedIndex = 0;
    }
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self thn_creatSectionHeaderLabelWithText:self.sectionTitles[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCustomTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextTableViewCellId];
    if (!cell) {
        cell = [[THNCustomTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTextTableViewCellId];
    }
    
    [cell thn_setIconImageName:self.iconArr[indexPath.section][indexPath.row]
                      mainText:self.mainTexts[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0) {
        [cell thn_setSubText:@"未绑定" textColor:@"FF6666"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [SVProgressHUD thn_showSuccessWithStatus:@"绑定微信"];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            THNOrderViewController *orderVC = [[THNOrderViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
            
        } else {
            THNAddressViewController *addressVC = [[THNAddressViewController alloc] init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            THNApplyStoreViewController *applyVC = [[THNApplyStoreViewController alloc]init];
            [self.navigationController pushViewController:applyVC animated:YES];
            
        } else if (indexPath.row == 1) {
            THNSettingAboutViewController *aboutVC = [[THNSettingAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
    }
}

#pragma mark - getters and setters
- (UITableView *)settingTable {
    if (!_settingTable) {
        _settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _settingTable.delegate = self;
        _settingTable.dataSource = self;
        _settingTable.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _settingTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _settingTable.showsVerticalScrollIndicator = NO;
        _settingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingTable.tableFooterView = self.footerView;
    }
    return _settingTable;
}

- (THNSettingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNSettingHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 126)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(openSettingUserController:)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 44)];
        loginOutButton.backgroundColor = [UIColor whiteColor];
        loginOutButton.layer.cornerRadius = 4;
        loginOutButton.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.1].CGColor;
        loginOutButton.layer.shadowOffset = CGSizeMake(0, 0);
        loginOutButton.layer.shadowRadius = 4;
        loginOutButton.layer.shadowOpacity = 1;
        loginOutButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [loginOutButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [loginOutButton setTitle:kTextLoginOut forState:(UIControlStateNormal)];
        [loginOutButton addTarget:self action:@selector(loginOutButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_footerView addSubview:loginOutButton];
        
    }
    return _footerView;
}

- (NSArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = @[@"连接",
                           @"账户",
                           @"更多"];
    }
    return _sectionTitles;
}

- (NSArray *)iconArr {
    if (!_iconArr) {
        _iconArr = @[@[@"icon_setting_wechat"],
                     @[@"icon_setting_order", @"icon_setting_address",],
                     @[@"icon_setting_store", @"icon_setting_about", @"icon_setting_phone"]];
    }
    return _iconArr;
}

- (NSArray *)mainTexts {
    if (!_mainTexts) {
        _mainTexts = @[@[@"微信绑定"],
                       @[@"我的订单", @"收货地址"],
                       @[@"申请开馆", @"关于乐喜", @"客服电话 400-2345-0000"]];
    }
    return _mainTexts;
}

@end
