//
//  THNPopularSingleProductTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPopularSingleProductTableViewController.h"
#import "THNCenterProductTableViewCell.h"
#import "THNAPI.h"
#import "THNProductModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kCenterProductCellIdentifier = @"kCenterProductCellIdentifier";
static NSString *const kUrlDistributeHot = @"/fx_distribute/hot";

@interface THNPopularSingleProductTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation THNPopularSingleProductTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDistributeHotData];
    [self setupUI];
}

- (void)loadDistributeHotData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlDistributeHot requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.dataArray = result.data[@"products"];
//        self.arrayCountBlock(self.dataArray.count);
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 171;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNCenterProductTableViewCell" bundle:nil] forCellReuseIdentifier:kCenterProductCellIdentifier];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCenterProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCenterProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setProductModel:productModel];
    return cell;
}


@end
