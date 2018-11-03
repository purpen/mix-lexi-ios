//
//  THNShareImageViewController.m
//  lexi
//
//  Created by FLYang on 2018/11/3.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareImageViewController.h"
#import "UIView+Helper.h"
#import "UIImageView+SDWedImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *const kTextSaveImage = @"保存图片";

@interface THNShareImageViewController ()

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIButton *saveImageButton;

@end

@implementation THNShareImageViewController

- (instancetype)initWithType:(NSUInteger)type {
    self = [super init];
    if (self) {
        
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
    [self.showImageView downloadImage:@"https://kg.erp.taihuoniao.com/lexi/20181026/qKWEskxhCPyLoSrFYwdX.png"
                                place:[UIImage imageNamed:@"default_image_place"]];
    
    [SVProgressHUD dismissWithDelay:(NSTimeInterval)2];
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
        [SVProgressHUD thn_showSuccessWithStatus:@"已保存到相册"];
        [self thn_setSubviewFrameShow:NO];
    }
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

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self.view addSubview:self.showImageView];
    [self.view addSubview:self.saveImageButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_setSubviewFrameShow:YES];
}

- (void)thn_setSubviewFrameShow:(BOOL)show {
    CGFloat imageOriginY = show ? 60 : -SCREEN_HEIGHT;
    CGRect imageFrame = CGRectMake(20, imageOriginY, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 170);
    
    CGFloat buttonOriginY = show ? SCREEN_HEIGHT - 80 : SCREEN_HEIGHT;
    CGRect buttonFrame = CGRectMake((SCREEN_WIDTH - 230) / 2, buttonOriginY, 230, 40);
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                            self.showImageView.frame = imageFrame;
                            self.saveImageButton.frame = buttonFrame;
                            
                        } completion:^(BOOL finished) {
                            if (!show) {
                                [self dismissViewControllerAnimated:NO completion:nil];
                            }
                        }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (touch.view != self.showImageView) {
        [self thn_setSubviewFrameShow:NO];
    }
}

#pragma mark - getters and setters
- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, -SCREEN_HEIGHT, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 180)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    }
    return _showImageView;
}

- (UIButton *)saveImageButton {
    if (!_saveImageButton) {
        _saveImageButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 230) / 2, SCREEN_HEIGHT, 230, 40)];
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
