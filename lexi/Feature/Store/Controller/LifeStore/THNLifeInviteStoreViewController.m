//
//  THNLifeInviteStoreViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/17.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeInviteStoreViewController.h"
#import <WebKit/WebKit.h>
#import "THNShareViewController.h"
#import "THNLoginManager.h"
#import "THNUserModel.h"

#define kTextInTitle(obj) [NSString stringWithFormat:@"@%@邀请你一起来乐喜", obj]

static NSString *const kTitleInvitation = @"邀请好友开馆";
static NSString *const kTextFriends     = @"邀请好友开馆赚钱";
static NSString *const kTextInvitation  = @"开一个能赚钱的生活馆";
/// url
static NSString *const kURLInvitation = @"https://h5.lexivip.com/propaganda_team";

@interface THNLifeInviteStoreViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *doneView;
@property (nonatomic, strong) THNUserModel *userModel;

@end

@implementation THNLifeInviteStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadInvitation];
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    [self thn_openShareImageController];
}

#pragma mark - private methods
- (void)loadInvitation {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kURLInvitation]];
    
    [self.webView loadRequest:urlRequest];
}

// 邀请好友开馆海报
- (void)thn_openShareImageController {
    NSString *lifeStoreId = [THNLoginManager sharedManager].storeRid;
    
    if (!lifeStoreId.length) return;
    
    THNUserDataModel *userModel = [THNUserDataModel mj_objectWithKeyValues:[THNLoginManager sharedManager].userData];
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeInvitation)
                                                                         requestId:lifeStoreId];
    [shareVC shareObjectWithTitle:kTextInTitle(userModel.username)
                            descr:kTextInvitation
                        thumImage:userModel.avatar
                           webUrl:kURLInvitation];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

#pragma mark - setup UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
    [self.doneView addSubview:self.doneButton];
    [self.view addSubview:self.doneView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.title = kTitleInvitation;
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
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 10;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        webConfig.preferences = preferences;
        webConfig.userContentController = [[WKUserContentController alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:webConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _webView.scrollView.showsVerticalScrollIndicator = NO;
    }
    return _webView;
}

- (UIView *)doneView {
    if (!_doneView) {
        CGFloat viewH = kDeviceiPhoneX ? 86 : 54;
        _doneView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewH, SCREEN_WIDTH, viewH)];
        _doneView.backgroundColor = [UIColor whiteColor];
    }
    return _doneView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, 44)];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton setTitle:kTitleInvitation forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

@end
