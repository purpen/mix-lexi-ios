//
//  THNEvaluationViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNEvaluationViewController.h"
#import "THNEvaluationTableViewCell.h"
#import "THNOrdersItemsModel.h"

static NSString *const kEvaluationCellIdentifier = @"kEvaluationCellIdentifier";

@interface THNEvaluationViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation THNEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.title = @"评价";
    [self.tableView registerNib:[UINib nibWithNibName:@"THNEvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:kEvaluationCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEvaluationCellIdentifier forIndexPath:indexPath];
    THNOrdersItemsModel *itemModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.products[indexPath.row]];
    [cell setItemsModel:itemModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 420;
}

@end
