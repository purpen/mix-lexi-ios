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

static NSString *const kUrlSearchUser = @"/core_platforms/search/users";
static NSString *const kSearchUserCellIdentifier = @"kSearchUserCellIdentifier";

@interface THNSearchUserTableViewController ()

@property (nonatomic, strong) NSArray *users;

@end

@implementation THNSearchUserTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSearchUserData];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.rowHeight = 68;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSearchUserTableViewCell" bundle:nil] forCellReuseIdentifier:kSearchUserCellIdentifier];
}

- (void)loadSearchUserData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"per_page"] = @10;
    params[@"qk"] = [THNSaveTool objectForKey:kSearchKeyword];
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchUser requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.users = [THNUserModel mj_objectArrayWithKeyValuesArray:result.data[@"users"]];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
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

@end
