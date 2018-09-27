//
//  THNSearchIndexTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchIndexTableViewController.h"
#import "UIColor+Extension.h"
#import "THNSearchIndexTableViewCell.h"
#import "THNSearchIndexModel.h"
#import <MJExtension/MJExtension.h>
#import "THNSearchDetailViewController.h"

static NSString *const kSearchIndexCellIdentifier = @"kSearchIndexCellIdentifier";

@interface THNSearchIndexTableViewController ()

@end

@implementation THNSearchIndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.separatorColor = [UIColor colorWithHexString:@"e9e9e9"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSearchIndexTableViewCell" bundle:nil] forCellReuseIdentifier:kSearchIndexCellIdentifier];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchIndexs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSearchIndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchIndexCellIdentifier forIndexPath:indexPath];
    THNSearchIndexModel *searchIndexModel = [THNSearchIndexModel mj_objectWithKeyValues:self.searchIndexs[indexPath.row]];
    cell.searchWord = self.searchWord;
    [cell setSearchIndexModel:searchIndexModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSearchDetailViewController *searchDetailVC = [[THNSearchDetailViewController alloc]init];
    [self.navigationController pushViewController:searchDetailVC animated:YES];
}

@end
