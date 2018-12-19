//
//  THNAdvertUpdateViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertUpdateViewController.h"
#import "THNAdvertUpdateView.h"

static NSString *const kURLUpdate   = @"/market/app_versions/ios";
static NSString *const kKeyDes      = @"description";
static NSString *const kKeyVersion  = @"version";

static NSString *const kURLAppStore = @"https://itunes.apple.com/cn/app/%E4%B9%90%E5%96%9C-%E5%85%A8%E7%90%83%E5%8E%9F%E5%88%9B%E8%AE%BE%E8%AE%A1%E5%93%81%E4%BD%8D%E8%B4%AD%E7%89%A9%E5%B9%B3%E5%8F%B0/id1439284825?mt=8";

@interface THNAdvertUpdateViewController () <THNAdvertUpdateViewDelegate>

@property (nonatomic, strong) THNAdvertUpdateView *updateView;
@property (nonatomic, strong) NSString *appVersion;

@end

@implementation THNAdvertUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestUpdateContentData];
}

#pragma mark - network
- (void)requestUpdateContentData {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    THNRequest *request = [THNAPI getWithUrlString:kURLUpdate requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
//        THNLog(@"版本更新的内容：%@", result.responseDict);
        if (!result.isSuccess) {
            [self dismissViewControllerAnimated:NO completion:nil];
            return ;
        }
        
        if (result.data[kKeyVersion] && ![result.data[kKeyVersion] isKindOfClass:[NSNull class]]) {
            if (![self thn_needUpdateVersion:result.data[kKeyVersion]]) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
            } else {
                [self setupUI];
            }
            
            if (result.data[kKeyDes] && [result.data[kKeyDes] isKindOfClass:[NSArray class]]) {
                NSArray *desArr = result.data[kKeyDes];
                [weakSelf.updateView thn_setUpdateContents:desArr];
            }
            
        } else {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - private methods
- (BOOL)thn_needUpdateVersion:(NSString *)version {
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    return ![currentVersion isEqualToString:version];
}

#pragma mark - custom delegate
- (void)thn_updateDoneAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLAppStore]];
}

- (void)thn_updateCancelAction {
    [self thn_showAnimation:NO dismiss:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    [self.view addSubview:self.updateView];
    [self thn_showAnimation:YES dismiss:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
}

- (void)thn_showAnimation:(BOOL)show dismiss:(BOOL)dismiss {
    CGFloat originY = show ? 0 : -SCREEN_HEIGHT;
    CGFloat alpha = show ? 0.5 : 0;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.8
                        options:(UIViewAnimationOptionTransitionCrossDissolve)
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:alpha];
                         self.updateView.frame = CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT);
                         
                     } completion:^(BOOL finished) {
                         if (dismiss) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }];
}

#pragma mark - getters and setters
- (THNAdvertUpdateView *)updateView {
    if (!_updateView) {
        _updateView = [[THNAdvertUpdateView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _updateView.delegate = self;
    }
    return _updateView;
}

@end
