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
#import "THNPhotoManager.h"
#import "THNQiNiuUpload.h"

static NSString *const kTitleSetting    = @"编辑个人资料";
static NSString *const kTextSave        = @"保存";
/// key
static NSString *const kResultDataIds   = @"ids";
static NSString *const kKeyAvatarId     = @"avatar_id";
static NSString *const kKeyUsername     = @"username";
static NSString *const kKeyAboutMe      = @"about_me";
static NSString *const kKeyGender       = @"gender";
static NSString *const kKeyMail         = @"mail";
static NSString *const kKeyDate         = @"date";
static NSString *const kKeyAddress      = @"street_address";

@interface THNSettingUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *settingTable;
@property (nonatomic, strong) THNSettingUserView *headerView;
@property (nonatomic, strong) THNUserDataModel *userModel;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation THNSettingUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

#pragma mark - event response
- (NSDictionary *)thn_getEditUserInfoData {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.headerView.headId forKey:kKeyAvatarId];
    
    NSArray *allKey = @[kKeyUsername, kKeyAboutMe, kKeyMail, kKeyAddress, kKeyDate, kKeyGender];
    NSArray *allData = @[self.userModel.username,
                         self.userModel.about_me,
                         self.userModel.mail,
                         self.userModel.street_address,
                         self.userModel.date,
                         [NSString stringWithFormat:@"%zi", self.userModel.gender]];
    
    for (NSUInteger idx = 0; idx < allKey.count; idx ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        THNSettingInfoTableViewCell *cell = [self.settingTable cellForRowAtIndexPath:indexPath];
        NSString *obj = cell.editInfo.length ? cell.editInfo : allData[idx];
        [paramDict setObject:obj forKey:allKey[idx]];
    }
    return [paramDict copy];
}

#pragma mark - event response
- (void)saveButtonAction:(UIButton *)button {
    [SVProgressHUD thn_showWithStatus:nil maskType:(SVProgressHUDMaskTypeClear)];
    
    WEAKSELF;
    
    [[THNLoginManager sharedManager] updateUserProfileWithParams:[self thn_getEditUserInfoData]
                                                      completion:^(THNResponse *data, NSError *error) {
                                                          if (error) return ;
                                                          
                                                          [SVProgressHUD dismiss];
                                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                                      }];
}

- (void)openImageController:(UITapGestureRecognizer *)tap {
    WEAKSELF;
    
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [weakSelf.headerView thn_setHeaderImageWithData:imageData];
        
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData
                                                       compltion:^(NSDictionary *result) {
                                                           NSArray *idsArray = result[kResultDataIds];
                                                           weakSelf.headerView.headId = idsArray[0];
                                                       }];
    }];
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
    [self thn_getLoginUserData];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSetting;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(openImageController:)];
        [_headerView addGestureRecognizer:tap];
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
