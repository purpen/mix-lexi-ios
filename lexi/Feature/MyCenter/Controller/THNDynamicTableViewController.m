//
//  THNDynamicTableViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/18.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDynamicTableViewController.h"

@interface THNDynamicTableViewController ()

@end

@implementation THNDynamicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setDynamicTableViewCell];
}

- (void)thn_setDynamicTableViewCell {
    THNTableViewCells *userInfoCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeDynamic) didSelectedItem:nil];
    userInfoCells.height = 66.0;
    
    THNTableViewCells *imagesCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeGoods) didSelectedItem:nil];
    imagesCells.height = 110.0;
    
    THNTableViewCells *contentInfoCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeGoods) didSelectedItem:nil];
    contentInfoCells.height = 90.0;
    
    THNTableViewCells *functionCells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeGoods) didSelectedItem:nil];
    functionCells.height = 50.0;
    
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithCells:[@[userInfoCells,
                                                                                    imagesCells,
                                                                                    contentInfoCells,
                                                                                    functionCells] mutableCopy]];
    
    [self.dataSections addObject:sections];
    [self.tableView reloadData];
}

#pragma mark - setup UI
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleLikedDynamic;
}

@end