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
/// api
static NSString *const kURLWallet = @"/win_cash/withdrawal_detail";

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
    THNRequest *request = [THNAPI getWithUrlString:kURLWallet requestDictionary:@{@"rid": billId} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
    
        THNCashInfoModel *model = [[THNCashInfoModel alloc] initWithDictionary:result.data];
        [weakSelf.infoView thn_setWinCashInfoModel:model];

    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
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
