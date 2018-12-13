//
//  THNCashAlipayViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashAlipayViewController.h"
#import "THNCashAlipayView.h"

static NSString *const kTitleCash = @"提现";
/// api
static NSString *const kURLCashMoney = @"/win_cash/cash_money";

@interface THNCashAlipayViewController () <THNCashAlipayViewDelegate>

@property (nonatomic, strong) THNCashAlipayView *cashView;

@end

@implementation THNCashAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)requestCashMoneyDataWithParams:(NSDictionary *)params {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLCashMoney requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"支付宝提现 === %@", result.responseDict);
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        [SVProgressHUD thn_showSuccessWithStatus:@"提现成功"];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_cashAlipayAmount:(CGFloat)amount account:(NSString *)account name:(NSString *)name {
    NSDictionary *param = @{@"cash_type"    : @(2),
                            @"amount"       : @(amount),
                            @"ali_account"  : account,
                            @"ali_name"     : name};
    
    [self requestCashMoneyDataWithParams:param];
}

#pragma mark - private methods
- (void)setCashAmount:(CGFloat)cashAmount {
    _cashAmount = cashAmount;
    
    [self.cashView thn_setCanCashAmount:cashAmount];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.cashView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCash;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - getters and setters
- (THNCashAlipayView *)cashView {
    if (!_cashView) {
        _cashView = [[THNCashAlipayView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 450)];
        _cashView.delegate = self;
    }
    return _cashView;
}

@end
