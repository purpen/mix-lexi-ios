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

@interface THNBrandHallStoryViewController ()

@end

@implementation THNBrandHallStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadStoreDetailData];

}

- (void)setupUI {
    self.navigationBarView.title = @"关于设计馆";
}

- (void)loadStoreDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlStoreDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {

    } failure:^(THNRequest *request, NSError *error) {

    }];
}



@end
