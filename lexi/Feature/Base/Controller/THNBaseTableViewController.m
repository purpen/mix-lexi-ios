//
//  THNBaseTableViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseTableViewController.h"
//#import "THNLikedGoodsTableViewCell.h"

static CGFloat const kSectionHeaderViewH = 54.0;

@interface THNBaseTableViewController () <THNNavigationBarViewDelegate>

@end

@implementation THNBaseTableViewController

- (instancetype)init {
    return [self initWithStyle:(UITableViewStyleGrouped)];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    THNTableViewSections *secitons = self.dataSections[section];
    
    return secitons.dataCells.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNTableViewSections *secitons = self.dataSections[section];
    
    return secitons.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    THNTableViewSections *secitons = self.dataSections[section];

    return secitons.headerTitle.length ? kSectionHeaderViewH : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *secitons = self.dataSections[indexPath.section];
    THNTableViewCells *cells = secitons.dataCells[indexPath.row];
    
    return cells.height;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBaseUI];
}

#pragma mark - setup UI
- (void)setupBaseUI {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.navigationBarView];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationBarView setNavigationBackButton];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationBarView removeFromSuperview];
}

#pragma mark - custom delegate
- (void)didNavigationBackButtonEvent {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didNavigationCloseButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (NSMutableArray *)dataSections {
    if (!_dataSections) {
        _dataSections = [NSMutableArray array];
    }
    return _dataSections;
}

- (void)setSeparatorStyle:(THNTableViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    
    if (separatorStyle == THNTableViewCellSeparatorStyleDefault) return;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (THNNavigationBarView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [[THNNavigationBarView alloc] init];
        _navigationBarView.delegate = self;
    }
    return _navigationBarView;
}

@end
