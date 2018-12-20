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
#import "UIView+Helper.h"
#import "THNPosterManager.h"
#import "UIImageView+WebImage.h"

static NSString *const kTextCancel = @"取消";
static NSString *const kShareSuccessTitle = @"分享成功";
static NSString *const kShareFailureTitle = @"分享失败";

@interface THNShareViewController () <THNShareActionViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) THNShareActionView *thirdActionView;
@property (nonatomic, strong) THNShareActionView *moreActionView;
@property (nonatomic, strong) THNShareActionView *posterActionView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *posterView;
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDescr;
@property (nonatomic, strong) UIImage *thumImage;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, assign) THNSharePosterType posterType;
@property (nonatomic, strong) NSString *requestId;

@end

@implementation THNShareViewController

- (instancetype)initWithType:(THNSharePosterType)posterType {
    self = [super init];
    if (self) {
        self.posterType = posterType;
    }
    return self;
}

- (instancetype)initWithType:(THNSharePosterType)posterType requestId:(NSString *)requestId {
    self = [super init];
    if (self) {
        self.posterType = posterType;
        self.requestId = requestId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - public methods
- (void)shareObjectWithTitle:(NSString *)title
                       descr:(NSString *)descr
                   thumImage:(NSString *)thumImageStr
                      webUrl:(NSString *)url {
    self.shareTitle = title;
    self.shareDescr = descr;
    self.shareUrl = url;
    
    if ([thumImageStr isValidUrl]) {
        self.thumImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL                                          URLWithString:thumImageStr]]];
        
    } else {
        self.thumImage = [UIImage imageNamed:thumImageStr];
    }
}

#pragma mark - custom delegate
- (void)thn_shareView:(THNShareActionView *)shareView didSelectedShareActionIndex:(NSInteger)index {
    if (shareView == self.thirdActionView) {
        [self shareWebPageToPlatformType:[self thn_getShareTypeWithIndex:index]];
        
    } else if (shareView == self.moreActionView) {
        if (index == 0) {
            if (!self.requestId.length) {
                [self systemShare];
                
            } else {
                [self thn_loadSharePosterImage];
            }
            
        } else if (index == 1) {
            [self systemShare];
        }
    
    } else if (shareView == self.posterActionView) {
        if (index == 0) {
            [self thn_savePosterImage];
            
        } else {
            [self sharePosterImageToPlatformType:[self thn_getShareTypeWithIndex:index - 1]];
        }
    }
}

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

/**
 友盟分享 小程序
 */
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

/**
 友盟分享 url
 */
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle
                                                                             descr:self.shareDescr
                                                                         thumImage:self.thumImage];
    shareObject.webpageUrl = self.shareUrl;
    messageObject.shareObject = shareObject;
    
    if (platformType == UMSocialPlatformType_Sina) {
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.thumbImage = self.thumImage;
        [shareObject setShareImage:self.thumImage];
    }
    
    WEAKSELF;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   [SVProgressHUD thn_showInfoWithStatus:kShareFailureTitle];
                                                   
                                               } else {
                                                   [SVProgressHUD thn_showSuccessWithStatus:kShareSuccessTitle];
                                               }
        
                                               [weakSelf thn_showAnimation:NO];
                                           }];
}

/**
 友盟分享 image
 */
- (void)sharePosterImageToPlatformType:(UMSocialPlatformType)platformType {
    if (!self.posterImageView.image) {
        [SVProgressHUD thn_showInfoWithStatus:@"海报加载出错了"];
        return;
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [UMShareImageObject new];
    shareObject.shareImage = self.posterImageView.image;
    messageObject.shareObject = shareObject;
    
    WEAKSELF;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   [SVProgressHUD thn_showInfoWithStatus:kShareFailureTitle];
                                                   
                                               } else {
                                                   [SVProgressHUD thn_showSuccessWithStatus:kShareSuccessTitle];
                                               }
                                               
                                               [weakSelf thn_showAnimation:NO];
                                           }];
}

#pragma mark - private methods
- (void)thn_loadSharePosterImage {
    [self thn_updateShareView];
    
    [SVProgressHUD thn_show];
    
    [THNPosterManager getSharePosterImageDataWithType:self.posterType
                                            requestId:self.requestId
                                           completion:^(NSString *imageUrl) {
                                               [self.posterImageView downloadImage:imageUrl
                                                                             place:nil
                                                                         completed:^(UIImage *image, NSError *error) {
                                                                             [SVProgressHUD dismiss];
                                                                         }];
                                           }];
}

- (void)thn_updateShareView {
    CGFloat frameH = kDeviceiPhoneX ? 184 : 152;
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.8
                        options:(UIViewAnimationOptionTransitionCrossDissolve)
                     animations:^{
                         self.thirdActionView.hidden = YES;
                         self.moreActionView.hidden = YES;
                         self.posterActionView.frame = CGRectMake(0, 112, SCREEN_WIDTH, 112);
                         self.posterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - frameH);

                     } completion:nil];
}

- (void)thn_savePosterImage {
    if (!self.posterImageView.image) {
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(self.posterImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD thn_showErrorWithStatus:@"保存失败"];
        
    } else {
        [SVProgressHUD thn_showSuccessWithStatus:@"已保存到相册"];
        [self thn_showAnimation:NO];
    }
}

- (UMSocialPlatformType)thn_getShareTypeWithIndex:(NSInteger)index {
    NSDictionary *typeDict = @{@(0): @(UMSocialPlatformType_WechatSession),
                               @(1): @(UMSocialPlatformType_WechatTimeLine),
                               @(2): @(UMSocialPlatformType_Sina),
                               @(3): @(UMSocialPlatformType_QQ),
                               @(4): @(UMSocialPlatformType_Qzone)};
    
    NSNumber *type = typeDict[@(index)];
    
    return (UMSocialPlatformType)type.integerValue;
}

#pragma mark - event response
- (void)cancelButtonAction:(UIButton *)button {
    [self thn_showAnimation:NO];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    
    [self.containerView addSubview:self.posterActionView];
    [self.containerView addSubview:self.thirdActionView];
    [self.containerView addSubview:self.moreActionView];
    [self.containerView addSubview:self.cancelButton];
    [self.view addSubview:self.containerView];
    [self.posterView addSubview:self.posterImageView];
    [self.view addSubview:self.posterView];
    
    if (!self.requestId.length) {
        [self.moreActionView hiddenSaveImageButton];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)thn_showAnimation:(BOOL)show {
    CGFloat frameH = kDeviceiPhoneX ? 296 : 264;
    CGFloat originY = show ? SCREEN_HEIGHT - frameH : SCREEN_HEIGHT;
    CGFloat alpha = show ? 0.4 : 0;
    self.posterView.hidden = !show;
    
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
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 224, SCREEN_WIDTH, 40)];
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
                                                               type:(THNShareActionViewTypeImage)];
        _moreActionView.delegate = self;
    }
    return _moreActionView;
}

- (THNShareActionView *)posterActionView {
    if (!_posterActionView) {
        _posterActionView = [[THNShareActionView alloc] initWithFrame:CGRectMake(0, -112, SCREEN_WIDTH, 112)
                                                                 type:(THNShareActionViewTypePoster)];
        _posterActionView.delegate = self;
    }
    return _posterActionView;
}

- (UIView *)posterView {
    if (!_posterView) {
        CGFloat originB = kDeviceiPhoneX ? 184 : 152;
        _posterView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - originB)];
        _posterView.backgroundColor = [UIColor whiteColor];
        
        [_posterView drawViewBorderType:(UIViewBorderLineTypeBottom) width:0.5 color:[UIColor colorWithHexString:@"E9E9E9"]];
    }
    return _posterView;
}

- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, CGRectGetHeight(self.posterView.frame) - 50)];
        _posterImageView.contentMode = UIViewContentModeScaleAspectFit;
        _posterImageView.backgroundColor = [UIColor whiteColor];
    }
    return _posterImageView;
}

@end
