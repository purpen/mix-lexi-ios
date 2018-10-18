//
//  THNBrandHallStoryViewController.m
//  lexi
//
//  Created by rhp on 2018/10/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallStoryViewController.h"
#import "THNAPI.h"

static NSString *const kUrlStoreDetail = @"/official_store/detail";
static NSString *const kUrlStoreInfo = @"/official_store/info";
static NSString *const kUrlStoreMasterInfo = @"/official_store/master_info";

@interface THNBrandHallStoryViewController ()

@end

@implementation THNBrandHallStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadStoreInfoData];
    [self loadStoreInfoData];
    [self loadStoreDetailData];

}

- (void)setupUI {
    self.navigationBarView.title = @"关于设计馆";
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


@end
