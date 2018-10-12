//
//  THNBrandHallFeaturesTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallFeaturesTableViewController.h"
#import "UIColor+Extension.h"
#import "THNBrandHallFeaturesTableViewCell.h"
#import "THNAPI.h"
#import "THNFeaturedBrandModel.h"
#import <MJExtension/MJExtension.h>
#import "UIView+Helper.h"
#import "THNGoodsInfoViewController.h"

static NSString *const kUrlFeatureStore = @"/column/feature_store_all";
static NSString *const kBrandHallFeaturesCellIdentifier = @"kBrandHallFeaturesCellIdentifier";
static CGFloat const kBrandHallFeaturesHeight = 300;

@interface THNBrandHallFeaturesTableViewController ()

@property (nonatomic, strong) NSArray *stores;

@end

@implementation THNBrandHallFeaturesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFeatureStoreData];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = kBrandHallFeaturesHeight;
}

- (void)loadFeatureStoreData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlFeatureStore requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.stores = result.data[@"stores"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandHallFeaturesTableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [THNBrandHallFeaturesTableViewCell viewFromXib];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.brandHallFeaturesBlock = ^(NSString *rid) {
        THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
        [self.navigationController pushViewController:goodInfo animated:YES];
    };
    THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.stores[indexPath.row]];
    [cell setBrandModel:brandModel];
    return cell;
}

@end
