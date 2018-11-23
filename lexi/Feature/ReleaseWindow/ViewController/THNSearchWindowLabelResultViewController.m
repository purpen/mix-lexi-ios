//
//  THNSearchWindowLabelResultViewController.m
//  lexi
//
//  Created by rhp on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchWindowLabelResultViewController.h"
#import "THNShopWindowHotLabelTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNHotKeywordModel.h"
#import "THNSearchView.h"
#import "THNShopWindowResultHeaderView.h"
#import "UIView+Helper.h"
#import "THNMarco.h"

static NSString *const kWindowLabelResultCellIdentifier = @"kWindowLabelResultCellIdentifier";

@interface THNSearchWindowLabelResultViewController ()<THNSearchViewDelegate>

@property (nonatomic, strong) THNShopWindowResultHeaderView *resultHeaderView;

@end

@implementation THNSearchWindowLabelResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.separatorColor = [UIColor colorWithHexString:@"e9e9e9"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kWindowLabelResultCellIdentifier];
}

- (void)setTextFieldText:(NSMutableString *)textFieldText {
    _textFieldText = textFieldText;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",self.textFieldText];
    NSArray *filters = [self.searchIndexs filteredArrayUsingPredicate:predicate];
    if (filters.count == 0) {
        self.resultHeaderView.name = self.textFieldText;

        WEAKSELF;
        self.resultHeaderView.resultHeaderViewBlock = ^{
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };

        self.tableView.tableHeaderView = self.resultHeaderView;
    } else {
        self.tableView.tableHeaderView = [[UIView alloc]init];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchIndexs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNHotKeywordModel *searchIndexModel = self.searchIndexs[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWindowLabelResultCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"# %@", searchIndexModel.name];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNHotKeywordModel *searchIndexModel = self.searchIndexs[indexPath.row];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"addLabelSuccess" object:nil userInfo:@{@"name":searchIndexModel.name}];
}

- (THNShopWindowResultHeaderView *)resultHeaderView {
    if (!_resultHeaderView) {
        _resultHeaderView = [THNShopWindowResultHeaderView viewFromXib];
        _resultHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return _resultHeaderView;
}

@end
