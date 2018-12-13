//
//  THNApplyStoreViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNApplyStoreViewController.h"
#import <WebKit/WebKit.h>
#import "THNUserApplyViewController.h"

static NSString *const kURLApplyStore = @"https://h5.lexivip.com/shop/guide";
static NSString *const kTitleLeXi     = @"乐喜";
// Script
static NSString *const kScriptApply   = @"applyLifeStore";

@interface THNApplyStoreViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

/// 开馆指引
@property (nonatomic, strong) WKWebView *applyWebView;

@end

@implementation THNApplyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)applyButtonAction:(UIButton *)button {
    [self thn_openUserApplyController];
}

#pragma mark - private methods
- (void)thn_openUserApplyController {
    THNUserApplyViewController *userApplyVC = [[THNUserApplyViewController alloc] init];
    [self.navigationController pushViewController:userApplyVC animated:YES];
}

#pragma mark - webView delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD thn_show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:kScriptApply]) {
        [self thn_openUserApplyController];
    }
}

#pragma mark - setup UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.applyWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    
    [self.applyWebView.configuration.userContentController addScriptMessageHandler:self name:kScriptApply];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleLeXi;
}

#pragma mark - getters and setters
- (WKWebView *)applyWebView {
    if (!_applyWebView) {
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 10;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        webConfig.preferences = preferences;
        webConfig.userContentController = [[WKUserContentController alloc] init];
        
        _applyWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                           configuration:webConfig];
        _applyWebView.navigationDelegate = self;
        _applyWebView.UIDelegate = self;
        _applyWebView.backgroundColor = [UIColor whiteColor];
        _applyWebView.scrollView.bounces = NO;
        _applyWebView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _applyWebView.scrollView.showsVerticalScrollIndicator = NO;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURLApplyStore]];
        [_applyWebView loadRequest:urlRequest];
    }
    return _applyWebView;
}

#pragma mark
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.applyWebView.configuration.userContentController removeScriptMessageHandlerForName:kScriptApply];
}

@end
