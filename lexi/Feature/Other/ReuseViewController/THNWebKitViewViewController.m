//
//  THNWebKitViewViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/10/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNWebKitViewViewController.h"
#import <WebKit/WebKit.h>

@interface THNWebKitViewViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation THNWebKitViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.title = self.title;
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

#pragma mark - getters and setters
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 10;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = NO;
        webConfig.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webView loadRequest:urlRequest];
    }
    return _webView;
}

@end
