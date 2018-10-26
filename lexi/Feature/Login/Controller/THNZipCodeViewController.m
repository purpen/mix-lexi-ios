//
//  THNZipCodeViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNZipCodeViewController.h"
#import "THNZipCodeView.h"
#import "THNAreaModel.h"

/// 获取手机号地区编码
static NSString *const kURLAreaCode = @"/auth/area_code";
static NSString *const kParamStatus = @"status";

@interface THNZipCodeViewController ()

/// 区号列表
@property (nonatomic, strong) THNZipCodeView *zipCodeView;

@end

@implementation THNZipCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self networkGetAreaCode];
}

#pragma mark - network
- (void)networkGetAreaCode {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI getWithUrlString:kURLAreaCode requestDictionary:@{kParamStatus: @(1)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return ;
        }
        
        [SVProgressHUD dismiss];
        THNAreaModel *areaModel = [THNAreaModel mj_objectWithKeyValues:result.data];
        [weakSelf.zipCodeView thn_setAreaCodes:areaModel.area_codes];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.zipCodeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (THNZipCodeView *)zipCodeView {
    if (!_zipCodeView) {
        _zipCodeView = [[THNZipCodeView alloc] init];
        
        WEAKSELF;

        _zipCodeView.CloseZipCodeViewBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        _zipCodeView.SelectedZipCodeBlock = ^(THNAreaCodeModel *model) {
            weakSelf.SelectAreaCode(model.areacode);
        };
    }
    return _zipCodeView;
}

- (BOOL)willDealloc {
    return NO;
}

@end
