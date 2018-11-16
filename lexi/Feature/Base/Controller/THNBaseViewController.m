//
//  THNBaseViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "UIViewController+THNHud.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

//static BOOL SDImageCacheOldShouldDecompressImages = YES;
//static BOOL SDImagedownloderOldShouldDecompressImages = YES;

@interface THNBaseViewController () <THNNavigationBarViewDelegate>

@end

@implementation THNBaseViewController

#pragma mark - life cycle
- (void)loadView {
    [super loadView];
    
//    SDImageCacheOldShouldDecompressImages = [SDImageCache sharedImageCache].config.shouldDecompressImages;
//    [[SDImageCache sharedImageCache].config setShouldDecompressImages:NO];
//
//    SDImagedownloderOldShouldDecompressImages = [SDWebImageDownloader sharedDownloader].shouldDecompressImages;
//    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseUI];
}

#pragma mark - setup UI
- (void)setupBaseUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBarView];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationBarView setNavigationBackButton];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.view bringSubviewToFront:self.navigationBarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController hiddenHud];
}

#pragma mark - custom delegate
- (void)didNavigationBackButtonEvent {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didNavigationCloseButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (THNNavigationBarView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [[THNNavigationBarView alloc] init];
        _navigationBarView.delegate = self;
    }
    return _navigationBarView;
}

#pragma mark -
- (void)dealloc {
//    [[SDImageCache sharedImageCache].config setShouldDecompressImages:SDImageCacheOldShouldDecompressImages];
//    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:SDImagedownloderOldShouldDecompressImages];
}

@end
