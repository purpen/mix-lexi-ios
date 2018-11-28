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

static NSString *const kURLNewUserBonus = @"/market/grant_new_user_bonus";

@interface THNAdvertCouponViewController () <THNAdvertCouponViewDelegate>

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
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_advertGetCoupon {
    if (![THNLoginManager isLogin]) {
        [self dismissViewControllerAnimated:NO completion:^{
            [[THNLoginManager sharedManager] openUserLoginController];
        }];
        
    } else {
        [[THNAdvertManager sharedManager] updateGrantStatus:YES];
        [self thn_showAnimation:NO];
        [SVProgressHUD thn_showSuccessWithStatus:@"领取成功"];
//        [self networkGrantNewUserBonus];
    }
}

- (void)thn_advertViewClose {
    [self thn_showAnimation:NO];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self.view addSubview:self.advertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES];
}

- (void)thn_showAnimation:(BOOL)show {
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
                         if (!show) {
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
