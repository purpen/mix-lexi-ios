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
#import "UIViewController+THNHud.h"
#import "THNBrandHallViewController.h"
#import "UIScrollView+THNMJRefresh.h"

static NSString *const kUrlFeatureStore = @"/column/feature_store_all";
static NSString *const kBrandHallFeaturesCellIdentifier = @"kBrandHallFeaturesCellIdentifier";
static CGFloat const kBrandHallFeaturesHeight = 300;

@interface THNBrandHallFeaturesTableViewController () <THNMJRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *stores;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNBrandHallFeaturesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadFeatureStoreData];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = kBrandHallFeaturesHeight;
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadFeatureStoreData {
    if (self.currentPage == 1) {
        [self showHud];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:kUrlFeatureStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [self.tableView endFooterRefreshAndCurrentPageChange:YES];
        NSArray *stores = result.data[@"stores"];
        [self.stores addObjectsFromArray:stores];
        
        if (![result.data[@"next"] boolValue] && self.stores.count != 0) {
            [self.tableView noMoreData];
        }
        
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
    
    WEAKSELF;
    cell.brandHallFeaturesBlock = ^(NSString *rid) {
        THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
        [weakSelf.navigationController pushViewController:goodInfo animated:YES];
    };
    THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.stores[indexPath.row]];
    [cell setBrandModel:brandModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.stores[indexPath.row]];
    THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
    brandHallVC.rid = brandModel.rid;
    [self.navigationController pushViewController:brandHallVC animated:YES];
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadFeatureStoreData];
}

#pragma mark - lazy
- (NSMutableArray *)stores {
    if (!_stores) {
        _stores = [NSMutableArray array];
    }
    return _stores;
}

@end
