//
//  THNTableViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseTableViewController.h"

static CGFloat const kSectionHeaderViewH  = 54.0;
static NSString *const kUITableViewCellId = @"UITableViewCellId";

@interface THNBaseTableViewController ()

@end

@implementation THNBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewUI];
}

#pragma mark - public methods
- (void)thn_sortDataSecitons {
    [self.dataSections sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        THNTableViewSections *section1 = obj1;
        THNTableViewSections *section2 = obj2;
        
        NSComparisonResult result = [@(section1.index) compare:@(section2.index)];
        return result;
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSections.count ? self.dataSections.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (self.dataSections.count) {
         THNTableViewSections *secitons = self.dataSections[section];
         
         return secitons.dataCells.count;
     }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSections.count) {
        THNTableViewSections *secitons = self.dataSections[section];
        
        return secitons.headerView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSections.count) {
        THNTableViewSections *secitons = self.dataSections[section];
        
        return secitons.headerTitle.length ? kSectionHeaderViewH : secitons.headerHeight;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataSections.count) {
        THNTableViewSections *secitons = self.dataSections[section];
        
        return secitons.footerView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataSections.count) {
        THNTableViewSections *secitons = self.dataSections[section];
        
        return secitons.footerHeight;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSections.count) {
        THNTableViewSections *secitons = self.dataSections[indexPath.section];
        THNTableViewCells *cells = secitons.dataCells[indexPath.row];
        
        return cells.height;
    }
    
    return 44.0;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kUITableViewCellId];
    }
    
    return cell;
}

#pragma mark - setup UI
- (void)setupTableViewUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setSeparatorStyle:THNTableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                  style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

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

@end
