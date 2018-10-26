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
#import "THNSaveTool.h"
#import "THNSearchView.h"

static NSString *const kSearchIndexCellIdentifier = @"kSearchIndexCellIdentifier";

@interface THNSearchIndexTableViewController ()<THNSearchViewDelegate>

@property (nonatomic, assign) SearchChildVCType childVCType;
@property (nonatomic, assign) BOOL isClickTextField;

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
    cell.textFieldText = self.textFieldText;
    [cell setSearchIndexModel:searchIndexModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
     THNSearchIndexModel *searchIndexModel = [THNSearchIndexModel mj_objectWithKeyValues:self.searchIndexs[indexPath.row]];
    THNSearchView *searchView = self.view.superview.subviews[0];
    searchView.delegate = self;
    [searchView addHistoryModelWithText:searchIndexModel.name];
    THNSearchDetailViewController *searchDetailVC = [[THNSearchDetailViewController alloc]init];
    searchDetailVC.searchDetailBlock = ^(NSString *searchWord, NSInteger childVCType, BOOL isClickTextFiled) {
        self.childVCType = childVCType;
        self.isClickTextField = isClickTextFiled;
        [searchView setSearchWord:searchWord];
    };
    searchDetailVC.childVCType = searchIndexModel.target_type - 1;
    [THNSaveTool setObject:searchIndexModel.name forKey:kSearchKeyword];
    [self.navigationController pushViewController:searchDetailVC animated:YES];
}

- (void)back {
    if (!self.isClickTextField) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        THNSearchDetailViewController *searchDetailVC = [[THNSearchDetailViewController alloc]init];
        searchDetailVC.searchDetailBlock = ^(NSString *searchWord, NSInteger childVCType, BOOL isClickTextFiled) {
            self.childVCType = childVCType;
              self.isClickTextField = isClickTextFiled;
        };
        [self.navigationController pushViewController:searchDetailVC animated:YES];
    }
}

// 隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view.superview endEditing:YES];
}

@end
