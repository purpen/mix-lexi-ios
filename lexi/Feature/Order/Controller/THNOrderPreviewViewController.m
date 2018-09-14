//
//  THNOrderPreviewViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderPreviewViewController.h"
#import "THNPaySuccessViewController.h"
#import "THNSelectLogisticsViewController.h"
#import "THNBuyProgressView.h"

static NSString *kTitleDone = @"提交订单";

@interface THNOrderPreviewViewController ()

/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 进度条
@property (nonatomic, strong) THNBuyProgressView *progressView;

@end

@implementation THNOrderPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    THNPaySuccessViewController *paySuccessVC = [[THNPaySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
    
//    THNSelectLogisticsViewController *selectLogisticsVC = [[THNSelectLogisticsViewController alloc] init];
//    [self.navigationController pushViewController:selectLogisticsVC animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.doneButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleSubmitOrder;
}

#pragma mark - getters and setters
- (UIButton *)doneButton {
    if (!_doneButton) {
        CGFloat originBottom = kDeviceiPhoneX ? 77 : 45;
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - originBottom, SCREEN_WIDTH - 30, 40)];
        [_doneButton setTitle:kTitleDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (THNBuyProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[THNBuyProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 44)
                                                            index:1];
    }
    return _progressView;
}


@end
