//
//  THNCashInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashInfoViewController.h"
#import "THNCashInfoView.h"
#import "THNLifeManager.h"
#import "THNLoginManager.h"

static NSString *const kTitleInfo = @"提现详情";

@interface THNCashInfoViewController ()

@property (nonatomic, strong) THNCashInfoView *infoView;

@end

@implementation THNCashInfoViewController

- (instancetype)initWithCashBillId:(NSString *)billId {
    self = [super init];
    if (self) {
        [self thn_getCashBillInfoDataWithId:billId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)thn_getCashBillInfoDataWithId:(NSString *)billId {
    if (!billId.length) return;
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNLifeManager getLifeCashBillDetailWithRid:[THNLoginManager sharedManager].storeRid
                                        recordId:billId
                                      completion:^(THNLifeCashBillModel *model, NSError *error) {
                                          if (error) return;
                                          
                                          [weakSelf.infoView thn_setLifeCashBillDetailData:model];
                                          [SVProgressHUD dismiss];
                                      }];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.infoView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleInfo;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - getters and setters
- (THNCashInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[THNCashInfoView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 385)];
    }
    return _infoView;
}

@end
