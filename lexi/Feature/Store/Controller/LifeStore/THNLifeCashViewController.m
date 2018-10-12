//
//  THNLifeCashViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashViewController.h"
#import "THNLifeCashView.h"
#import "THNLifeCashBillView.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"
#import "THNLifeCashBillViewController.h"

static NSString *const kTextCash = @"提现";

@interface THNLifeCashViewController () <THNLifeCashViewDelegate, THNLifeCashBillViewDelegate>

@property (nonatomic, strong) THNLifeCashView *cashView;
@property (nonatomic, strong) THNLifeCashBillView *billView;

@end

@implementation THNLifeCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_getLifeCashData];
    [self thn_getLifeCashRecentData];
    [self setupUI];
}

- (void)thn_getLifeCashData {
    WEAKSELF;
    
    [THNLifeManager getLifeCashCollectWithRid:[THNLoginManager sharedManager].storeRid
                                   completion:^(THNLifeCashCollectModel *model, NSError *error) {
                                       if (error) return;
                                    
                                       [weakSelf.cashView thn_setLifeCashCollect:model];
                                   }];
}

- (void)thn_getLifeCashRecentData {
    WEAKSELF;

    [THNLifeManager getLifeCashRecentWithRid:[THNLoginManager sharedManager].storeRid
                                  completion:^(CGFloat price, NSError *error) {
                                      if (error) return;
                                      
                                      [weakSelf.billView thn_setLifeCashRecentPrice:price];
                                  }];
}

#pragma mark - custom delegate
- (void)thn_checkLifeCash {
    [SVProgressHUD showInfoWithStatus:@"提现"];
}

- (void)thn_checkLifeCashBill {
    THNLifeCashBillViewController *billVC = [[THNLifeCashBillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.cashView];
    [self.view addSubview:self.billView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTextCash;
}

#pragma mark - getters and setters
- (THNLifeCashView *)cashView {
    if (!_cashView) {
        _cashView = [[THNLifeCashView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 310)];
        _cashView.delegate = self;
    }
    return _cashView;
}

- (THNLifeCashBillView *)billView {
    if (!_billView) {
        _billView = [[THNLifeCashBillView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cashView.frame) + 15, SCREEN_WIDTH, 44)];
        _billView.delegate = self;
    }
    return _billView;
}

@end
