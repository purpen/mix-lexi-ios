//
//  THNAdvertCouponViewController.m
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertCouponViewController.h"
#import "THNAdvertCouponView.h"
#import "THNAdvertManager.h"
#import "THNLoginManager.h"
#import "THNAlertView.h"
#import "THNMyCouponViewController.h"

static NSString *const kURLNewUserBonus = @"/market/grant_new_user_bonus";

@interface THNAdvertCouponViewController () <THNAdvertCouponViewDelegate> {
    BOOL _isOpenCouponVC;    // 已打开优惠券
}

@property (nonatomic, strong) THNAdvertCouponView *advertView;

@end

@implementation THNAdvertCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
/**
 领取1000元新人红包
 */
- (void)networkGrantNewUserBonus {
    THNRequest *request = [THNAPI postWithUrlString:kURLNewUserBonus requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [[THNAdvertManager sharedManager] updateGrantStatus:YES];
        [self thn_showAlertView];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
- (void)thn_showAlertView {
    [self thn_showAnimation:NO dismiss:NO];
    
    THNAlertView *alertView = [THNAlertView initAlertViewTitle:@"领取成功" message:@""];
    [alertView addActionButtonWithTitles:@[@"去使用", @"查看优惠券"] handler:^(UIButton *actionButton, NSInteger index) {
        if (index == 0) {
            [self thn_showAnimation:NO dismiss:YES];
            
        } else {
            [self thn_openCouponController];
        }
    }];
    
    [alertView show];
}

/**
 打开优惠券视图
 */
- (void)thn_openCouponController {
    _isOpenCouponVC = YES;
    
    THNMyCouponViewController *couponVC = [[THNMyCouponViewController alloc] init];
    [self.navigationController pushViewController:couponVC animated:YES];
}

#pragma mark - custom delegate
- (void)thn_advertGetCoupon {
    if (![THNLoginManager isLogin]) {
        [self dismissViewControllerAnimated:NO completion:^{
            [[THNLoginManager sharedManager] openUserLoginController];
        }];
        
    } else {
        [self networkGrantNewUserBonus];
    }
}

- (void)thn_advertViewClose {
    [self thn_showAnimation:NO dismiss:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self.view addSubview:self.advertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
    
    if (_isOpenCouponVC) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES dismiss:NO];
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
                         self.advertView.frame = CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT);
                         
                         if (show) {
                             self.advertView.transform = CGAffineTransformIdentity;
                             
                         } else {
                             self.advertView.transform = CGAffineTransformScale(self.advertView.transform, 0.5, 0.5);
                         }

                     } completion:^(BOOL finished) {
                         if (dismiss) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }];
}

#pragma mark - getters and setters
- (THNAdvertCouponView *)advertView {
    if (!_advertView) {
        _advertView = [[THNAdvertCouponView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _advertView.transform = CGAffineTransformScale(_advertView.transform, 0.2, 0.2);
        _advertView.delegate = self;
    }
    return _advertView;
}

@end
