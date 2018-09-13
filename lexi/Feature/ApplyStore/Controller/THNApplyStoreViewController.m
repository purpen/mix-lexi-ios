//
//  THNApplyStoreViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNApplyStoreViewController.h"
#import <WebKit/WebKit.h>

static NSString *const kURLApplyStore = @"https://h5.lexivip.com/shop/guide";
//static NSString *const kURLApplyStore = @"http://m.taihuoniao.com";

@interface THNApplyStoreViewController () <WKNavigationDelegate, WKUIDelegate>

/// 开馆指引
@property (nonatomic, strong) WKWebView *applyWebView;

@end

@implementation THNApplyStoreViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - webView delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSLog(@"======= 0 -- %@", navigationAction.targetFrame);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    NSLog(@"======= 1 -- %@", navigationAction.targetFrame);
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

#pragma mark - setup UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.applyWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    [self.navigationBarView setNavigationTransparent:YES showShadow:YES];;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat originY = kDeviceiPhoneX ? -44 : -22;
    self.applyWebView.scrollView.contentInset = UIEdgeInsetsMake(originY, 0, 0, 0);
}

#pragma mark - getters and setters
- (WKWebView *)applyWebView {
    if (!_applyWebView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 10;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = NO;
        webConfig.preferences = preferences;
        
        _applyWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
        _applyWebView.navigationDelegate = self;
        _applyWebView.UIDelegate = self;
        _applyWebView.backgroundColor = [UIColor whiteColor];
        _applyWebView.scrollView.bounces = NO;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURLApplyStore]];
        [_applyWebView loadRequest:urlRequest];
    }
    return _applyWebView;
}

@end
