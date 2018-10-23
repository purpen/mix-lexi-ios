//
//  THNSearchStoreTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchStoreTableViewController.h"
#import "UIView+Helper.h"
#import "THNConst.h"
#import "THNAPI.h"
#import "THNSaveTool.h"
#import "THNSearchStoreTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNFeaturedBrandModel.h"
#import "UIColor+Extension.h"
#import "THNBrandHallViewController.h"
#import "THNGoodsInfoViewController.h"

static NSString *const kUrlSearchStore = @"/core_platforms/search/stores";
static NSString *const kSearchStoreCellIdentifier = @"kSearchStoreCellIdentifier";

@interface THNSearchStoreTableViewController ()

@property (nonatomic, strong) NSArray *stores;

@end

@implementation THNSearchStoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSearchStoreData];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.rowHeight = 195;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSearchStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kSearchStoreCellIdentifier];
}

- (void)loadSearchStoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"per_page"] = @10;
    params[@"qk"] = [THNSaveTool objectForKey:kSearchKeyword];
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchStore requestDictionary:params delegate:nil];
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
    THNSearchStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchStoreCellIdentifier forIndexPath:indexPath];
    
    cell.searchStoreBlcok = ^(NSString *productRid) {
        THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:productRid];
        [self.navigationController pushViewController:goodInfoVC animated:YES];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.stores[indexPath.row]];
    [cell setBrandModel:brandModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
    THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.stores[indexPath.row]];
    brandHallVC.rid = brandModel.rid;
    [self.navigationController pushViewController:brandHallVC animated:YES];
}

@end
