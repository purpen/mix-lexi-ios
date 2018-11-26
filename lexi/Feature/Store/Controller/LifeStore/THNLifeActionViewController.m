
//
//  THNLifeActionViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/15.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeActionViewController.h"
#import "THNLoginManager.h"
#import "THNLifeManager.h"
#import <Photos/Photos.h>

@interface THNLifeActionViewController () <THNLifeActionViewDelegate>

@property (nonatomic, strong) THNLifeActionView *actionView;

@end

@implementation THNLifeActionViewController

- (instancetype)initWithType:(THNLifeActionType)type {
    self = [super init];
    if (self) {
        [self.actionView showViewWithType:type];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_lifeStoreSaveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD thn_showErrorWithStatus:@"保存失败"];
        
    } else {
        [SVProgressHUD thn_showSuccessWithStatus:@"保存成功"];
    }
}

- (void)thn_lifeStoreCashMoney {
    [SVProgressHUD thn_showInfoWithStatus:@"提现到微信"];
    //    [THNLifeManager getLifeCashWithStoreRid:[THNLoginManager sharedManager].storeRid
    //                                     openId:@""
    //                                 completion:^(NSError *) {
    //
    //    }];
}

- (void)thn_lifeStoreDismissView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];

    [self.view addSubview:self.actionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (THNLifeActionView *)actionView {
    if (!_actionView) {
        _actionView = [[THNLifeActionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _actionView.delegate = self;
    }
    return _actionView;
}

@end
