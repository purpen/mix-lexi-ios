//
//  THNShopWindowDetailViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowDetailViewController.h"
#import "THNFeatureTableViewCell.h"
#import "THNFirstLevelCommentTableViewCell.h"

@interface THNShopWindowDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITableView *commentTableView;

@end

@implementation THNShopWindowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.title = @"橱窗";
}

//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

@end
