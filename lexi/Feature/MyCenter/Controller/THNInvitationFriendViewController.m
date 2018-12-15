//
//  THNInvitationFriendViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNInvitationFriendViewController.h"
#import "THNInvitationFriendTableViewCell.h"
#import "UIScrollView+THNMJRefresh.h"

/// text
static NSString *kTitleFriend = @"我的朋友";
/// cell id
static NSString *const kUserTableViewCellId = @"THNInvitationFriendTableViewCellId";
/// api
static NSString *const kURLFriends = @"/invite_life/friends";

@interface THNInvitationFriendViewController () <UITableViewDelegate, UITableViewDataSource, THNMJRefreshDelegate>

@property (nonatomic, strong) UITableView *userTableView;
@property (nonatomic, strong) NSMutableArray *modelArr;

@end

@implementation THNInvitationFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [SVProgressHUD thn_show];
    [self requestInviteFriendsDataWithPage:1];
}

#pragma mark - custom delegate
- (void)beginRefreshing {
    [self.modelArr removeAllObjects];
    [self.userTableView resetCurrentPageNumber];
    [self.userTableView resetNoMoreData];
    [self requestInviteFriendsDataWithPage:1];
}

- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    [self requestInviteFriendsDataWithPage:currentPage.integerValue];
}

#pragma mark - network
- (void)requestInviteFriendsDataWithPage:(NSInteger)page {
    NSDictionary *params = @{@"page"    : @(page),
                             @"per_page": @(10)};
    
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLFriends requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.userTableView endHeaderRefresh];
        
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            [weakSelf.userTableView endFooterRefreshAndCurrentPageChange:NO];
            return ;
        }

        THNLog(@"邀请的朋友：%@", [NSString jsonStringWithObject:result.responseDict]);
        [weakSelf.userTableView endFooterRefreshAndCurrentPageChange:YES];
        THNInviteFriendsModel *model = [[THNInviteFriendsModel alloc] initWithDictionary:result.data];
        if (model.friends.count) {
            [weakSelf.modelArr addObjectsFromArray:model.friends];
            
        } else {
            [weakSelf.userTableView noMoreData];
        }
        
        [weakSelf.userTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        [weakSelf.userTableView endHeaderRefreshAndCurrentPageChange:NO];
        [weakSelf.userTableView endFooterRefreshAndCurrentPageChange:NO];
    }];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.userTableView];
    
    [self.userTableView setRefreshHeaderWithClass:nil beginRefresh:NO animation:NO delegate:self];
    [self.userTableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.userTableView resetCurrentPageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.title = kTitleFriend;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
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
        [cell thn_setInviteFriendModel:self.modelArr[indexPath.row]];
    }
    
    return cell;
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
