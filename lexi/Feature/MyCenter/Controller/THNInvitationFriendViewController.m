//
//  THNInvitationFriendViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNInvitationFriendViewController.h"
#import "THNInvitationFriendTableViewCell.h"

static NSString *kTitleFriend = @"我的朋友";
///
static NSString *const kUserTableViewCellId = @"THNInvitationFriendTableViewCellId";

@interface THNInvitationFriendViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *userTableView;
@property (nonatomic, strong) NSMutableArray *modelArr;

@end

@implementation THNInvitationFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.userTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.title = kTitleFriend;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.modelArr.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNInvitationFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserTableViewCellId];
    if (!cell) {
        cell = [[THNInvitationFriendTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kUserTableViewCellId];
    }
    
    if (self.modelArr.count) {
//        [cell thn_setUserListCellModel:self.modelArr[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    THNUserModel *model = [THNUserModel mj_objectWithKeyValues:self.modelArr[indexPath.row]];
//
//    if ([[THNLoginManager sharedManager].userId isEqualToString:model.uid]) {
//        return;
//    }
//
//    THNUserCenterViewController *userCenterVC = [[THNUserCenterViewController alloc] initWithUserId:model.uid];
//    [self.navigationController pushViewController:userCenterVC animated:YES];
}

#pragma mark - getters and setters
- (UITableView *)userTableView {
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _userTableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.showsVerticalScrollIndicator = NO;
        _userTableView.backgroundColor = [UIColor whiteColor];
        _userTableView.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        _userTableView.tableFooterView = [UIView new];
    }
    return _userTableView;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
