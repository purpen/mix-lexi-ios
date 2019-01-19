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
#import "UIViewController+THNHud.h"

static NSString *const kUrlSearchStore = @"/core_platforms/search/stores";
static NSString *const kSearchStoreCellIdentifier = @"kSearchStoreCellIdentifier";

@interface THNSearchStoreTableViewController () <THNMJRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *stores;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNSearchStoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadSearchStoreData];
}

- (void)setupUI {
    self.tableView.rowHeight = 195;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSearchStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kSearchStoreCellIdentifier];
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadSearchStoreData {
    if (self.currentPage == 1) {
        self.isTransparent = YES;
        [self showHud];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"qk"] = [THNSaveTool objectForKey:kSearchKeyword];
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
#ifdef DEBUG
        THNLog(@"搜索到的品牌馆：%@", [NSString jsonStringWithObject:result.responseDict]);
#endif
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        [self.tableView endFooterRefreshAndCurrentPageChange:YES];
        NSArray *stores = result.data[@"stores"];
        [self.stores addObjectsFromArray:[THNFeaturedBrandModel mj_objectArrayWithKeyValuesArray:stores]];
        
        if (![result.data[@"next"] boolValue] && self.stores.count != 0) {
            [self.tableView noMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSearchStoreTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [THNSearchStoreTableViewCell viewFromXib];
    }
    WEAKSELF;
    cell.searchStoreBlcok = ^(NSString *productRid) {
        THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:productRid];
        [weakSelf.navigationController pushViewController:goodInfoVC animated:YES];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNFeaturedBrandModel *brandModel = self.stores[indexPath.row];
    [cell setBrandModel:brandModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
    THNFeaturedBrandModel *brandModel = self.stores[indexPath.row];
    brandHallVC.rid = brandModel.rid;
    [self.navigationController pushViewController:brandHallVC animated:YES];
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadSearchStoreData];
}

- (NSMutableArray *)stores {
    if (!_stores) {
        _stores = [NSMutableArray array];
    }
    return _stores;
}

@end
