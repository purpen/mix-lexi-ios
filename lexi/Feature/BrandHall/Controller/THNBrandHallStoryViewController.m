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
#import "THNDealContentTableViewCell.h"
#import "UITableViewCell+DealContent.h"
#import <MJExtension/MJExtension.h>
#import "THNStoreModel.h"
#import "THNShopWindowModel.h"
#import "YYLabel+Helper.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import "UIViewController+THNHud.h"
#import "THNBrandHallDefaultView.h"
#import "UIImage+Helper.h"
#import <SDWebImage/SDWebImageManager.h>

static NSString *const kUrlStoreDetail = @"/official_store/detail";
static NSString *const kUrlStoreInfo = @"/official_store/info";
static NSString *const kUrlStoreMasterInfo = @"/official_store/master_info";
static NSString *const KStoreContentCellIdentifier = @"KStoreContentCellIdentifier";
static NSString *const KStoreInfoCellIdentifier = @"KStoreInfoCellIdentifier";
static NSString *const KStoreUserInfoCellIdentifier = @"KStoreUserInfoCellIdentifier";

@interface THNBrandHallStoryViewController ()

@property (nonatomic, strong) THNStoreModel *storeModel;
@property (nonatomic, strong) THNShopWindowModel *shopWindowModel;
@property (nonatomic, strong) NSMutableArray *contentModels;
@property (nonatomic, strong) THNBrandHallDefaultView *defaultView;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation THNBrandHallStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self showHud];
    
    dispatch_group_async(group, queue, ^{
        [self loadStoreMasterInfoData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadStoreInfoData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadStoreDetailData];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenHud];
            [self.tableView reloadData];
        });
    });
}

- (void)setupUI {
    self.navigationBarView.title = @"关于设计馆";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[THNDealContentTableViewCell class] forCellReuseIdentifier:KStoreContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNBrandHallUserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:KStoreUserInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNBrandHallInfoTableViewCell" bundle:nil] forCellReuseIdentifier:KStoreInfoCellIdentifier];
}

// 品牌故事
- (void)loadStoreDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        THNLog(@"-------- 品牌故事：%@", result.responseDict);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        for (NSDictionary *dict in result.data[@"split_content"]) {
            THNDealContentModel *contenModel = [[THNDealContentModel alloc] initWithDictionary:dict];
            [self.contentModels addObject:contenModel];
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 品牌馆信息
- (void)loadStoreInfoData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreInfo requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.storeModel = [[THNStoreModel alloc]initWithDictionary:result.data];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 馆主信息
- (void)loadStoreMasterInfoData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreMasterInfo requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        self.shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:result.data];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNBrandHallUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KStoreUserInfoCellIdentifier forIndexPath:indexPath];
        
        if (self.shopWindowModel) {
             [cell setShowWindowModel:self.shopWindowModel];
        }
       
       return cell;
    } else if (indexPath.row == 1) {
        THNBrandHallInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KStoreInfoCellIdentifier forIndexPath:indexPath];
        
        if (self.storeModel) {
             [cell setStoreModel:self.storeModel];
        }
       
        return cell;
    } else {
        THNDealContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KStoreContentCellIdentifier forIndexPath:indexPath];
        if (self.contentModels.count > 0) {
             [cell thn_setDealContentData:self.contentModels type:(THNDealContentTypeBrandHall)];
        }
       
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 187;
    } else if (indexPath.row == 1) {
        return 285;
    } else {
        return [UITableViewCell heightWithDaelContentData:self.contentModels type:(THNDealContentTypeBrandHall)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.contentModels.count == 0) {
        return self.defaultView;
    } else {
        return [[UIView alloc]init];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.contentModels.count == 0) {
        return 200;
    } else {
        return 0;
    }
}

#pragma mark - lazy

- (THNBrandHallDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [THNBrandHallDefaultView viewFromXib];
    }
    return _defaultView;
}

- (NSMutableArray *)contentModels {
    if (!_contentModels) {
        _contentModels = [NSMutableArray array];
    }
    return _contentModels;
}

@end
