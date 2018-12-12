//
//  THNCashViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashViewController.h"
#import "THNCashRecordViewController.h"
#import "THNCashView.h"

static NSString *const kTitleCash   = @"提现";
static NSString *const kTextRecord  = @"提现记录";

@interface THNCashViewController ()

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) THNCashView *cashView;

@end

@implementation THNCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - private methods
- (void)thn_openCashRecordController {
    THNCashRecordViewController *recordVC = [[THNCashRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    if (@available(iOS 11.0, *)) {
        self.containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.containerView addSubview:self.cashView];
    [self.view addSubview:self.containerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCash;
    self.navigationBarView.bottomLine = YES;
    [self.navigationBarView setNavigationRightButtonOfText:kTextRecord];
    
    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf thn_openCashRecordController];
    }];
}

#pragma mark - getters and setters
- (UIScrollView *)containerView {
    if (!_containerView) {
        CGFloat originY = kDeviceiPhoneX ? 88 : 64;
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY)];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _containerView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        _containerView.showsVerticalScrollIndicator = NO;
    }
    return _containerView;
}

- (THNCashView *)cashView {
    if (!_cashView) {
        _cashView = [[THNCashView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 464)];
        _cashView.cashAmount = 12.1;
    }
    return _cashView;
}

@end
