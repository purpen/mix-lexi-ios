//
//  THNCertificationStatusViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCertificationStatusViewController.h"
#import "THNCertificationStatusView.h"
#import "THNInvitationViewController.h"

static NSString *const kTitleCertification = @"实名认证";

@interface THNCertificationStatusViewController () <THNCertificationStatusViewDelegate>

@property (nonatomic, strong) THNCertificationStatusView *statusView;

@end

@implementation THNCertificationStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_certificationStatusViewDoneAction {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[THNInvitationViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.statusView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCertification;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - getters and setters
- (THNCertificationStatusView *)statusView {
    if (!_statusView) {
        CGFloat originY = kDeviceiPhoneX ? 88 : 64;
        _statusView = [[THNCertificationStatusView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY)];
        _statusView.delegate = self;
    }
    return _statusView;
}

@end
