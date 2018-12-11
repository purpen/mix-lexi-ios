//
//  THNCashRecordViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashRecordViewController.h"

static NSString *const kTitleRecord  = @"提现记录";

@interface THNCashRecordViewController ()

@end

@implementation THNCashRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - setup UI
- (void)setupUI {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleRecord;
}

@end
