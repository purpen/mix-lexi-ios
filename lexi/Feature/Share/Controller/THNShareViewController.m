//
//  THNShareViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShareViewController.h"
#import "THNShareActionView.h"
#import <UMShare/UMShare.h>
#import "SVProgressHUD+Helper.h"

static NSString *const kTextCancel = @"取消";
static NSString *const kShareSuccessTitle = @"分享成功";
static NSString *const kShareFailureTitle = @"分享失败";

@interface THNShareViewController () <THNShareActionViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) THNShareActionView *thirdActionView;
@property (nonatomic, strong) THNShareActionView *moreActionView;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDescr;
@property (nonatomic, strong) UIImage *thumImage;
@property (nonatomic, strong) NSString *shareUrl;

@end

@implementation THNShareViewController

- (instancetype)initWithType:(ShareContentType)type {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)shareObjectWithTitle:(NSString *)title
                       descr:(NSString *)descr
                   thumImage:(NSString *)thumImageStr
                      webUrl:(NSString *)url {
    self.shareTitle = title;
    self.shareDescr = descr;
    self.shareUrl = url;
    
    if ([thumImageStr isValidUrl]) {
        self.thumImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL                                             URLWithString:thumImageStr]]];
    } else {
        self.thumImage = [UIImage imageNamed:thumImageStr];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_shareView:(THNShareActionView *)shareView didSelectedShareActionIndex:(NSInteger)index {
    if (shareView == self.thirdActionView) {
        switch (index) {
            case 0:
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
                break;
            case 1:
                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
                break;
            case 2:
                [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
                break;
            case 3:
                [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
                break;
            case 4:
                [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
                break;
        }
        
    } else if (shareView == self.moreActionView) {
        [self systemShare];
    }
}

// 系统分享
- (void)systemShare {
    NSArray *activityItems = [[NSArray alloc] initWithObjects:self.shareTitle, self.thumImage, self.shareUrl, nil];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        
        if (completed) {
            [SVProgressHUD thn_showInfoWithStatus:kShareSuccessTitle];
            
        } else {
            [SVProgressHUD thn_showInfoWithStatus:kShareFailureTitle];
        }

        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.completionWithItemsHandler = myBlock;

    [self presentViewController:vc animated:YES completion:nil];
}

// 友盟分享小程序
- (void)shareMiniProgramToPlatformType:(UMSocialPlatformType)platformType {
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:self.shareTitle descr:self.shareDescr thumImage:self.thumImage];
    shareObject.webpageUrl = self.shareUrl;
    shareObject.userName = @"gh_65428219bffb";
    shareObject.path = @"/pages/index/index";
    messageObject.shareObject = shareObject;
    shareObject.hdImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
    
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   UMSocialLogInfo(@"************Share fail with error %@*********",error);
                                                   
                                               } else {
                                                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                       UMSocialShareResponse *resp = data;
                                                       //分享结果消息
                                                       UMSocialLogInfo(@"response message is %@",resp.message);
                                                       //第三方原始返回的数据
                                                       UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                                       
                                                   } else {
                                                       UMSocialLogInfo(@"response data is %@",data);
                                                   }
                                               }
                                           }];
}

// 友盟分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle
                                                                             descr:self.shareDescr
                                                                         thumImage:self.thumImage];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    WEAKSELF;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   THNLog(@"share -- %@", error);
                                                   [SVProgressHUD thn_showInfoWithStatus:kShareFailureTitle];
                                                   
                                               } else {
                                                   [SVProgressHUD thn_showSuccessWithStatus:kShareSuccessTitle];
                                               }
        
                                               [weakSelf thn_showAnimation:NO];
                                           }];
}

#pragma mark - event response
- (void)cancelButtonAction:(UIButton *)button {
    [self thn_showAnimation:NO];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    
    [self.containerView addSubview:self.thirdActionView];
    [self.containerView addSubview:self.moreActionView];
    [self.containerView addSubview:self.cancelButton];
    [self.view addSubview:self.containerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES];
    self.cancelButton.frame = CGRectMake(0, 224, SCREEN_WIDTH, 40);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)thn_showAnimation:(BOOL)show {
    CGFloat frameH = kDeviceiPhoneX ? 296 : 264;
    CGFloat originY = show ? SCREEN_HEIGHT - frameH : SCREEN_HEIGHT;
    CGFloat alpha = show ? 0.4 : 0;
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.8
                        options:(UIViewAnimationOptionTransitionCrossDissolve)
                     animations:^{
                         self.containerView.frame = CGRectMake(0, originY, SCREEN_WIDTH, frameH);
                         self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:alpha];
                         
                     } completion:^(BOOL finished) {
                         if (!show) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (touch.view != self.containerView) {
        [self thn_showAnimation:NO];
    }
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        CGFloat frameH = kDeviceiPhoneX ? 296 : 264;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, frameH)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:kTextCancel forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelButton;
}

- (THNShareActionView *)thirdActionView {
    if (!_thirdActionView) {
        _thirdActionView = [[THNShareActionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 112)
                                                                type:(THNShareActionViewTypeThird)];
        _thirdActionView.delegate = self;
    }
    return _thirdActionView;
}

- (THNShareActionView *)moreActionView {
    if (!_moreActionView) {
        _moreActionView = [[THNShareActionView alloc] initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, 112)
                                                               type:(THNShareActionViewTypeMore)];
        _moreActionView.delegate = self;
    }
    return _moreActionView;
}

@end
