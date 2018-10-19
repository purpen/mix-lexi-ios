//
//  THNBrandHallStoryViewController.m
//  lexi
//
//  Created by rhp on 2018/10/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallStoryViewController.h"
#import "THNAPI.h"
#import "THNBrandHallInfoTableViewCell.h"
#import "THNBrandHallUserInfoTableViewCell.h"
#import "THNGoodsContentTableViewCell.h"
#import <MJExtension/MJExtension.h>

static NSString *const kUrlStoreDetail = @"/official_store/detail";
static NSString *const kUrlStoreInfo = @"/official_store/info";
static NSString *const kUrlStoreMasterInfo = @"/official_store/master_info";
static NSString *const KStoreContentCellIdentifier = @"KStoreContentCellIdentifier";
static NSString *const KStoreInfoCellIdentifier = @"KStoreInfoCellIdentifier";
static NSString *const KStoreUserInfoCellIdentifier = @"KStoreUserInfoCellIdentifier";

@interface THNBrandHallStoryViewController ()

@property (nonatomic, strong) THNStoreModel *storeModel;
@property (nonatomic, strong) THNGoodsModelProductLikeUser *userModel;

@end

@implementation THNBrandHallStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadStoreInfoData];
    [self loadStoreMasterInfoData];
    [self loadStoreDetailData];

}

- (void)setupUI {
    self.navigationBarView.title = @"关于设计馆";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[THNGoodsContentTableViewCell class] forCellReuseIdentifier:KStoreContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNBrandHallUserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:KStoreInfoCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:@"THNBrandHallInfoTableViewCell" bundle:nil] forCellReuseIdentifier:KStoreUserInfoCellIdentifier];
}

// 品牌故事
- (void)loadStoreDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {

    } failure:^(THNRequest *request, NSError *error) {

    }];
}

// 品牌馆信息
- (void)loadStoreInfoData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreInfo requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
//            [SVProgressHUD ];
            return;
        }
        
        self.storeModel = [THNStoreModel mj_objectWithKeyValues:result.data];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

// 馆主信息
- (void)loadStoreMasterInfoData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreMasterInfo requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {

    } failure:^(THNRequest *request, NSError *error) {

    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNBrandHallUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KStoreUserInfoCellIdentifier forIndexPath:indexPath];
       return cell;
    } else if (indexPath.row == 1) {
        THNBrandHallInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KStoreInfoCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        THNGoodsContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KStoreContentCellIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    } else if (indexPath.row == 1) {
        return 200;
    } else {
        return 300;
    }
}

@end
