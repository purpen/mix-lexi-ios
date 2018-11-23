//
//  THNSettingAboutViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNSettingAboutViewController.h"
#import <WebKit/WebKit.h>

static NSString *const kURLAbout    = @"https://h5.lexivip.com/site/service_agreement";
static NSString *const kTitleAbout  = @"关于乐喜";

@interface THNSettingAboutViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *aboutWebView;

@end

@implementation THNSettingAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
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

#pragma mark - setup UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.aboutWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleAbout;
}

#pragma mark - getters and setters
- (WKWebView *)aboutWebView {
    if (!_aboutWebView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 10;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = NO;
        webConfig.preferences = preferences;
        
        _aboutWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
        _aboutWebView.navigationDelegate = self;
        _aboutWebView.UIDelegate = self;
        _aboutWebView.backgroundColor = [UIColor whiteColor];
        _aboutWebView.contentScaleFactor = YES;
        _aboutWebView.scrollView.bounces = NO;
        _aboutWebView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _aboutWebView.scrollView.showsVerticalScrollIndicator = NO;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURLAbout]];
        [_aboutWebView loadRequest:urlRequest];
    }
    return _aboutWebView;
}


@end
