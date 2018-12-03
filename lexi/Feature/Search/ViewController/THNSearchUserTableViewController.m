//
//  THNSearchUserTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchUserTableViewController.h"
#import "UIColor+Extension.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNUserModel.h"
#import "THNSaveTool.h"
#import "THNConst.h"
#import "THNSearchUserTableViewCell.h"
#import "UIScrollView+THNMJRefresh.h"
#import "SVProgressHUD+Helper.h"
#import "UIViewController+THNHud.h"

static NSString *const kUrlSearchUser = @"/core_platforms/search/users";
static NSString *const kSearchUserCellIdentifier = @"kSearchUserCellIdentifier";

@interface THNSearchUserTableViewController () <THNMJRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *users;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNSearchUserTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadSearchUserData];
}

- (void)setupUI {
    self.tableView.rowHeight = 68;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSearchUserTableViewCell" bundle:nil] forCellReuseIdentifier:kSearchUserCellIdentifier];
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadSearchUserData {

    if (self.currentPage == 1) {
        self.isTransparent = YES;
        [self showHud];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"qk"] = [THNSaveTool objectForKey:kSearchKeyword];
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchUser requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        [self.tableView endFooterRefreshAndCurrentPageChange:YES];
        NSArray *users = result.data[@"users"];
        [self.users addObjectsFromArray:[THNUserModel mj_objectArrayWithKeyValuesArray:users]];
        
        if (![result.data[@"next"] boolValue] && self.users.count != 0) {
            [self.tableView noMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadSearchUserData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchUserCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNUserModel *userModel = self.users[indexPath.row];
    [cell setUserModel:userModel];
    return cell;
}

- (NSMutableArray *)users {
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
