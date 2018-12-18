//
//  THNInvitationViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNInvitationViewController.h"
#import <WebKit/WebKit.h>
#import "THNCashViewController.h"
#import "THNCashCertificationViewController.h"
#import "THNShareViewController.h"
#import "THNLoginManager.h"
#import <UMShare/UMShare.h>

/// text
static NSString *const kTitleInvitation     = @"邀请好友";
static NSString *const kTextShare           = @"开一个能赚钱的生活馆";
static NSString *const kShareSuccessTitle   = @"分享成功";
static NSString *const kShareFailureTitle   = @"分享失败";
static NSString *const kShareContent        = @"安利个我很喜欢的应用给你，报道先拿35元";
static NSString *const kShareDes            = @"挑选全球原创手作好物";
static NSString *const kShareContent1       = @"你还没有参加吗？安装乐喜app，挑全球原创手作好物";
static NSString *const kShareDes1           = @"每天都可以赚现金";
static NSString *const kShareContent2       = @"做颗喜糖，拿35元现金，逛全球优质设计师手作社群";
static NSString *const kShareDes2           = @"边玩边赚钱";
/// url
static NSString *const kURLInvitation   = @"https://h5.lexivip.com/invitation?uid=";
static NSString *const kURLShareUrl     = @"https://h5.lexivip.com/redenvelope?uid=";
/// script
static NSString *const kScriptShare     = @"share";
static NSString *const kScriptCash      = @"cashMoney";
static NSString *const kScriptShareF    = @"handleShareFriend";

@interface THNInvitationViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) THNUserModel *userModel;

@end

@implementation THNInvitationViewController

- (instancetype)initWithUserModel:(THNUserModel *)userModel {
    self = [super init];
    if (self) {
        self.userModel = userModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadInvitation];
}

#pragma mark - private methods
- (void)loadInvitation {
    NSString *loadUrl = [NSString stringWithFormat:@"%@%@", kURLInvitation, self.userModel.uid];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:loadUrl]];
    
    [self.webView loadRequest:urlRequest];
}

- (void)thn_openCashMoneyController {
    THNCashViewController *cashVC = [[THNCashViewController alloc] init];
    [self.navigationController pushViewController:cashVC animated:YES];
}

- (void)thn_openCashCertificationController {
    THNCashCertificationViewController *certificationVC = [[THNCashCertificationViewController alloc] init];
    [self.navigationController pushViewController:certificationVC animated:YES];
}

/**
 打开分享视图
 */
- (void)thn_openShareController {
    if (!self.userModel.uid.length) return;
    
    NSString *shareTitle = [self thn_getShareTitle];
    
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeNone)];
    [shareVC shareObjectWithTitle:shareTitle
                            descr:[self thn_getShareDesWithTitle:shareTitle]
                        thumImage:[self thn_getShareThumImage]
                           webUrl:[self thn_getShareUrl]];
    
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

/**
 单个平台的分享
 */
- (void)thn_singleShareWithIndex:(NSInteger)index {
    [self shareWebPageToPlatformType:[self thn_getShareTypeWithIndex:index]];
}

/**
 分享到微博
 */
- (void)thn_shareToWeibo {
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = [UIImage imageNamed:@"img_share_invite_wb"];
    [shareObject setShareImage:[UIImage imageNamed:@"img_share_invite_wb"]];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = [NSString stringWithFormat:@"%@%@", [self thn_getShareTitle], [self thn_getShareUrl]];
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina
                                        messageObject:messageObject
                                currentViewController:self completion:^(id data, NSError *error) {
                                    if (error) {
                                        [SVProgressHUD thn_showInfoWithStatus:kShareFailureTitle];
                                        
                                    } else{
                                        [SVProgressHUD thn_showSuccessWithStatus:kShareSuccessTitle];
                                    }
                                }];
}

/**
 友盟分享 url
 */
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    UIImage *shareImage = [UIImage imageNamed:[self thn_getShareThumImage]];
    NSString *shareTitle = [self thn_getShareTitle];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle
                                                                             descr:[self thn_getShareDesWithTitle:shareTitle]
                                                                         thumImage:shareImage];
    shareObject.webpageUrl = [self thn_getShareUrl];
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   [SVProgressHUD thn_showInfoWithStatus:kShareFailureTitle];
                                                   
                                               } else {
                                                   [SVProgressHUD thn_showSuccessWithStatus:kShareSuccessTitle];
                                               }
                                           }];
}

/**
 分享的平台
 */
- (UMSocialPlatformType)thn_getShareTypeWithIndex:(NSInteger)index {
    NSDictionary *typeDict = @{@(0): @(UMSocialPlatformType_WechatSession),
                               @(1): @(UMSocialPlatformType_WechatTimeLine),
                               @(2): @(UMSocialPlatformType_Sina),
                               @(3): @(UMSocialPlatformType_QQ),
                               @(4): @(UMSocialPlatformType_Qzone)};
    
    NSNumber *type = typeDict[@(index)];
    
    return (UMSocialPlatformType)type.integerValue;
}

- (NSString *)thn_getShareUrl {
    if (self.userModel.uid.length) {
        return [NSString stringWithFormat:@"%@%@", kURLShareUrl, self.userModel.uid];
    }
    
    return kURLShareUrl;
}

- (NSString *)thn_getShareTitle {
    NSArray *shareTitles = @[kShareContent, kShareContent1, kShareContent2];
    
    return shareTitles[arc4random_uniform(3)];
}

- (NSString *)thn_getShareDesWithTitle:(NSString *)title {
    NSDictionary *shareDec = @{kShareContent : kShareDes,
                               kShareContent1: kShareDes1,
                               kShareContent2: kShareDes2};
    
    return shareDec[title];
}

- (NSString *)thn_getShareThumImage {
    NSArray *thumImages = @[@"img_share_invite_0", @"img_share_invite_1", @"img_share_invite_2"];
    
    return thumImages[arc4random_uniform(3)];
}

#pragma mark - setup UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.title = kTitleInvitation;
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:kScriptShare];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:kScriptCash];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:kScriptShareF];
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

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:kScriptShare]) {
        [self thn_openShareController];
        
    } else if ([message.name isEqualToString:kScriptCash]) {
//        [self thn_openCashMoneyController];
        [self thn_openCashCertificationController];
        
    } else if ([message.name isEqualToString:kScriptShareF]) {
        NSInteger index = [message.body integerValue];
        if (index == 2) {
            [self thn_shareToWeibo];
            
        } else {
            [self thn_singleShareWithIndex:index];
        }
    }
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
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _webView.scrollView.showsVerticalScrollIndicator = NO;
    }
    return _webView;
}

#pragma mark
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kScriptShare];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kScriptCash];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kScriptShareF];
}

@end
