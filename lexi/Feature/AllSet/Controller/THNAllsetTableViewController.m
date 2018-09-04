//
//  THNAllsetTableViewController.m
//  lexi
//
//  Created by rhp on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAllsetTableViewController.h"
#import "THNAPI.h"
#import "THNAllsetTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNCollectionModel.h"

static NSString *const kUrlCollections = @"/column/collections";
static NSString *const KAllsetCellIdentifier = @"KAllsetCellIdentifier";
static CGFloat const kCellRowHeight = 377;

@interface THNAllsetTableViewController ()

@property (nonatomic, strong) NSArray *collections;

@end

@implementation THNAllsetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCollectionData];
    [self setupUI];
}

- (void)setupUI {
//    self.navigationBarView.title = @"集合";
//    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_gray"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNAllsetTableViewCell" bundle:nil] forCellReuseIdentifier:KAllsetCellIdentifier];
    self.tableView.rowHeight = kCellRowHeight;
}

- (void)loadCollectionData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlCollections requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.collections = result.data[@"collections"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNAllsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KAllsetCellIdentifier forIndexPath:indexPath];
    THNCollectionModel *collectionModel = [THNCollectionModel mj_objectWithKeyValues:self.collections[indexPath.row]];
    [cell setCollectionModel:collectionModel];
    return cell;
}

@end
