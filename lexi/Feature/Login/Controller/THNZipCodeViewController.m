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
    THNRequest *request = [THNAPI getWithUrlString:kURLAreaCode
                                 requestDictionary:@{kParamStatus: @1}
                                            isSign:NO
                                          delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        THNAreaModel *areaModel = [THNAreaModel mj_objectWithKeyValues:result[@"data"]];
        [self.zipCodeView thn_setAreaCodes:areaModel.area_codes];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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

/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (THNZipCodeView *)zipCodeView {
    if (!_zipCodeView) {
        _zipCodeView = [[THNZipCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
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

@end
