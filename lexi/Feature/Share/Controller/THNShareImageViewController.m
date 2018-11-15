//
//  THNShareImageViewController.m
//  lexi
//
//  Created by FLYang on 2018/11/3.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "THNLoginManager.h"
#import "UIView+Helper.h"
#import "UIImageView+SDWedImage.h"

/// url
static NSString *const kURLProductCard = @"/market/wxa_poster";
static NSString *const kURLShopWindow  = @"/market/share/shop_window_poster";

/// key
static NSString *const kKeyRid       = @"rid";
// 平台类型 1=品牌馆, 2=生活馆, 3=独立小程序分享商品, 4=核心平台分享商品
static NSString *const kKeyType      = @"type";
// 场景参数： 商品编号-生活馆编号 例：8945120367-94395210
static NSString *const kKeyScene     = @"scene";
// 访问路径
static NSString *const kKeyPath      = @"path";
// 小程序id
static NSString *const kKeyAuthAppId = @"auth_app_id";

/// text
static NSString *const kTextSaveImage = @"保存到本地相册";

@interface THNShareImageViewController () <THNNavigationBarViewDelegate>

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIButton *saveImageButton;
@property (nonatomic, assign) THNSharePosterType posterType;
@property (nonatomic, strong) NSString *requestId;

@end

@implementation THNShareImageViewController

- (instancetype)initWithType:(THNSharePosterType)type requestId:(NSString *)requestId {
    self = [super init];
    if (self) {
        self.posterType = type;
        self.requestId = requestId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_networkPosterImageData];
}

#pragma mark - network
- (void)thn_networkPosterImageData {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI postWithUrlString:[self thn_getRequestUrl]
                                  requestDictionary:[self thn_getRequestParams]
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [weakSelf.showImageView downloadImage:result.data[@"image_url"]];
        [weakSelf thn_setSaveButtonStatus:YES];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (NSString *)thn_getRequestUrl {
    NSDictionary *urlDict = @{@(THNSharePosterTypeGoods): kURLProductCard,
                              @(THNSharePosterTypeWindow): kURLShopWindow};
    
    return urlDict[@(self.posterType)];
}

- (NSDictionary *)thn_getRequestParams {
    if (self.requestId.length) {
        NSDictionary *defaultParam = @{kKeyAuthAppId: kWxaAuthAppId,
                                       kKeyPath: kWxaPath,
                                       kKeyScene: [self thn_paramsScene],
                                       kKeyRid: self.requestId};
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        
        if (self.posterType == THNSharePosterTypeGoods) {
            [paramDict setValuesForKeysWithDictionary:defaultParam];
            [paramDict setObject:@(4) forKey:kKeyType];
            
        } else if (self.posterType == THNSharePosterTypeWindow) {
            [paramDict setValuesForKeysWithDictionary:defaultParam];
        }
        
        return [paramDict copy];
    }
    
    return [NSDictionary dictionary];
}

/**
 场景编号
 */
- (NSString *)thn_paramsScene {
    NSString *storeId = [THNLoginManager sharedManager].storeRid.length ? [THNLoginManager sharedManager].storeRid : @"";
    NSString *scene = [NSString stringWithFormat:@"%@-%@", self.requestId, storeId];
    
    return scene;
}

#pragma mark - event response
- (void)saveImageButtonAction:(UIButton *)button {
    if (![self thn_getPHAuthorizationStatus] || self.showImageView.image == nil) {
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(self.showImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD thn_showErrorWithStatus:@"保存失败"];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [SVProgressHUD thn_showSuccessWithStatus:@"已保存到相册"];
        }];
    }
}

- (void)closeButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
/**
 获取授权状态
 */
- (BOOL)thn_getPHAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"请到设置-隐私-相机/相册中打开授权设置"
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"我知道了"
                                                             style:(UIAlertActionStyleDefault)
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self thn_openSystemSetup];
                                                           }];
        
        [alertController addAction:doneAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

/**
 打开系统设置
 */
- (void)thn_openSystemSetup {
    NSURL *setupUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:setupUrl]) {
        [[UIApplication sharedApplication] openURL:setupUrl];
    }
}

/**
 保存图片按钮的状态
 */
- (void)thn_setSaveButtonStatus:(BOOL)status {
    self.saveImageButton.alpha = status ? 1 : 0.5;
    self.saveImageButton.userInteractionEnabled = status;
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB" alpha:1];
    
    [self.view addSubview:self.showImageView];
    [self.view addSubview:self.saveImageButton];
    
    [self thn_setSaveButtonStatus:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationTransparent:YES showShadow:NO];
    [self.navigationBarView setNavigationCloseButtonOfImageNamed:@"icon_popup_close"];
}

- (void)didNavigationCloseButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_setSubviewFrame];
}

- (void)thn_setSubviewFrame {
    CGFloat originBottom = kDeviceiPhoneX ? 78 : 60;
    CGRect imageFrame = CGRectMake(20, 69, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 170);
    CGRect buttonFrame = CGRectMake(20, SCREEN_HEIGHT - originBottom, SCREEN_WIDTH - 40, 40);
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                            self.showImageView.frame = imageFrame;
                            self.saveImageButton.frame = buttonFrame;
                            
                        } completion:nil];
}

#pragma mark - getters and setters
- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, -SCREEN_HEIGHT, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 180)];
        _showImageView.image = [UIImage imageNamed:@"default_image_place"];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    }
    return _showImageView;
}

- (UIButton *)saveImageButton {
    if (!_saveImageButton) {
        _saveImageButton = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT, SCREEN_WIDTH - 40, 40)];
        _saveImageButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_saveImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_saveImageButton setTitle:kTextSaveImage forState:(UIControlStateNormal)];
        _saveImageButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveImageButton addTarget:self action:@selector(saveImageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_saveImageButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    }
    return _saveImageButton;
}

@end
