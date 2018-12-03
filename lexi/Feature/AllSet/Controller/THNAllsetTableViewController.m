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
#import "UIViewController+THNHud.h"
#import "THNGoodsInfoViewController.h"
#import "THNSetDetailViewController.h"
#import "UIView+Helper.h"

static NSString *const kUrlCollections = @"/column/collections";
static NSString *const KAllsetCellIdentifier = @"KAllsetCellIdentifier";
static CGFloat const kCellRowHeight = 382;

@interface THNAllsetTableViewController ()<THNNavigationBarViewDelegate, THNMJRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *collections;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNAllsetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCollectionData];
}

- (void)setupUI {
    self.navigationBarView.title = @"集合";
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_gray"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNAllsetTableViewCell" bundle:nil] forCellReuseIdentifier:KAllsetCellIdentifier];
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadCollectionData {
    if (self.currentPage == 1) {
        [self showHud];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:kUrlCollections requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        [self.tableView endFooterRefreshAndCurrentPageChange:YES];
        NSArray *collections = result.data[@"collections"];
        [self.collections addObjectsFromArray:collections];
        
        if (![result.data[@"next"] boolValue] && self.collections.count != 0) {
            [self.tableView noMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    THNAllsetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [THNAllsetTableViewCell viewFromXib];
    }
    
    cell.allsetBlcok = ^(NSString *rid) {
        THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
        [weakSelf.navigationController pushViewController:goodInfo animated:YES];
    };
    
    cell.pushDetailBlock = ^(NSInteger collectionRid) {
        THNSetDetailViewController *setVC = [[THNSetDetailViewController alloc]init];
        setVC.collectionID = collectionRid;
        [weakSelf.navigationController pushViewController:setVC animated:YES];
    };
    
    THNCollectionModel *collectionModel = [THNCollectionModel mj_objectWithKeyValues:self.collections[indexPath.row]];
    [cell setCollectionModel:collectionModel];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellRowHeight;
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadCollectionData];
}

#pragma mark - lazy
- (NSMutableArray *)collections {
    if (!_collections) {
        _collections = [NSMutableArray array];
    }
    return _collections;
}

@end
